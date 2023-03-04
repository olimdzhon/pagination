//
//  ViewController.swift
//  Pagination
//
//  Created by Олимджон Садыков on 02/03/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var limit = 20
    private var parentId = 0
    private var lastPosition = CGFloat()
    
    private var prev = [Prev]()
    private var data = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DatabaseCaller.shared.fetchData(pagination: false, limit: limit, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                self?.tableView.reloadData()
                
                
            case .failure(_):
                break
            }
        })
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        guard prev.count != 0 else {
            print("Prev count is 0")
            return
        }
        guard let state = prev.last else {
            print("State not found")
            return}
        
        parentId = state._parent_id
        limit = state.limit
        
        DatabaseCaller.shared.fetchData(pagination: false, parentId: parentId, limit: limit, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                self?.tableView.reloadData()
                self?.prev.removeLast()
                
                if self?.prev.count == 0 {
                    self?.backButton.isHidden = true
                    self?.parentId = 0
                }
                
            case .failure(_):
                break
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.text = "\(data[indexPath.row]._id) \(data[indexPath.row]._name) \(data[indexPath.row].count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowCount = data[indexPath.row].count
        
        if rowCount == 0 {
            return
        }
        
        prev.append(Prev(lastPosition: lastPosition, _parent_id: data[indexPath.row]._parent_id, limit: limit))
        limit = 20
        parentId = data[indexPath.row]._id
        
        if backButton.isHidden {
            backButton.isHidden = false
        }
        
        DatabaseCaller.shared.fetchData(pagination: false, parentId: parentId, limit: limit, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                self?.tableView.reloadData()
            case .failure(_):
                break
            }
        })
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        lastPosition = position
        
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            // fetch more data
            guard !DatabaseCaller.shared.isPaginating else {
                // we are already fetching more data
                return
            }
            DatabaseCaller.shared.isPaginating = true
            self.tableView.tableFooterView = createSpinnerFooter()
            limit += 20
            DatabaseCaller.shared.fetchData(pagination: true, parentId: parentId, limit: limit) { [weak self] result in
                
                self?.tableView.tableFooterView = nil
                
                switch result {
                case .success(let moreData):
                    self?.data = moreData
                    self?.tableView.reloadData()
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                        DatabaseCaller.shared.isPaginating = false
                    })
                    
                case .failure(_):
                    break
                }
            }
        }
    }
}


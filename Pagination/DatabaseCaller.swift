//
//  APICaller.swift
//  Pagination
//
//  Created by Олимджон Садыков on 02/03/23.
//

import Foundation

class DatabaseCaller {
    var isPaginating = false
    
    static let shared = DatabaseCaller()
    
    func fetchData(pagination: Bool = false, completion: @escaping(Result<[String], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
        DispatchQueue.global().asyncAfter(deadline:  .now() + (pagination ? 3 : 2), execute: {
            let oridinalData = [
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
                "Apple",
                "Google",
                "Facebook",
            ]
            
            let newData = [
                "banana", "oranges", "grapes", "Food"
            ]
            
            
            completion(.success(pagination ? newData : oridinalData))
            if pagination {
                self.isPaginating = false
            }
        })
    }
}

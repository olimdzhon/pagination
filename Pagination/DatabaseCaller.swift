//
//  APICaller.swift
//  Pagination
//
//  Created by Олимджон Садыков on 02/03/23.
//

import Foundation
import SQLite3

class DatabaseCaller {
    var isPaginating = false
    
    static let shared = DatabaseCaller()
    
    func fetchData(pagination: Bool = false, parentId: Int? = nil, limit: Int, completion: @escaping(Result<[Row], Error>) -> Void) {
                
        var data = [Row]()
        
        // SELECT QUERY
        
        let selectStatementString = "SELECT _id, _name, _parent_id FROM tt WHERE _parent_id = \(parentId ?? 0) ORDER BY _name ASC LIMIT \(limit)"
        
        var selectStatementQuery: OpaquePointer?
        
        if (sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStatementQuery, nil)) == SQLITE_OK {
            while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(selectStatementQuery, 0))
                let count = self.getCount(parentId: id)
                let row = Row(_id: id, _name: String(cString: sqlite3_column_text(selectStatementQuery, 1)), _parent_id: Int(sqlite3_column_int(selectStatementQuery, 2)), count: count)
                
                data.append(row)
            }
            
            sqlite3_finalize(selectStatementQuery)
        }
        
        completion(.success(data))
    }
    
    private func getCount(parentId: Int) -> Int {
        var count = 0
        let selectStatementString = "SELECT COUNT(*) FROM tt WHERE _parent_id = \(parentId)"
        
        var selectStatementQuery: OpaquePointer?
        
        if (sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStatementQuery, nil)) == SQLITE_OK {
            while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                count = Int(sqlite3_column_int(selectStatementQuery, 0))
            }
            
            sqlite3_finalize(selectStatementQuery)
        }
        
        return count
    }
}

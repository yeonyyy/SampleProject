//
//  LocalService.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/22.
//

import Foundation
import SQLite3

final class LocalService {
    var db : OpaquePointer?
    let path = "myDb.sqlite"
    let table = "queries"
    
    static let shared = LocalService()
    
    init() {
        self.db = createDataBase()
        createTable()
    }
    
    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }
    
    private func createDataBase() -> OpaquePointer?  {
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
            if sqlite3_open(filePath.path, &db) == SQLITE_OK {
                return db
            }
        }
        catch {
            print("error in createDB")
        }
        print("error in createDB - sqlite3_open")
        return nil
    }
    
    private func createTable() {
        guard db != nil else { return }
        
        var statement: OpaquePointer? = nil
        
        let query = """
                        create table if not exists \(table) (
                            id                  INTEGER primary key autoincrement,
                            category            TEXT NOT NULL,
                            query               TEXT NOT NULL,
                            date                TEXT NOT NULL
                        )
                        """
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Creating table has been succesfully done. db: \(String(describing: db))")
            }
        }
        
        sqlite3_finalize(statement)
    }
    
    func insert(category: String, keyword: String, date: String) {
        guard db != nil else { return }
        if checkDuplicate(category: category, keyword: keyword){
            updateData(category: category, keyword: keyword, date: date)
        }else {
            insertData(category: category, keyword: keyword, date: date)
        }
    }
    
    func checkDuplicate(category: String, keyword: String) -> Bool {
        var stmt: OpaquePointer?
        
        let query = """
                    SELECT *
                    FROM \(table)
                    WHERE category = '\(category)' and query = '\(keyword)'
                    """
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW {
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
    
    func updateData(category: String, keyword: String, date: String) {
        var statement: OpaquePointer?
        
        let queryString = "UPDATE \(table) SET date = \(date) WHERE category = '\(category)' and keyword = '\(keyword)'"
        
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        print("Update has been successfully done")
    }
    
    func insertData(category: String, keyword: String, date: String)  {
        guard db != nil else { return }
        
        var stmt: OpaquePointer?
        
        let query = "INSERT INTO \(table) (category,query,date) VALUES (?, ?, ?)"
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            let category = category as NSString
            sqlite3_bind_text(stmt, 1, category.utf8String, -1, nil)
            let keyword = keyword as NSString
            sqlite3_bind_text(stmt, 2, keyword.utf8String, -1, nil)
            let date = date as NSString
            sqlite3_bind_text(stmt, 3, date.utf8String, -1, nil)
        }else {
            print("sqlite binding failure")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("sqlite insertion success")
        }else {
            print("sqlite step failure")
        }
    }
    
    func readData() -> [History]? {
        var stmt: OpaquePointer?
        
        var result : [History] = []
        
        let query = "select * from \(table)"
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id = sqlite3_column_int(stmt, 0)
                let category = String(cString: sqlite3_column_text(stmt, 1))
                let keyword = String(cString: sqlite3_column_text(stmt, 2))
                let date = String(cString: sqlite3_column_text(stmt, 3))
                result.append(History(id: Int(id), category: category, keyword: keyword, date: date))
            }
            sqlite3_finalize(stmt)
        }else {
            onSQLErrorPrintErrorMessage(db)
        }
        return result
    }
    
    func deleteData(id: Int)  {
        guard db != nil else { return }
        
        var stmt: OpaquePointer?
        
        let query = "DELETE FROM \(table) WHERE id==\(id) "
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("delete has been successfully done")
            }else {
                onSQLErrorPrintErrorMessage(db)
            }
        }else {
            onSQLErrorPrintErrorMessage(db)
        }
    }
    
    private func onSQLErrorPrintErrorMessage(_ db: OpaquePointer?) {
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("Error preparing update: \(errorMessage)")
        return
    }
    
}

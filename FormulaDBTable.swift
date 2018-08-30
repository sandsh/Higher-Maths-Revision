//
//  FormulaDBTable.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 23/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import SQLite3

class FormulaDBTable {
    
    var formulaList = [Formula]()
    var tableName = "FormulaTable"
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("FormulaTable.sqlite")
    
    func openFormulaTable(){
        
        var dbPointer:OpaquePointer?
        
        //Try opening the database - error if any problems
        if sqlite3_open(fileURL.path, &dbPointer) == SQLITE_OK {
            print("path opened")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error opening database  \(errmsg)")
        }
        
        //Create the table if it doesn't exist
        if sqlite3_exec(dbPointer, "CREATE TABLE IF NOT EXISTS \(tableName) (id INTEGER PRIMARY KEY AUTOINCREMENT, topic TEXT, unit INT, title TEXT, formulaImage TEXT )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error creating table \(errmsg)")
        } else {print("table created")}
        

    }
    func addFormula (newFormula:Formula) {
        
        var table: OpaquePointer?
        
        //MARK:  SQL  - setting up the database
        if sqlite3_open(fileURL.path, &table) != SQLITE_OK {
            print("error opening database")
            return
        }
        var inStatement: OpaquePointer?
        //should this be same as above - may need to pass in
        
        let queryString = "INSERT INTO \(tableName) (topic, unit, title, formulaImage) VALUES (?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(table, queryString, -1, &inStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        //binding the parameters - name
        if sqlite3_bind_text(inStatement, 1, newFormula.topic, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("error binding title: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(inStatement, 2, Int32(newFormula.unit) ) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("error binding level: \(errmsg)")
            return
        }
        if sqlite3_bind_text(inStatement, 3, newFormula.title, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("error binding image: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(inStatement, 4, newFormula.formulaImageStr, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("error binding Qtext: \(errmsg)")
            return
        }
        //executing the query
        if sqlite3_step(inStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("failure insert info: \(errmsg)")
            return
        }
        
        if sqlite3_finalize(inStatement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(table)!)
            print("error finalising statement: \(errmsg)")
        }
        
        print ("formula added to table")
    }
    
    func getFormulaFromTable() -> [Formula] {
        
        formulaList.removeAll()
        var dbPointer:OpaquePointer?
        // open the database and set pointer to it
        if sqlite3_open(fileURL.path, &dbPointer) != SQLITE_OK {
            print("error opening database")
        }
        if dbPointer == nil {
            return formulaList
        }
        
        //set up query to get everything from database
        let queryString = "SELECT * FROM \(tableName)"
        var stmPointer: OpaquePointer?

        //prepare the query
        if sqlite3_prepare(dbPointer, queryString, -1, &stmPointer, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error preparing Select: \(errmsg)")
        }
        
        //going through all the records of
        while(sqlite3_step(stmPointer) == SQLITE_ROW){
            let id = sqlite3_column_int(stmPointer, 0)
            let topic = String(cString: sqlite3_column_text(stmPointer, 1))
            let unit = sqlite3_column_int(stmPointer, 2)
            let title = String(cString: sqlite3_column_text(stmPointer, 3))
            let imgStrOut = String(cString: sqlite3_column_text(stmPointer, 4))
            
            print("topic and title \(topic) \(title) ")
            formulaList.append(Formula(id: Int(id), topic: topic, unit: Int(unit), title: title, formulaImageStr: imgStrOut))
        }
        
        if sqlite3_finalize(stmPointer) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error finalizing prepared statement: \(errmsg)")
            
        }
        //close the table - keep it from leaking (but does finalisze do that?)
        //but all statemnets must be finished before closing ??
        //this could cause problems
//        if sqlite3_close(dbPointer) != SQLITE_OK {
//            print("error closing database")
//        }
        //should we close table here?
        return formulaList
        
    }
    func deleteFormulaOnDB (formulaID: Int) {
        
        var dbPointer:OpaquePointer?
        
        if sqlite3_open(fileURL.path, &dbPointer) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error opening database")
            //          return
            // return nothing causes error - need to check this if not returning
        }
        
        var deleteSmt: OpaquePointer? = nil
        
        let deleteStr = "DELETE FROM \(tableName) WHERE ID = \(formulaID)"
        
        if sqlite3_prepare(dbPointer, deleteStr, -1, &deleteSmt, nil) == SQLITE_OK {
            if sqlite3_step(deleteSmt) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
                print("Could not delete row.")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("DELETE statement could not be prepared ")
        }
        
        if sqlite3_finalize(deleteSmt) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error finalizing prepared statement: \(errmsg)")
            
        }
        
    }
}




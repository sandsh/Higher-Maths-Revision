//
//  SetUpDatabase.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 29/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import SQLite3

class SetUpDatabase {
    
    var inQuestions = [Question]()
    var tableName = "questionsTable4"
    func openOrCreateDB(fileURL: URL){
        
        var dbPointer:OpaquePointer?
        
        //Try opening the database - error if any problems
        if sqlite3_open(fileURL.path, &dbPointer) == SQLITE_OK {
            print("path opened")
        } else {
            print("error opening database")
        }
        
        print("creating table in call openOr")
        
        //Create the table if it doesn't exist
        if sqlite3_exec(dbPointer, "CREATE TABLE IF NOT EXISTS \(tableName) (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, qText TEXT, imageStr TEXT, correctAnswer TEXT, wrongAnswers TEXT, solution TEXT, hint TEXT, level TEXT, unit Text, topic TEXT, tags TEXT, qType TEXT )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error creating table \(errmsg)")
        } else {print("table created")}
        
    }
    
    func doesTableExist (fileURL: URL) -> Bool{
        
        var dbPointer:OpaquePointer?

        if sqlite3_open(fileURL.path, &dbPointer) == SQLITE_OK {
            print("path opened")
        }
        var Exist:Bool = true
        let queryString2 = "SELECT * FROM \(tableName)"
        var stmPointer: OpaquePointer?
        
        //prepare the query - see if any data
        if sqlite3_prepare(dbPointer, queryString2, -1, &stmPointer, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error preparing Select: \(errmsg)")
            Exist = false
            print("table doesn't exist")
        } else {
                print("table ok")
                Exist = true
        }
        return Exist
        
//        "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='table_name'"
        
    }
    func addValuesToDB (newQ:Question, fileURL:URL) {
        
        var db: OpaquePointer?

        //MARK:  SQL  - setting up the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return
        }
        var inStatement: OpaquePointer?
        //should this be same as above - may need to pass in
        
        let queryString = "INSERT INTO \(tableName) (title, qText, imageStr, correctAnswer, wrongAnswers, solution, hint, level, unit, topic, tags, qType) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &inStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        print(" insert new data at  \(newQ.answers) \(newQ.topic)")
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        //binding the parameters - name
        if sqlite3_bind_text(inStatement, 1, newQ.title, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding title: \(errmsg)")
            return
        } 
        
        if sqlite3_bind_text(inStatement, 2, newQ.qText, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding Qtext: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(inStatement, 3, newQ.imageStr, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding image: \(errmsg)")
            return
        }
        
        // concat answers - if multiple choice - multiple answers in db
        var ansString: String = ""
        if newQ.qType == "MC" {
            for ans in newQ.answers {
                ansString = ansString + "," + ans
            }
        }

        if sqlite3_bind_text(inStatement, 4, newQ.correctAns, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding answer: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(inStatement, 5, ansString, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding answer: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(inStatement, 6, newQ.solution, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding feedback: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(inStatement, 7, newQ.hint, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding hint: \(errmsg)")
            return
        }
        //concatenating code from unit, topic and level  -
        // why?? - leave seperate on DB - maybe just use code for entering
//        var dbCode: String = ""
//         dbCode = "\(newQ.unit)" + "," + newQ.topic + "," + "\(newQ.level)"
//
        if sqlite3_bind_int(inStatement, 8, Int32(newQ.level) ) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding level: \(errmsg)")
            return
        }
        
        //binding integers
        if sqlite3_bind_int(inStatement, 9, Int32(newQ.unit) ) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding unit: \(errmsg)")
            return
        }
        if sqlite3_bind_text(inStatement, 10, newQ.topic, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding topic: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(inStatement, 11, newQ.tags[0], -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding tags: \(errmsg)")
            return
        }
        if sqlite3_bind_text(inStatement, 12, newQ.qType, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding tags: \(errmsg)")
            return
        }
        
        //executing the query
        if sqlite3_step(inStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure insert info: \(errmsg)")
            return
        }
        
        if sqlite3_finalize(inStatement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalising statement: \(errmsg)")
        }
        
        print ("setup - values added to database")
    }
   
    
}


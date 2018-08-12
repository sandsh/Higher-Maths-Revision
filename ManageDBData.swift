//
//  ManageDBData.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 29/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import SQLite3

class ManageDBData {
    var tableName = "questionsTable4"
    var questionList = [Question]()
    let FileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("questionsTable4.sqlite")
    
    func openDB() -> OpaquePointer{
        var dbPointer:OpaquePointer? = nil
        
        if sqlite3_open(FileURL.path, &dbPointer) != SQLITE_OK {
            print("error opening database")
        }

        return dbPointer!
        
    }
    
    //GETDATAFROMDB
    func getDataFromDB() -> [Question] {
        
        questionList.removeAll()
        var dbPointer:OpaquePointer?
        // open the database and set pointer to it
        dbPointer = openDB()
        if dbPointer == nil {
            return questionList
        }
//
//        if sqlite3_open(FileURL.path, &dbPointer) != SQLITE_OK {
//            print("error opening database")
//  //          return
//   ***     // return nothing causes error - need to check this if not returning empty questionlist
//        }
        print("get daa - before sql in" )
        //set up query to get everything from database
        let queryString2 = "SELECT * FROM \(tableName)"
        var stmPointer: OpaquePointer?
        var answerAry = [String]()
        //prepare the query
        if sqlite3_prepare(dbPointer, queryString2, -1, &stmPointer, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error preparing Select: \(errmsg)")
//            return
        }
        
        //going through all the records of
        while(sqlite3_step(stmPointer) == SQLITE_ROW){
            let idOut = sqlite3_column_int(stmPointer, 0)
            let titleOut = String(cString: sqlite3_column_text(stmPointer, 1))
            let textOut = String(cString: sqlite3_column_text(stmPointer, 2))
            let imgStrOut = String(cString: sqlite3_column_text(stmPointer, 3))
            let correctAnswer = String(cString: sqlite3_column_text(stmPointer, 4))
            let wrongAnswers = String(cString: sqlite3_column_text(stmPointer, 5))
            let solutionOut = String(cString: sqlite3_column_text(stmPointer, 6))
            let hintOut = String (cString: sqlite3_column_text(stmPointer, 7))
            let levelOut = sqlite3_column_int(stmPointer, 8)
            let unitOut = sqlite3_column_int(stmPointer, 9)
            let topicOut = String(cString: sqlite3_column_text(stmPointer, 10))
            let tagsOut = String(cString: sqlite3_column_text(stmPointer, 11))
            let qTypeOut = String(cString: sqlite3_column_text(stmPointer, 12))
            
            print("in loop round table  \(titleOut)")
            //unpack answers - randomise answers if it's a multiple choice question
            
            if qTypeOut == "MC" {
                //join the correct and wrong - we keep the correctAnswer seperate for checking in question
                let allAnswers = wrongAnswers + "," + correctAnswer
                answerAry = RandomiseAnswers(answers: allAnswers)
                //set as first one for now *** need anothe field on screen
            }
            
            //add to list of people
            questionList.append(Question(id: (Int(idOut)), title: titleOut, imageStr:imgStrOut, qText: textOut, correctAns: correctAnswer, answers: answerAry, solution: solutionOut, hint: hintOut, level: Int(levelOut), unit: Int(unitOut), topic: topicOut, tags: [tagsOut], qType:qTypeOut))
                        
        }

        if sqlite3_finalize(stmPointer) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer)!)
            print("error finalizing prepared statement: \(errmsg)")
            
        }
        //should we close table here?
        return questionList
    }
    
    func deleteQuestionOnDB (questionID: Int) {
        
        var dbPointer:OpaquePointer?
        
        if sqlite3_open(FileURL.path, &dbPointer) != SQLITE_OK {
            print("error opening database")
            //          return
            // return nothing causes error - need to check this if not returning
        }
        
        var deleteSmt: OpaquePointer? = nil
        
        let deleteStr = "DELETE FROM \(tableName) WHERE ID = \(questionID)"
        
        if sqlite3_prepare(dbPointer, deleteStr, -1, &deleteSmt, nil) == SQLITE_OK {
            if sqlite3_step(deleteSmt) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteSmt)
        
    }
    
    func deleteAll() -> Bool {
        
        var deleteSmt: OpaquePointer? = nil
        var dbPointer:OpaquePointer?
        // open the database and set pointer to it
        dbPointer = openDB()
        if dbPointer == nil {
            return false
        }
        
        let deleteStr = "DELETE FROM \(tableName) "
        
        if sqlite3_prepare(dbPointer, deleteStr, -1, &deleteSmt, nil) == SQLITE_OK {
            if sqlite3_step(deleteSmt) == SQLITE_DONE {
                print("Successfully deleted ALL.")
            } else {
                print("Could not delete all quesions.")
                return false
            }
        } else {
            print("DELETE ALL could not be prepared")
            return false
        }
        
        sqlite3_finalize(deleteSmt)
        let dropStr = "Drop table \(tableName) "
        
        if sqlite3_prepare(dbPointer, dropStr, -1, &deleteSmt, nil) == SQLITE_OK {
            if sqlite3_step(deleteSmt) == SQLITE_DONE {
                print("Table dropped ok.")
            }
        }
        
        return true
        
    }
    
    func RandomiseAnswers(answers : String) -> [String] {
        
        var answerAry = answers.split(separator: ",")
        //set up a dummy array and initialise it so we can replace each with a random order
        var newAry:  [String] = ["a", "b", "c", "d"]
        var randNum: Int
        
        var seq: [Int] = []      //EMPTY! hah ? initialised to number outwith range - max 4(or 5) anwsers
       //take each part of the split up string
        if answerAry.count == 5{
            answerAry.remove(at: 0)
        }
        for ans in answerAry {
            //get a random number up to 4
            randNum = Int(arc4random_uniform(4))
            //check if we've used this number before
            while seq.contains(randNum) {
                //get another number if it's used
                randNum = Int(arc4random_uniform(4))
            }
            //set our answer to this random place
            newAry[randNum] = String(ans)
            //add this number to our sequence so we know it's used
            seq.append(randNum)
        }
        return newAry
    }
//  delete versions of table - to be done **
//    func DropTable() {
//
//        var db:OpaquePointer?
//
//        if sqlite3_open(FileURL.path, &db) != SQLITE_OK {
//            print("error opening database")
//            //          return
//            // return nothing causes error - need to check this if not returning
//        }
//        // what table to drop and recreate
//        db.drop(table: "questionsTable2", ifExists: true) ?? not working
//    }
}
    


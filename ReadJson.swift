//
//  ReadJson.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 06/08/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import UIKit


class ReadJason {
    
    
    let setupDB = SetUpDatabase()
    
    static func data() -> [Question]{
        
        var questionList: [Question] = []
        
        if let jsonPath: String = Bundle.main.path(forResource: "QuestionData", ofType: "json"), let jsonData: Data = NSData(contentsOfFile: jsonPath) as Data? {
            do {
                let json: AnyObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as AnyObject
                
                if let questionDict = json as? [String: AnyObject]{
                    
                    let question = questionDict["questionList"] as? [[String: AnyObject]]
                    
                    print("got a dictionary")
                    for quest in question!  {
                        let title = quest["title"] as? String
                        let qtext = quest["qtext"] as? String
                        let imageStr = quest["image"] as? String
                        let solution = quest["solution"] as? [String]
                        let correct = quest["correctAns"] as? String
                        let answers = quest["answers"]
                        let  hint = quest["hint"] as? String
                        let  level = quest["level"] as? Int
                        let  topic = quest["topic"] as? String
                        let  unit = quest["unit"] as? Int
                        let  tags = quest["tags"] as? [String]
                        let type = quest["type"] as? String
 //                       let solutionImage = quest["solImage"] as? String
 //                       print(" out of json  \(title) \(qtext) \(hint)")
                        
 //                       let questionText: String
//                        let mathText = qtext!["mathLabel"]
//                        if mathText == "none" {
//                            questionText = qtext!["text"]!
//                        } else {
//                            questionText = qtext!["text"]! + "{" + mathText!
//                        }
                        
                        var solutionStr: String = ""
//                        if solutionImage == "none" {
                            for lines in solution! {
                                solutionStr = solutionStr + lines
                            }
//                        } else {
//                            solutionStr = solutionImage!
//                        }
                       
                        questionList.append(Question(id: 0, title: title!, imageStr:imageStr!, qText: qtext!, correctAns: correct!, answers: answers as! [String], solution: solutionStr, hint: hint!, level: level!, unit: unit!, topic: topic!, tags: tags!, qType:type!))
                        
                
                    }
                }
            } catch {
                print("Error while deserialization of jsonData")
            }
        }else {
            print("error getting json")
        }
        
        return questionList
    }
    

}

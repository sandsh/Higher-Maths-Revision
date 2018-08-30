//
//  ReadJson.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 06/08/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import UIKit


protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}


class ReadJson: NSObject, URLSessionDataDelegate {
    weak var delegate: HomeModelProtocol!
    
    let urlPath: String = "http://sandrahouston.uk/sands.json"
    
    let setupDB = SetUpDatabase()
    var questionList: [Question] = []
    
    func downloadItems() ->[Question] {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.questionList = self.parseJSON(jsonData: data!)
            }
        }
        
         task.resume()
//        print("quests \(questionList[0].title)")
        return questionList
    }
    
    
    func parseJSON(jsonData: Data!) -> [Question]{
        
//        var questionList: [Question] = []
        
//        if let jsonPath: String = Bundle.main.path(forResource: "QuestionData", ofType: "json"), let jsonData: Data = NSData(contentsOfFile: jsonPath) as Data? {
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
                        let answers = quest["answers"]  as? [String]
                        let  hint = quest["hint"] as? String
                        let  level = quest["level"] as? Int
                        let  topic = quest["topic"] as? String
                        let  unit = quest["unit"] as? Int
                        let  tags = quest["tags"] as? [String]
                        let type = quest["type"] as? String
 //                       let solutionImage = quest["solImage"] as? String
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
                       print ("sol ans hint  \(solutionStr)  \(answers) \(hint)  ")
                       print ("level unit topic   \(level)  \(unit) \(topic)  ")
                        print (" tags qtype  \(tags)  \(type)  ")
                        
                        questionList.append(Question(id: 0, title: title!, imageStr:imageStr!, qText: qtext!, correctAns: correct!, answers: answers as! [String], solution: solutionStr, hint: hint!, level: level!, unit: unit!, topic: topic!, tags: tags!, qType:type!))
                    }
                }
            } catch {
                print("Error while deserialization of jsonData")
            }
//        }
//        else {
//            print("error getting json")
//        }
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: self.questionList as NSArray)
            
        })
        return questionList
    }

}

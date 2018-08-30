//
//  Question.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 29/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import UIKit

class Question {
    
    var id:Int = 1001
    var title: String = ""
    //store image as encoded string - base64
    var imageStr: String = ""
    var qText: String = ""
    var correctAns: String!
    var answers: [String] = []
    var solution: String = ""
    var hint: String = ""
    var level: Int = 1
    var unit: Int = 1
    var topic: String = ""
    var tags:[String] = []
    var qType : String = ""
    
    init()  {}      //a blank initialiser that will use the above values and means I don't have to set them when I first create a question
    
    //initialise variables and set as attributes
    init(id:Int, title:String, imageStr:String, qText:String, correctAns: String, answers:[String], solution:String, hint:String, level:Int, unit:Int, topic:String, tags:[String], qType: String ){
        
        self.id = id
        self.title  = title
        self.imageStr = imageStr
        self.qText = qText
        self.correctAns = correctAns
        self.answers = answers
        self.solution = solution
        self.hint = hint
        self.level = level
        self.unit = unit
        self.topic = topic
        self.tags = tags
        self.qType = qType
        
    }
    
    static func decodeImage(imageString: String) -> UIImage{
        let decodedData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
        let decodedimage:UIImage = UIImage(data: decodedData!)!
        return decodedimage
    }
    static func encodeImage(image: UIImage) -> String {
        let imageData2 = UIImagePNGRepresentation(image)
        let imageStrB64 = imageData2?.base64EncodedString(options: .lineLength64Characters)
        return imageStrB64!
    }
}

//
//  Results.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 02/08/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation

class Results {
    
    var id: Int = 0
    var testTitle: String = ""
    var questionTitle: String = ""
    var questionTopic: String = ""
    var questionUnit: Int = 0
    var score: Int = 0
    var attempts: Int = 0
//    var date: Date
    
    
    init() {}
    
    init(id: Int, testTitle: String, questionTitle: String, questionTopic: String, questionUnit: Int, score: Int, attempts: Int ){
        
        self.id = id
        self.testTitle = testTitle
        self.questionTitle = questionTitle
        self.questionTopic = questionTopic
        self.questionUnit = questionUnit
        self.score = score
        self.attempts = attempts
    }
    
}

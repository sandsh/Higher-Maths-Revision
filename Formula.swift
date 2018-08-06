//
//  Formula.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 19/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation

class Formula {
    
    var id: Int = 0
    var topic: String = ""
    var unit: Int = 1
    var title: String = ""
    var formulaImageStr: String = ""
    
    //blank initialised as above
    init()  {}
    
    //or intialised with the values passed in 
    init(id:Int, topic:String, unit:Int, title:String, formulaImageStr:String){
        
        self.id = id
        self.topic = topic
        self.unit = unit
        self.title = title
        self.formulaImageStr = formulaImageStr
    }
    
}


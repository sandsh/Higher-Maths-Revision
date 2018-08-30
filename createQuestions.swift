//
//  createQuestions.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 11/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import UIKit
import iosMath

class CreateQuestion {
    
    var questionEquation: String!
    var questionLabel: UILabel!
    var answerEquation: String!
   
    var myLabel: UILabel!
    let newQuestion = Question()
    
    func setFactoriseData() -> (Question, UILabel) {
         //created a tuple to send back label
         var templateQuestion = (questionData: Question(), questionLabel: UILabel())
       
        newQuestion.id = 101
        newQuestion.title = "Factorise"
        newQuestion.qText = "Factorise the equation "
        
        myLabel = createFactorsingQuestion()
//        let imageData2 = UIImagePNGRepresentation(newQuestImage)
//        let imageStrB64 = newQuestion.encodeImage(image: newQuestImage)
        
//        newQuestion.imageStr = imageStrB64
        newQuestion.imageStr = " "
//        newQuestion.correctAns = answerEquation
//        newQuestion.answers = []
        newQuestion.solution = "Watch negatives"
        newQuestion.hint = "Find factors of the number term first"
        newQuestion.level = 1
        newQuestion.unit = 1
        newQuestion.topic = "ALG"
        newQuestion.tags = ["Brackets", "quadratics"]
        newQuestion.qType = "TEM"
        templateQuestion.questionData = newQuestion
        templateQuestion.questionLabel = myLabel

    
        return templateQuestion         //leaving label in till I know it works
        
    }
    
    
    func getRandomNums(max: Int, negative: Bool) -> [Int] {
        //get a random number - add negatives if negative is true
        var randomNums: [Int] = []
        for _ in 0..<5 {
            
            var randNum: Int = 0

            //doesn't matter that numbers are the same - but they can't be zero
            randNum = Int(arc4random_uniform(UInt32(max)))
            //will get it again in loop to alternate between positive and negative numbers
            //make these numbers negative if required
            if negative {
                randNum = -1*randNum
            }
            //now get rid of zeros by getting another random number and making these positive
            while randNum == 0 {
                //also get a positive when this happens
                randNum = Int(arc4random_uniform(UInt32(max)))
            }
            randomNums.append(randNum)
        }
        return randomNums
        
    }
    
    
    //start with a basic factorising question
    func createFactorsingQuestion() -> UILabel {
        
        //(ax+b)(cx+d)
        let variableLetter = "x"
        var firstSign: String = "+ "
        var secondSign: String = "+ "
        var aVar: Int!
        var bVar: Int!
        var cVar: Int!
        var dVar: Int!
        
        var bigRandomNums: [Int] = getRandomNums(max: 9, negative: true)
        var smallRandomNums: [Int] = getRandomNums(max: 3, negative: false)

        
        aVar = smallRandomNums[0] //make the x-coefficients small
        bVar = bigRandomNums[1]
        cVar = smallRandomNums[2]
        dVar = bigRandomNums[3]
        print("rnd vars \(String(aVar)) \(String(bVar)) \(String(cVar)) \(String(dVar))  ")
       
        
        var sqrLocn: Int = 2 + 4        // one digit and x before the squared superscript is default
        
        //get the coefficient of the square term
        let xSqrCoeff = aVar*cVar
        if xSqrCoeff > 9 || xSqrCoeff < 0 {    //if the coefficient has 2 digits or one negative then the squared is the fourth index
            sqrLocn = 3 + 4         // add 4 in for the start of the equation:  y =
        } else {
            if xSqrCoeff < -9 {
                sqrLocn = 4 + 4        //3 terms infront of x squared - in 5th position + 4 at start
            }
//            else {
//                if xSqrCoeff < 0 {  //if the coefficient has 1 digit and one negative then the squared is the fourth index
//                    sqrLocn = 3 + 4
//                }
            
//            }
        }
        var stringSqrCoeff: String = " "
        if xSqrCoeff == 1 {
            stringSqrCoeff = " "
        } else if xSqrCoeff == -1 {
            stringSqrCoeff = "-"
        } else {
            stringSqrCoeff = String(xSqrCoeff)
        }
        
        // find the term in front of x
        var xCoeff =  aVar*dVar + bVar*cVar
        var strXCoeff: String = ""
        if xCoeff == 0 {                    //check the result for negatives
            strXCoeff = " "                 //no x in the equation so insert a space
            print ("zero found")
            firstSign = ""                  //no sign either
        //check if it's negative - place a minus in formula if it is
        } else if xCoeff == -1 {
            firstSign = "- "
            xCoeff = -1*xCoeff              // make it positive
            strXCoeff = "x "                // no number in front of x
        } else if xCoeff < 0 {
            firstSign = "- "                //change the sign to negative
            xCoeff = -1*xCoeff              //then make it positive
            strXCoeff = String(xCoeff) + "x "
        } else if xCoeff == 1 {
                strXCoeff = "x "
        } else {
            strXCoeff = String(xCoeff) + "x "
        }
        
        
        //get the end number term
        var numberTerm =  bVar*dVar
        if numberTerm < 0 {
            secondSign = "- "
            numberTerm = -1*numberTerm      //make it positive
        }
        
        let xSquared = "2 "
        let factoriseQuest = "y = " + stringSqrCoeff + "x" + xSquared + firstSign + strXCoeff + secondSign + String(numberTerm)
        
        let questionLabel = setMyEquationText(powLocn: sqrLocn, questionString: factoriseQuest)
        
        // now the question is set we can tidy up the answer which we started with
        var aVarStr: String = " "
        var cVarStr: String = " "
        if aVar == 1 {
            aVarStr = ""
        } else {
            aVarStr = String(aVar)
        }
        
        if cVar == 1 {
            cVarStr = ""
        } else {
            cVarStr = String(cVar)
        }

        if bVar < 0 {           //if the variable is negative we need rid of the plus
            firstSign = " - "    // make the sign negative
            bVar = -1*bVar      // and the number positve
        } else {
            firstSign = " + "       // just in case it was altered above
        }
        if dVar < 0 {           //if the variable is negative we need rid of the plus
            secondSign = " - "
            dVar = -1*dVar
        } else {
            secondSign = " + "
        }
        
        print(" vars after checks before ans \(String(aVar)) \(aVarStr) \(String(cVar)) \(cVarStr)  ")
        let factoriseAns = "(" + aVarStr + variableLetter + firstSign + String(bVar) + ")" + "(" + cVarStr + variableLetter + secondSign + String(dVar) + ")"
        
        let otherFormAnswer = "(" + cVarStr + variableLetter + secondSign + String(dVar) + ")" + "(" + aVarStr + variableLetter + firstSign + String(bVar) + ")"
        
        newQuestion.correctAns = factoriseAns
        newQuestion.answers.append(otherFormAnswer)
        return questionLabel
        
    }
    
    func setMyEquationText(powLocn:Int, questionString:String) -> UILabel {
        
        let mylabel = UILabel()
        let largeFont = UIFont(name: "Damascus", size:60)
        let superFont = UIFont(name: "Damascus", size:20)
        let displayString = NSMutableAttributedString(string: "\(questionString)", attributes: [.font: largeFont as Any])
        displayString.setAttributes([.font: superFont as Any, .baselineOffset:15], range: NSRange(location:powLocn,length:1))
        
        mylabel.attributedText = displayString
        //convert label to image - or return it
//        let image = UIImage.imageWithLabel(label: mylabel)
        return mylabel
        }
    
    
    func createCompleteSquare () -> (Question, MTMathUILabel) {
        
        // a(x + b)^2 - c
        
        var smallRnds = getRandomNums(max: 3, negative: true)
        let varA = smallRnds[0]
        var randomNums = getRandomNums(max: 7, negative: true)
        let varB = randomNums[1]
        let varC = randomNums[2]
        
        //set up answer before any variables change
        let answerStr = "a = \(varA) b= \(varB) c = \(varC)"
        var xCoeff = 2*varB*varA
        var numTerm = varC - varA*varB*varB 
        //check the value of the variables for negatives - change displayed sign
        var firstSign, secondSign : String
        if xCoeff < 0 {
            firstSign = "-"
            xCoeff = -1*xCoeff
        } else {
            firstSign = "+"
        }
        
        if numTerm < 0 {
            secondSign = "-"
            numTerm = -1*numTerm
        } else {
            secondSign = "+"
        }
        var varAStr: String = " "
        var varBStr: String = " "
        print (varA)
        //check for 1 as coefficients of x squared
        if varA == -1 {
            varAStr = "-"
        } else if varA == 1 {
            varAStr = ""
        } else {
            print ("not a 1")
            varAStr = String(varA)
        }
        let questLabel: MTMathUILabel = MTMathUILabel()
    
        questLabel.latex = "\(varAStr)x^2 \(firstSign) \(xCoeff)x \(secondSign) \(numTerm)"

        questLabel.fontSize = 28
        
        var mathTemplateQuestion = (questionData: Question(), questionLabel: MTMathUILabel())
        
        newQuestion.id = getRandomNums(max: 1000, negative: false)[0]
        newQuestion.title = "Complete the Square"
        newQuestion.qText = "Complete the square of"
        newQuestion.correctAns = answerStr
        newQuestion.answers = ["a = 2 b = 3 c= -1, a = 1 b = -2 c= 5,a = 2 b = -4 c= 7"]
        newQuestion.solution = "Half x coefficient "
        newQuestion.hint = "Take out any coefficient of x squared first"
        newQuestion.level = 1
        newQuestion.unit = 1
        newQuestion.topic = "ALG"
        newQuestion.tags = ["powers", "quadratics"]
        newQuestion.qType = "TEM"
        mathTemplateQuestion.questionData = newQuestion
        mathTemplateQuestion.questionLabel = questLabel
        
        return mathTemplateQuestion
    }
    
    func getVectorMagnitude () -> (Question, MTMathUILabel){
        // format of question -  v = ax + by + cz  find |v|
        
        //get random numbers
        let random = getRandomNums(max: 9, negative: true)
        let xCoef = random[0]
        var yCoef = random[1]
        var zCoef = random[2]
        
        //square the numbers
        let vectorSquares =  xCoef*xCoef + yCoef*yCoef + zCoef*zCoef
        //square root the answer
        let vecMagnitude = sqrt(Double(vectorSquares))
        
        let answerStr = String(format: "%.2f", vecMagnitude)
        //now set up the maths display
        let vectorLabel: MTMathUILabel = MTMathUILabel()
        var firstSign: String = ""
        var secondSign: String
        //sort out the signs on the question
        if yCoef < 0 {
            firstSign = " - "
            yCoef = -1*yCoef
        }else {firstSign = " + "  }
        
        if zCoef < 0 {
            secondSign = " - "
            zCoef = -1*zCoef
        }else {  secondSign = " + "  }
        //deal with values of 1 - don't want to display them
        var xCoefStr: String
        var yCoefStr: String
        var zCoefStr: String
        
        if   xCoef == 1    {
            xCoefStr = ""
        }else if xCoef == -1 {
            xCoefStr = " -"
        } else { xCoefStr = String(xCoef)}
        
        if   yCoef == 1    {
            yCoefStr = ""
        }else if yCoef == -1 {
            yCoefStr = " -"
        }else { yCoefStr = String(yCoef)}
        
        if   zCoef == 1    {
            zCoefStr = ""
        }else if zCoef == -1 {
            zCoefStr = " -"
        }else { zCoefStr = String(zCoef)}
        
        
        vectorLabel.latex = "v = \(xCoefStr)x \(firstSign) \(yCoefStr)y \(secondSign) \(zCoefStr)z "
        vectorLabel.fontSize = 28
        
        var mathTemplateQuestion = (questionData: Question(), questionLabel: MTMathUILabel())
        
        newQuestion.id = getRandomNums(max: 1000, negative: false)[0]
        newQuestion.title = "Magnitude"
        newQuestion.qText = "Find the magnitude of"
        newQuestion.correctAns = answerStr
        newQuestion.answers = ["12, 15, 8"]
        newQuestion.solution = "Sum of squares then square root"
        newQuestion.hint = "Look at the formula"
        newQuestion.level = 1
        newQuestion.unit = 1
        newQuestion.topic = "VEC"
        newQuestion.tags = ["length", "vectors"]
        newQuestion.qType = "TEM"
        mathTemplateQuestion.questionData = newQuestion
        mathTemplateQuestion.questionLabel = vectorLabel
        
        return mathTemplateQuestion
        
    }
    
}

    
    
    
    
    






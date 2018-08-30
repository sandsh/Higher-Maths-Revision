//
//  DailyViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 24/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreText
import Foundation
import QuartzCore
import iosMath

class DailyViewController: UIViewController, UITextViewDelegate, UIToolbarDelegate, UINavigationBarDelegate  {
    
    @IBOutlet weak var myLabel: UILabel!
   
    @IBOutlet weak var q1Text: UILabel!
    @IBOutlet weak var q1View: UIView!
    @IBOutlet weak var q1Answer: UITextField!
    
    @IBOutlet weak var q2Text: UILabel!
    @IBOutlet weak var q2View: UIView!
    @IBOutlet weak var q2Answer: UITextField!
    @IBOutlet weak var q2QuestionView: UIView!
    
    @IBOutlet weak var q3View: UIView!
    @IBOutlet weak var q3Text: UILabel!
    @IBOutlet weak var q3Answer: UITextField!
    
    let newQuestion = CreateQuestion()
    var questionList: [Question] = []
    var answers:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //
        view.addGestureRecognizer(tap)
        
        //add a button to navigation bar that allows adding images

    }
    //Called when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func newTestButton(_ sender: UIButton) {
        
        //clear contents of the views -  if there's anything in them
        if let subview = q1View.subviews.last {
            subview.removeFromSuperview()
        }
        if let subview = q2View.subviews.last {
            subview.removeFromSuperview()
        }
        if let subview = q3View.subviews.last {
            subview.removeFromSuperview()
        }
        myLabel.text = "Answer the following"
        //wipe the answer fields
        q1Answer.text = " "
        q2Answer.text = " "
        q3Answer.text = " "
        
        questionList.removeAll()
        answers.removeAll()
        getNewSetQuestions()
    
    }
    
    func getNewSetQuestions() {
        
        //get 10 generated questions - new numbers each time
        
        //Q1 - Factorise
        
        var question1Label: UILabel
        let container = UIView(frame: CGRect(x: 2, y: -10, width: 200, height: 100))

        question1Label = getQuestion1()
        question1Label.frame = container.frame
        container.addSubview(question1Label)
        q1View.addSubview(container)

        //Q2 - Complete Square
        
        var mathTemplateQuestion1 = (questionData: Question(), questionLabel: MTMathUILabel())
        
        let container2 = UIView(frame: CGRect(x: 2, y: -7, width: 250, height: 80))
        container2.clearsContextBeforeDrawing = true
        mathTemplateQuestion1 = newQuestion.createCompleteSquare()
        //add question to a list
        questionList.append(mathTemplateQuestion1.questionData)
        //add answer
        answers.append(mathTemplateQuestion1.questionData.correctAns)

        let question2Label = mathTemplateQuestion1.questionLabel
        question2Label.frame = container2.frame
        container2.addSubview(question2Label)
        q2View.addSubview(container2)
        
        q2Text.text = "Find the values of a,b,c when written as"
        let q2MathLabel: MTMathUILabel = MTMathUILabel()
        let containerQuest2 = UIView(frame: CGRect(x: 0, y: -8, width: 250, height: 50))
        q2MathLabel.latex = " a(x + b)^2 + c"
        q2MathLabel.frame = containerQuest2.frame
        containerQuest2.addSubview(q2MathLabel)
        q2QuestionView.addSubview(containerQuest2)
        
        //Q3 - Magnitude of Vector
        var mathTemplateVQuestion2 = (questionVData: Question(), questionVLabel: MTMathUILabel())
        
        let container3 = UIView(frame: CGRect(x: 2, y: -4, width: 250, height: 80))
        container3.clearsContextBeforeDrawing = true
        // get the vector question as a label
        mathTemplateVQuestion2 = newQuestion.getVectorMagnitude()
        questionList.append(mathTemplateVQuestion2.questionVData)
        //set answer
        answers.append(mathTemplateQuestion1.questionData.correctAns)
        print(" q3 ans\(mathTemplateVQuestion2.questionVData.correctAns)")
        let question3Label = mathTemplateVQuestion2.questionVLabel
        question3Label.frame = container3.frame
        container3.addSubview(question3Label)
        q3View.addSubview(container3)
        q3Text.text = "Find the magnitude of the vector  "
        
    }
    
    func getQuestion1() -> UILabel {
        
        var templateQuestion = (rndQuestion: Question(), questLabel: UILabel())
        templateQuestion = newQuestion.setFactoriseData()
        print(" q1 ans\(templateQuestion.rndQuestion.correctAns)")
        answers.append(templateQuestion.rndQuestion.correctAns)
        questionList.append(templateQuestion.rndQuestion)
        q1Text.text = templateQuestion.rndQuestion.qText
        var q1Label: UILabel
        q1Label = templateQuestion.questLabel
        q1Label.adjustsFontSizeToFitWidth = true
        q1Label.contentScaleFactor = 0.1
        q1Label.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        return q1Label
    }
    
 
    @IBAction func showAnswers(_ sender: UIButton) {
        
        //dont allow any editing in the answer
        q1Answer.isHidden = false
        q2Answer.isHidden = false
        q3Answer.isHidden = false

        print ("before first answer \(questionList[0].title)")
        q1Answer.text = answers[0]
        print ("before second answer \(questionList[1].title) ")
        q2Answer.text = answers[1]
        print ("before third answer \(questionList[2].title) ")
        q3Answer.text = answers[2]
    }
    
    
    //this works
    //        Q1Label.attributedText = question1Label.attributedText
    //        questionText.text = templateQuestion.rndQuestion.qText


}

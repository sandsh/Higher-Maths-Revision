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
    @IBOutlet weak var AnswerTextField: UITextField!
    
    @IBOutlet weak var q2Text: UILabel!
    @IBOutlet weak var q2View: UIView!
    @IBOutlet weak var q2AnswerText: UITextField!
    
    
    @IBOutlet weak var q3View: UIView!
    @IBOutlet weak var q3Text: UILabel!
    @IBOutlet weak var q3Answer: UITextField!
    
    let newQuestion = CreateQuestion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a container to hold the math equation - position 5 from right in the view
        
//
//        let container1 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
//        let label: MTMathUILabel = MTMathUILabel()
//        label.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"
//
//        label.frame = container1.frame
//        container1.addSubview(label)
//        q1View.addSubview(container1)
        
        
        
        
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
    
//    //MARK: ADDING Image from phone
//    @objc func addNewQuestions(){
//
//    }
    
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
        getNewSetQuestions()
 //       DisplayQuestions()
    
    }
    
//    func testMathQuestion () -> MTMathUILabel{
//
//        print ("getting maths")
//        let label: MTMathUILabel = MTMathUILabel()
//        label.latex = "x = \\sqrt{b^2-4ac}"
//
//        return label
//    }
    
    func getNewSetQuestions() {
        
        //get 10 generated questions - new numbers each time
        
        //Q1 - Factorise
        
        var question1Label: UILabel
        let container = UIView(frame: CGRect(x: 5, y: 0, width: 200, height: 100))

        question1Label = getQuestion1()         // this was created by swift and not with iosMath
//        Q1Label.attributedText = question1Label.attributedText
//        questionText.text = templateQuestion.rndQuestion.qText
        question1Label.frame = container.frame
        container.addSubview(question1Label)
        q1View.addSubview(container)

        //Q2 - Complete Square
        
        var question2Label: MTMathUILabel
        let container2 = UIView(frame: CGRect(x: 2, y: -5, width: 250, height: 80))
        container2.clearsContextBeforeDrawing = true
        question2Label = newQuestion.createCompleteSquare()
        //
        question2Label.frame = container2.frame
        container2.addSubview(question2Label)
        q2View.addSubview(container2)
        q2Text.text = "State values of a,b and c when the quadratic "
        
        //Q3 - Magnitude of Vector
        
        var question3Label: MTMathUILabel
        let container3 = UIView(frame: CGRect(x: 2, y: -5, width: 250, height: 80))
        container3.clearsContextBeforeDrawing = true
        // get the vector question as a label
        question3Label = newQuestion.getVectorMagnitude()
        //
        question3Label.frame = container3.frame
        container3.addSubview(question3Label)
        q3View.addSubview(container3)
        q3Text.text = "Find the magnitude of the vector  "
        

    }
    
    func getQuestion1() -> UILabel {
        
        var templateQuestion = (rndQuestion: Question(), questLabel: UILabel())
        templateQuestion = newQuestion.setFactoriseData()
        q1Text.text = templateQuestion.rndQuestion.qText
        var q1Label: UILabel
        q1Label = templateQuestion.questLabel
        q1Label.adjustsFontSizeToFitWidth = true
        q1Label.contentScaleFactor = 0.1
        q1Label.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        return q1Label
    }
    
    
    
    //this doesn't work
    //
    //        q1View.addSubview(question1Label)
    //        q1View.bringSubview(toFront: question1Label)
    
    //this works
    //        Q1Label.attributedText = question1Label.attributedText
    //        questionText.text = templateQuestion.rndQuestion.qText


}

//
//  AnswerViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 17/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    
    @IBOutlet weak var SolutionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var solutionImage: UIImageView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var question = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" answer is  \(question.correctAns)")
        answerLabel.text = question.correctAns
        //display the solution - may need to split this over lines - display it better
        SolutionLabel.text = question.solution
        switch question.unit {
        case 1:
            unitLabel.text = "Unit 1 - Expressions and Formulae"
        case 2:
            unitLabel.text = "Unit 2 - Relationships and Calculus"
        case 3:
            unitLabel.text = "Unit 3 - Applications"
        default:
            break
        }
        switch question.topic {
        case "alg" :
            topicLabel.text = "Topic - algebra"
        case "fun":
            topicLabel.text = "Topic - functions"
        case "tri":
            topicLabel.text = "Topic - trig expressions"
        case "vec":
            topicLabel.text = "Topic - vectors"
        case "diff":
            topicLabel.text = "Topic - differentiation"
        case "eqn":
            topicLabel.text = "Topic - equations"
        case "trig eqn":
            topicLabel.text = "Topic - trig equations"
        case "int":
            topicLabel.text = "Topic - integration"
        case "strl":
            topicLabel.text = "Topic - straight Lines"
        case "cir":
            topicLabel.text = "Topic - circles"
        case "seq":
            topicLabel.text = "Topic - sequences"
        case "calc":
            topicLabel.text = "Topic - calculus"
        default :
            break
        }
        switch question.level {
        case 1:
            levelLabel.text = "Basic level of difficulty - grade C"
        case 2:
            levelLabel.text = "Medium difficulty - grade B/C"
        case 3:
            levelLabel.text = "High level of difficulty - grade A/B "
        case 4:
            levelLabel.text = "Challenging Question - grade A "
        default:
            break
        }

        
        
    }



}

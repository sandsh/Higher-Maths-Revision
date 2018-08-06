//
//  EnterQViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 04/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class EnterQViewController: UIViewController {

    @IBOutlet weak var question2Image: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var question2Answer: UITextField!
    @IBOutlet weak var questionText: UILabel!
    
    var titleName: String = ""
    var topicsList = [Question]()
    var questionImages: [UIImage] = []
    let pageNum = 2
    var questionNum: Int = 0
    var currentQuestions: [Int] = []
    var questionRndOrder: [Int] = []        //need to pass this amongst questions
    var nextQuestion: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        questionImages.append(#imageLiteral(resourceName: "StrLine1Q"))
//        questionImages.append(#imageLiteral(resourceName: "Factorise1"))
        
        // display the image from array at load time
        //let image:UIImage = questionImages[pageNum-1]
        //question2Image.image = image
        question2Image.image = getImage(imageString: topicsList[questionNum].imageStr)
        questionText.text = topicsList[questionNum].qText
        self.title = titleName
//        self.navigationItem.title = "Question" + " " + String(questionNum)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard and end first reponder
        textField.resignFirstResponder()
        //return true if you want to process the return key user enters
        return true
    }
    
    //change image string into an UIImage that can be displayed
    func getImage(imageString: String) -> UIImage{
        let decodedData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
        let decodedimage:UIImage = UIImage(data: decodedData!)!
        return decodedimage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        
        // question2Answer.text.removeAll(" ")
        //CFStringTrimWhitespace(question2Answer.text as! CFMutableString)
        
        let currentAnswer = question2Answer.text
        let temp = currentAnswer?.replacingOccurrences(of: " ", with: "")
        
        switch temp {
            
        case "(x+8)(x-1)" :
            resultLabel.text  = "Well Done"
            resultLabel.backgroundColor = UIColor.green
        case "(x-1)(x+8)" :
            resultLabel.text  = "Well Done"
            resultLabel.backgroundColor = UIColor.green
        default:
            resultLabel.text = "No, Try again"
        }
        
    }
    
    

}

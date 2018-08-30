//
//  QuestionViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 02/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

typealias resultsHandler = (Results) -> ([Results])

class QuestionViewController: UIViewController, UITextFieldDelegate, UIPageViewControllerDelegate, UINavigationControllerDelegate, UIToolbarDelegate, UINavigationBarDelegate{
    
    //Parameters passed in
    var titleName = String()
    var testType = String()
    var questionList = [Question]()
    var pageIndex: Int = 0                   // starts at 0 ?
    var numberOfQuestions: Int!
    var questionResults: [Results] = []
    
    //MARK: Question Outlets
    @IBOutlet weak var ans1Button: UIButton!
    @IBOutlet weak var ans2Button: UIButton!
    @IBOutlet weak var ans3Button: UIButton!
    @IBOutlet weak var ans4Button: UIButton!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var enteredText: UITextField!
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var checkButtn: UIButton!
    @IBOutlet weak var finishLabel: UIButton!
    @IBOutlet var answerButtn: UIBarButtonItem!
    @IBOutlet var hintButtn: UIBarButtonItem!
    
    //class variables
    var chosenAnswer: Int = 0
    var correctAns: Int!
    let myColorBlue = UIColor(displayP3Red: 0, green: 0, blue: 0.5, alpha: 0.7)
    let myColorCyan = UIColor(displayP3Red: 0, green: 0.3, blue: 0.2, alpha: 0.2)
    var resultsDBUpdated: Bool = false
    var grade: Int = 100
    var numberAttempts: Int = 0
    var question = Question()
    var newResult = Results()
    
    
   var resultsH: resultsHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //if you want the tap not to interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        displayQuestionData()
        
        //need to set up results - must record if they have a try or not
        //writing results to the master page so it is retained between pages
        newResult.questionTitle = questionList[pageIndex].title
        newResult.questionTopic = questionList[pageIndex].topic
        newResult.questionUnit = questionList[pageIndex].unit
        //this is where is talks back to master for the first time
        //those not set should be 0
        questionResults = resultsH!(newResult)

//        }

        
        enteredText.delegate = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        questionResults[pageIndex].questionTitle = questionList[pageIndex].title
//        questionResults[pageIndex].questionTopic = questionList[pageIndex].topic
//        questionResults[pageIndex].questionUnit = questionList[pageIndex].unit
//        questionResults[pageIndex].testTitle = titleName
//        print("page appeared \(pageIndex)")
//    }

    func displayQuestionData() {
        
        //the number of the question
        questionNum.text = "Question" + " " + String(pageIndex+1) + " of " + String(numberOfQuestions)
        //set the question textpo
        questionText.text = String(questionList[pageIndex].qText)
        
        if numberOfQuestions == pageIndex+1 {       //if this is the last question
            swipeLabel.text = ""  //clear the swipe message
            finishLabel.isHidden = false            //Show the finish label to get results
            
        }else {
            finishLabel.isHidden = true             //Hide the finish label
        }
        //if this is test question - don't allow access to answer or hint - button can't be selected or seen
        if testType == "Test" {
            print("this is a test - hide answer")
            answerButtn.isEnabled = false
            answerButtn.tintColor = UIColor.clear
            hintButtn.isEnabled = false
            hintButtn.tintColor = UIColor.clear
            checkButtn.setTitle("Submit", for: .normal)
            //hide the results - find out at the end
            resultLabel.isHidden = true
        } else {
            checkButtn.isHidden = false
        }
        
        
        if !questionList[pageIndex].imageStr.isEmpty {
            questionImage.image = Question.decodeImage(imageString: questionList[pageIndex].imageStr)
        }
        if questionList[pageIndex].qType == "MC" {
            //find which answer is correct
            for num in 0..<questionList[pageIndex].answers.count {
                if questionList[pageIndex].answers[num] == questionList[pageIndex].correctAns{
                    correctAns = num + 1 //index of answer is one less than label number
                    print ("found correct answer \(num) \(questionList[pageIndex].correctAns)")
                }
            }
            ans1Button.setTitle(questionList[pageIndex].answers[0], for: .normal)
            ans1Button.layer.borderWidth = 1.0
            ans1Button.layer.borderColor = UIColor.blue.cgColor
            ans2Button.setTitle(questionList[pageIndex].answers[1], for: .normal)
            ans2Button.layer.borderWidth = 1.0
            ans2Button.layer.borderColor = UIColor.blue.cgColor
            ans3Button.setTitle(questionList[pageIndex].answers[2], for: .normal)
            ans3Button.layer.borderWidth = 1.0
            ans3Button.layer.borderColor = UIColor.blue.cgColor
            ans4Button.setTitle(questionList[pageIndex].answers[3], for: .normal)
            ans4Button.layer.borderWidth = 1.0
            ans4Button.layer.borderColor = UIColor.blue.cgColor
            
            enteredText.isHidden = true
        } // ** else hide labels and display a text box (we don't need 2 types atm)
        else {
            ans1Button.isHidden = true
            ans2Button.isHidden = true
            ans3Button.isHidden = true
            ans4Button.isHidden = true
            enteredText.isHidden = false
        }
    }
    
    //Called when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK : Answer Buttons
    //For multiple choice
    @IBAction func answer1(_ sender: UIButton) {
        ans1Button.backgroundColor = myColorCyan

//        ans1Button.titleColor(for: .selected)
        //if another button was chosen then reset its color
        if chosenAnswer != 0 {
            resetButtonColor()
        }
        //now this is the currently chosen answer
        chosenAnswer = 1
        
    }
    @IBAction func answer2B(_ sender: UIButton) {
        ans2Button.backgroundColor = myColorCyan
        if chosenAnswer != 0 {
            resetButtonColor()
        }
        chosenAnswer = 2
    }
    
    @IBAction func answer3B(_ sender: UIButton) {
        ans3Button.backgroundColor = myColorCyan
        if chosenAnswer != 0 {
            resetButtonColor()
        }
        chosenAnswer = 3
    }
    
    @IBAction func answer4B(_ sender: UIButton) {
        ans4Button.backgroundColor = myColorCyan
        if chosenAnswer != 0 {
            resetButtonColor()
        }
        chosenAnswer = 4
    }
    
    //reset the colour of the buttons once it has been selected
    func resetButtonColor() {
        resultLabel.backgroundColor = UIColor.white
        resultLabel.text  = ""
        //show which answer has been selected - change it to cyan
        switch chosenAnswer {
        case 1:
            ans1Button.backgroundColor = UIColor.cyan
        case 2:
            ans2Button.backgroundColor = UIColor.cyan
        case 3:
            ans3Button.backgroundColor = UIColor.cyan
        case 4:
            ans4Button.backgroundColor = UIColor.cyan
        default:
            resultLabel.backgroundColor = UIColor.white
        }
    }
    
    //MARK: Actions
    @IBAction func checkButton(_ sender: Any) {
        //if they choose the one holding the correct answer
        if questionList[pageIndex].qType == "MC"{
            if chosenAnswer == correctAns {
                resultLabel.text = "WELL DONE"
                //make the text green to show it's correct
                resultLabel.textColor = UIColor.green
                gradeLabel.text = updateGrades(result: true)
    
            } else {
                resultLabel.text = "No, Please try again"
                resultLabel.textColor = myColorBlue
                gradeLabel.text = updateGrades(result: false)
            }
        } else {
            checkAnswerText()
        }
        //don't show the answer
        if testType == "Test" {
            resultLabel.isHidden = false
            resultLabel.textColor = UIColor.blue
            resultLabel.text = "Answer submitted"
            checkButtn.isHidden = true
            gradeLabel.isHidden = true
        }
    }
    
    func checkAnswerText() {

        let currentAnswer = enteredText.text
        let trimAnswer = currentAnswer?.replacingOccurrences(of: " ", with: "")
        
        let correctAnswer = questionList[pageIndex].correctAns
        let trimCorrect = correctAnswer?.replacingOccurrences(of: " ", with: "")
        
        if trimCorrect == trimAnswer {
            resultLabel.text  = "Well Done"
            resultLabel.textColor = UIColor.green
            gradeLabel.text = updateGrades(result: true)
        } else {    //check other answers for other forms of the correct one
            let otherAnswer = questionList[pageIndex].answers
            for ans in otherAnswer {
                let trimOther = ans.replacingOccurrences(of: " ", with: "")
                if trimOther == trimAnswer {
                    resultLabel.text  = "Well Done"
                    resultLabel.textColor = UIColor.green

                    gradeLabel.text = updateGrades(result: true)
                    break
                }
            }
            resultLabel.text = "No, please try again"
            resultLabel.textColor = UIColor.blue

            gradeLabel.text = updateGrades(result: false)
        }
    }
    
    //Set a score for the question depending on attempts
    func updateGrades(result: Bool)-> String {
        
        //grade starts as 100
        var resultText: String
        // True - this is a correct answer
        if result {
            if numberAttempts == 0 {
                resultText = "First Attempt - Grade is 100%"
                 checkButtn.isHidden = true
                grade = 100
                numberAttempts = 1
                //updateResultsDB here ? - only updated when correct
            } else {
                //if already previous wrong attempt
                switch numberAttempts {
                case 1:
                    grade = 67
                case 2:
                    grade = 45
                case 3:
                    grade = 30
                default:
                    grade = 0
                }
                numberAttempts = numberAttempts + 1
                //increment with this attempt
                resultText = "Number of attempts: \(numberAttempts) - Grade is \(grade)%"
            }
        }else {
            //This is a wrong answer
            numberAttempts = numberAttempts + 1
            grade = 0           //get zero once you get a wrong answer - update if correct
            if numberAttempts < 4 {     //only allowed 3 attempts before getting zero
                resultText = "Number of attempts: \(numberAttempts) "
            } else {
                resultText = "Too many attempts: \(numberAttempts) - Grade is \(grade)%"
                //don't allow any more checking
                checkButtn.isHidden = true
               
                //updateResultsDB here  ? - but what if they give up after only 1 attempt
            }
        }
        
        //now update results with values - index one less than page and question number
        newResult.testTitle = titleName

        newResult.attempts = numberAttempts

        newResult.score = grade
        
        //send the newresult to the master to update the array of results for second time
        //master sends the full array updated back
        questionResults = resultsH!(newResult)
        
        
        return resultText
        
    }
    // a one line hint is given for each question
    @IBAction func hintButton(_ sender: UIBarButtonItem) {
        resultLabel.textColor = UIColor.blue
        resultLabel.text = questionList[pageIndex].hint
    }
    
    //MARK : Navigation
    //set up data to pass to new destinations
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "showAnswerSegue" {
            let destination = (segue.destination as? AnswerViewController)!
            destination.question = questionList[pageIndex]
         } else if segue.identifier == "showFormulaSegue" {
            let destination = (segue.destination as? FormulaeTableViewController)!
            //information for formulae to display depending on where selected
            destination.viewType  = "Show"
            destination.titleName = titleName
            destination.unit  = questionList[pageIndex].unit
            destination.topic = questionList[pageIndex].topic
         } else if segue.identifier == "showQResultsSegue" {
            let destination = (segue.destination as? QuestionResultsViewController)!
            destination.questsResults = questionResults
        }
    }
    
    //ACTIONS
    //Move to new screens upon these actions being selected
    
    @IBAction func showAnswerButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "showAnswerSegue", sender: self)
    }
    
    @IBAction func finishButton(_ sender: UIButton) {

        performSegue(withIdentifier: "showQResultsSegue", sender: self)
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        
        //set up to get a screen shot of the current view
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        //store the current view in an image
        let fullScreenImage = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        //use the activity view controller to access the ios options - all options allowed atm
        let activityController = UIActivityViewController(activityItems: [fullScreenImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        //pop up message will appear to confirm share
    }

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        //set up to get a screen shot of the current view
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        //store the current view in an image
        let screenImage = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        //create a unique name to save it as - title and id
        let savedAs = questionList[pageIndex].title + "-" + String(questionList[pageIndex].id)
        let dataFiles = DataFiles()
        dataFiles.saveImagetoFile(image: screenImage, saveName: savedAs)
        resultLabel.text  = "An image of this question was saved to files"
        
    }
    
    
    @IBAction func formulaeButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "showFormulaSegue", sender: self)
    }
       
}//End Class


 extension QuestionViewController {
    
    //this makes the return back to the question screen once done is selected on answer screen
    @IBAction func cancelToQuestionViewController(_ segue: UIStoryboardSegue) {
        //no code required as nothing is passed back
    }

}//end extension



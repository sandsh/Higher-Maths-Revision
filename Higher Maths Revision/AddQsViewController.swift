//
//  AddQsViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 29/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreText
import Foundation
import QuartzCore
import iosMath


class AddQsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var numberofquestions = 0
    var questionList = [Question]()
    
    //MARK: properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var qTextField: UITextField!
    @IBOutlet weak var questImage: UIImageView!
    @IBOutlet weak var correctAnswer: UITextField!
    @IBOutlet weak var wrongAnswers: UITextField!
    @IBOutlet weak var hintTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var tagsTF: UITextField!
    @IBOutlet weak var qTypeTF: UITextField!
    @IBOutlet weak var solutionTextView: UITextView!
    
    
    let setupDB = SetUpDatabase()
    var inQuestion = Question()
    
    //open the conncetion for this database and set the URL
    //could try - var FileURL: URL! - after I get next bit working
    let questionFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("questionsTable4.sqlite")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not to interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //add a button to navigation bar that allows adding images
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))

        
        setupDB.openOrCreateDB(fileURL: questionFileURL)
        print("Add q's - database opened or created")
    }
    
    //Called when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view to resign the first responder status.
        view.endEditing(true)
    }
 
    //MARK: ADDING Image from phone
    @objc func addNewImage(){
        let picker = UIImagePickerController()
        //allows user to edit the image they want to choose
        picker.allowsEditing = true
        //conform to protocols
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        //show the image selections

        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //check if the image can be selected - return if not  - should send an error message
        guard let imagePicked = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print ("error picking the imge" )
            return }

        //get and store the unique identifier as string
        let imageName = UUID().uuidString

        //get path to where we store the image
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        //convert the image to jpeg - quality 80

        if let jpegData = UIImageJPEGRepresentation(imagePicked, 80) {
            //store the image
            print("jpeg good - now to write")
            try? jpegData.write(to: imagePath)

            //display the image
            questImage.image = imagePicked
        }
        //dismiss the picker once the picture is chosen
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK: Actions
    
    //Save Data Button
    @IBAction func addQuestionDAta(_ sender: UIButton) {
    
  //      let manDB = ManageDBData()
        let newQuestion = Question()
        
        let inTitle = titleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if inTitle.isEmpty {
            print("Title needs to be set")
            titleTextField.backgroundColor = UIColor.red
            return
        } else {
            print ("name is \(inTitle)")
            //is this an error as title is string and name is text??
        }
        
        let inQText = qTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if inQText.isEmpty {
            print("the question text must eneterd")
            return
        } else {
            print ("text is \(inQText)")
        }
        
        //need to check all values - in a validation function - use guard?
        let Answers = wrongAnswers.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let inCorrectAnswer = correctAnswer.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let inHint = hintTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let inCode = codeTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let inTags = tagsTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let inqType = qTypeTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let inSolution = solutionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //randomise or not? - randomise when getting data only?
//        let inRndAnswers = manDB.RandomiseAnswers(answers: Answers)
        //convert the string to an array - substring cannot be directly assigned ?!
        var inAnswers: [String] = []
        let tempArry = Answers.split(separator: ",")
        var i: Int=0
        // loop round however many wrong answers there - maybe none
        for ans in tempArry {  //doesn't matter what's in there - so using a blank variable
            inAnswers.append(String(ans))      //won't allow appending of substring ?
            i += 1
        }//Do I want to have array of wrong answers in question - not all answers ?
        
        //Unpack the code and store on
        let tempCode = inCode.split(separator: " ")
        
        var inUnit: Int
        var inTopic: String
        var inLevel: Int
        if tempCode.isEmpty {
            codeTF.isHighlighted = true
            print ("no code entered")
            return
        } else {
            inUnit = Int(tempCode[0])!
            inTopic = String(tempCode[1])
            inLevel = Int(tempCode[2])!
        }
        
        //temp image for each question
        var imageStrB64: String!
        //check there is an image to asign 
        if let tempImage:UIImage = questImage.image {
            imageStrB64 = Question.encodeImage(image: tempImage)
//            if let imageData = UIImagePNGRepresentation(tempImage) {
//                 = imageData.base64EncodedString(options: .lineLength64Characters)
//            }
        } else {
            print("the question text must eneterd")
            return
        }
        
        inQuestion = Question(id: 0, title: inTitle, imageStr: imageStrB64, qText: inQText, correctAns:inCorrectAnswer, answers: inAnswers, solution: inSolution, hint: inHint, level: inLevel, unit: inUnit, topic: inTopic, tags: [inTags], qType: inqType)
        
        //MARK: adding data to database

        setupDB.addValuesToDB(newQ: inQuestion, fileURL:questionFileURL)

        
        // *** Close DB somewhere?? ***
    }
    
    func unpackString(inString: String) -> [String]{
    
        var outArray = [String]()
        let newArray = inString.split(separator: ",")
        var i: Int=0
        // loop round however many wrong answers there - maybe none
        for ans in newArray {  //doesn't matter what's in there - so using a blank variable
            outArray[i] = String(ans)      //won't allow appending of substring
            i += 1
        }//Do I want to have array of wrong answers in question - not all answers ?
        return outArray
    }
    
    
    @IBAction func newRandomQuestion(_ sender: UIButton) {
        

        var templateQuestion = (rndQuestion: Question(), questLabel: UILabel())
        let newRandQuestion = CreateQuestion()
        
        //call to get a random factorsing queston 
        templateQuestion = newRandQuestion.setFactoriseData()
        
        questImage.image = renderImagefromText(label: templateQuestion.questLabel)
        
//        questionLabel.attributedText = templateQuestion.questLabel.attributedText
        
        titleTextField.text = templateQuestion.rndQuestion.title
        qTextField.text = templateQuestion.rndQuestion.qText
        wrongAnswers.text = templateQuestion.rndQuestion.answers[0]
        correctAnswer.text = templateQuestion.rndQuestion.correctAns
        
        print("new question requested")
        
    }
    
    func renderImagefromText (label: UILabel) -> UIImage {
    
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 800, height: 400))
        
        let img = renderer.image { ctx in

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
//            let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            let imgString = label.attributedText
            //
            imgString?.draw(in:CGRect(x: 0, y: 50, width: 750 , height: 500))
                //options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
        }
        
        //
        return img
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

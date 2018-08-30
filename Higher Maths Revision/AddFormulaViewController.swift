//
//  AddFormulaViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 23/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class AddFormulaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var formulaTopic: UITextField!
    @IBOutlet weak var formulaTitle: UITextField!
    @IBOutlet weak var formulaImage: UIImageView!
    @IBOutlet weak var formulaUnit: UITextField!
    
    var newFormula = FormulaDBTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
        
        view.addGestureRecognizer(tap)
        
        //add a button to navigation bar that allows adding images
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
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
        print("showing  imagaes ?")
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
            try? jpegData.write(to: imagePath)
            
            //display the image
            formulaImage.image = imagePicked
        }
        //dismiss the picker once the picture is chosen
        dismiss(animated: true)
    }
 
    //gets the path of the documents directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func addFormula(_ sender: UIButton) {
        
        //want an instance of a question - should this be a struct? as i only want to use the method
        let question = Question()
        
        let newTopic = formulaTopic.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let newTitle = formulaTitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let inUnit = formulaUnit.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var imageStrB64: String!
        //check there is an image to asign
        if let newFormulaImg:UIImage = formulaImage.image {
            imageStrB64 = Question.encodeImage(image: newFormulaImg)
        }
        
        let newUnit = Int(inUnit)
        print("new values  \(newTopic) \(newTitle) ")
        let formulaData = Formula(id: 101, topic: newTopic, unit: newUnit!, title: newTitle, formulaImageStr: imageStrB64)

        newFormula.addFormula(newFormula: formulaData)
        
    }
    
   

}

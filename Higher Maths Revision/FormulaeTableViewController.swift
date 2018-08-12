//
//  FormulaeTableViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 19/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class FormulaeTableViewController: UITableViewController {
    
    //passed in parameters
    var viewType: String = ""
    var unit: Int = 0
    var topic: String = ""
    var titleName: String = ""
    
    @IBOutlet var formulaTableView: UITableView!
    var deleteIndexPath : IndexPath? = nil
    
//    var sectionHeaders = ["Algebra","Trig","Circles","Straight Lines","Vectors","Calculus"]
    var currentSection: Int!
    
    //used to hold the list from the table
    var formulaList = [Formula]()
    //stores the formulae in an array of tuples - key of topic - arranged for sections of table
    var currentFormulae: [(topic:String, formula:[Formula])] = []
    
    let accessFormula = FormulaDBTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessFormula.openFormulaTable()
        
    }
    
    //this happens everytime the view is refreshed not just first time as viewdidload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentFormulae = getTopics()
        //if we are in questions - don't allow the formulae to be altered - no add button
        if viewType == "Show" {
            // All formulae to be shown for all units and exam questions - could be altered for exam questions in the future - allowing only those in the exam
            if titleName != "All Units" && titleName != "Exam Questions" {
                //only show those for the unit we are currently testing or practicing
                let unitFormulae = getUnitFormulae(currentForm: currentFormulae)
                currentFormulae = unitFormulae
            }
        } else {
            //allow formulae to be updated
            // add a button to navigation bar that allows adding images but not in questions
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFormula))
        }
        formulaTableView.reloadData()
    }
    
    //When user hits return after typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard and end first reponder
        textField.resignFirstResponder()
        //return true if you want to process the return key user enters
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // get the number of topics on the table
        return currentFormulae.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this will be different depending on the number of forumal in each section
        // the section is the row on the array, so count how many we have for that topic
        let num = currentFormulae[section].formula.count
        print ("number of formula  \(num)")
        return num
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let formulaCell = cell as! FormulaTableViewCell
        print("getting the title \(currentFormulae[indexPath.section].formula[indexPath.row].title)")
        formulaCell.FormulaTitle.text = currentFormulae[indexPath.section].formula[indexPath.row].title
        
        //setting the image of the formula by decoding the string
        let imgStr  = currentFormulae[indexPath.section].formula[indexPath.row].formulaImageStr
        
        formulaCell.FormulaImage.image = Question.decodeImage(imageString: imgStr)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return currentFormulae[section].topic
        
    }
    
    // Allow swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteIndexPath =  indexPath
            let formulaToDelete = currentFormulae[indexPath.section].formula[indexPath.row]
            //check they want to delete this with by displaying the title
            confirmDelete(questionTitle: (formulaToDelete.title))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //delete question from list
    func confirmDelete(questionTitle: String) {
        let alert = UIAlertController(title: "Delete Question", message: "Are you sure you want to permanently delete \(questionTitle)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteQuestion)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteQuestion)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        
        alert.popoverPresentationController?.sourceView = self.view
        
        // Support display in iPad  ???
        //        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Do the actual deleting - from table and from database
    func handleDeleteQuestion(alertAction: UIAlertAction!) -> Void {
        
        //if got index of the one to delete
        if let indexPath = deleteIndexPath {
            formulaTableView.beginUpdates()
            //get the ID of the current question so it can be passed on to be deleted from Database
            let formulaId = currentFormulae[indexPath.section].formula[indexPath.row].id
            currentFormulae[indexPath.section].formula.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            formulaTableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteIndexPath = nil
//            OutMessageLabel.text = "Question \(questId) was deleted"
            formulaTableView.endUpdates()
            //now delete the question from database too
            accessFormula.deleteQuestionOnDB(formulaID: formulaId)
        }
        
    }

    //What to do when Cancel is chosen - nothing reset delete
    func cancelDeleteQuestion(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    
    
    //MARK: Access database
    //Gather the formulae together grouping each under a topic
    func getTopics () -> [(topic:String, formula:[Formula])] {
        
        var newFormulae: [(topic:String, formula:[Formula])] = []
        //get all the formula from the table
        formulaList = accessFormula.getFormulaFromTable()
        //store the currentTopic
        var currentTopic:String
        
        var uniqueTopics: [String] = []
        
        //set up the array of tuples from the list returned from dbtable
        //the first element is the topic, all the formula for that topic follows in the array
        for formul in formulaList {
            //get each Topic in the list so they can be grouped together
            currentTopic = formul.topic
            // if it doesn't exist in the unique list
            if !uniqueTopics.contains(currentTopic) {
                //store this new topic
                uniqueTopics.append(currentTopic)
                print("new topic  \(formul.topic)")
                // adding a new topic and forumla to the list - could do newFormulae.append(formul)  ?? NO - only one formula not all!
                newFormulae.append((formul.topic, [formul]))
            } else {
                // find the index on the array for a tuple with this topic - functional - using a closure
                if let ind = newFormulae.index(where: {($0.topic == formul.topic)}) {
                    //get the row, and append the data to the array on that row
                    newFormulae[ind].formula.append(formul)
                }
            }
        }
        return newFormulae
    }
    
    func getUnitFormulae (currentForm: [(topic:String, formula:[Formula])]) -> [(topic:String, formula:[Formula])] {
        
        var unitFormulae: [(topic:String, formula:[Formula])] = []
        for current in currentForm{
            print("current topic  \(current.topic)")
            for formula in current.formula {
                //if we are working on a specific unit - then only show those formulae
                print("current formula \(formula.title)")
                if formula.unit == unit {
                    print("in unit \(unit)")
                    //so we don't get duplicates we need to see if it already in the list
                    if let ind = unitFormulae.index(where: {($0.topic == formula.topic)}) {
                        //get the row, and append the data to the array on that row
                        unitFormulae[ind].formula.append(formula)
                        print("appending one in \(formula.title)")
                    } else {
                        //it isn't on the list so add only that topic and that formula
                        unitFormulae.append((formula.topic, [formula]))
                        print("a new topic  \(formula.title)")
                    }
                }
                //could make a tab list - all - unit or topic ??
            }
        }
        return unitFormulae
    }
    
    
     @objc func addNewFormula(){
        performSegue(withIdentifier: "addFormulaSegue", sender: self)
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = (segue.destination as? AddFormulaViewController)!
        //information for formulae to display depending on where selected
        
    }
    

}
extension FormulaeTableViewController {
    
    //this makes the return back to the question screen once done is selected on answer screen
    @IBAction func backToFormulaTableViewController(_ segue: UIStoryboardSegue) {
        //no code required as nothing is passed back
//        formulaTableView.reloadData()
        
    }
    
}//end extension

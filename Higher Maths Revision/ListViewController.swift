//
//  ListViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 02/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit
import SQLite3

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: Properties
    var questionList = [Question]()
    let manageDB = ManageDBData()
    var delQuestionIndexPath : IndexPath? = nil
    
    
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var OutMessageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func didChangeValue<Value>(for keyPath: KeyPath<ListViewController, Value>) {
        questionsTableView.reloadData()
    }
    
    //MARK: Table handlers - listing questions for deleting
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let question: Question
        question = questionList[indexPath.row]
        cell.textLabel?.text = String(question.id) + "-" + question.title
        return cell
    }
    
    // Allow swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            delQuestionIndexPath =  indexPath
            let questDel = questionList[indexPath.row]
//            let rowToDel = tableView.deleteRows(at: [indexPath], with: .fade)
            confirmDelete(questionTitle: questDel.title)
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
        if let indexPath = delQuestionIndexPath {
            questionsTableView.beginUpdates()
            //get the ID of the current question so it can be passed on to be deleted from Database
            let questId = questionList[indexPath.row].id
            questionList.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            questionsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            delQuestionIndexPath = nil
            OutMessageLabel.text = "Question \(questId) was deleted"
            questionsTableView.endUpdates()
            //now delete the question from database too
            manageDB.deleteQuestionOnDB(questionID: questId)
        }
        else {
            print ("deleting all maybe?")
            if manageDB.deleteAll() {
                OutMessageLabel.text = "All questions deleted"
                //should not use reloadData when deleting(or inserting) a row? why??
                //tableupdates didn't like removing all - may need to do a loop call!!
                //works but screen not updated.
//                questionsTableView.reloadData()
                questionList.removeAll()
            }
            
        }
    }
    
    //What to do when Cancel is chosen - nothing reset delete
    func cancelDeleteQuestion(alertAction: UIAlertAction!) {
        delQuestionIndexPath = nil
    }
    
 
    
    func getData() {
        
        questionList = manageDB.getDataFromDB()
    }
    
    //MARK: Actions - Delete all button
    
    
    @IBAction func deleteAll(_ sender: UIButton) {
        
        confirmDelete(questionTitle: "All Questions")
        
        questionsTableView.reloadData()
        
       // manageDB.closeDB()
    }
}

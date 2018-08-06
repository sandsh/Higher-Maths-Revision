//
//  ResultsViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 05/08/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var resultsTableView: UITableView!
    var allResults = [Results]()
    var resultsTable = ResultsDBTable()
    var delQuestionIndexPath : IndexPath? = nil     //handle on what line is to be delete
    
    var testResults: [(testTitle: String, percentScore: Int, numCorrect: Int, numQuestions: Int )] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allResults = resultsTable.getResultsFromTable()
        
        gatherResults()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        print("got data \(testResults.count)")
    }

    
    //MARK: Table handlers - listing results
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("got any \(testResults.count)")
        return testResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")

        print("getting cell data")
        cell.textLabel?.text = testResults[indexPath.row].testTitle
        
        let detail1 = String(testResults[indexPath.row].percentScore) +
         String(testResults[indexPath.row].numCorrect) + "/" + String(testResults[indexPath.row].numQuestions) + " correct"
        
        cell.detailTextLabel?.text = detail1
        
        return cell
    }
    
    // Allow swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            delQuestionIndexPath =  indexPath
            let resultDel = testResults[indexPath.row]
            //            let rowToDel = tableView.deleteRows(at: [indexPath], with: .fade)
            confirmDelete(questionTitle: resultDel.testTitle)
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
            resultsTableView.beginUpdates()
            //get the ID of the current question so it can be passed on to be deleted from Database
            let testTitle = testResults[indexPath.row].testTitle
            testResults.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            resultsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            delQuestionIndexPath = nil
//            OutMessageLabel.text = "Question \(questId) was deleted"
            resultsTableView.endUpdates()
            //now delete the question from database too
            resultsTable.deleteResultOnDB(testTitle: testTitle)
        }
//        else {
//            print ("deleting all maybe?")
//            if resultsTable.deleteAll() {
////                OutMessageLabel.text = "All questions deleted"
//                //should not use reloadData when deleting(or inserting) a row? why??
//                //tableupdates didn't like removing all - may need to do a loop call!!
//                //works but screen not updated.
//                //                questionsTableView.reloadData()
//                testResults.removeAll()
//            }
            
//        }
    }
    
    //What to do when Cancel is chosen - nothing reset delete
    func cancelDeleteQuestion(alertAction: UIAlertAction!) {
        delQuestionIndexPath = nil
    }
    
    
    
    func gatherResults() {
        
        var testResultTitles: [String] = []
        var currentTitle: String = ""
        var oneResult: (testTitle: String, percentScore: Int, numCorrect: Int, numQuestions: Int )
        let copyResults = allResults
        for result in copyResults {
            var totalScore: Int = 0
            var numQuests: Int = 0
            var correct: Int = 0
//            currentTitle = result.testTitle
            print("looping in copy")
            //if we have't found this test title before
            if !testResultTitles.contains(result.testTitle) {
                //add this new title to the list
                testResultTitles.append(result.testTitle)
                //loop round the whole of results finding the same ones
                for oneRes in allResults {
                    //find the same test title and add it's results on
                    if result.testTitle == oneRes.testTitle {
                        totalScore = totalScore + oneRes.score
                        if oneRes.score > 49 {
                            correct = correct + 1
                        }
                        numQuests = numQuests + 1
                    }
                    
                }
                print("after looping in all \(correct)")
                oneResult.testTitle = result.testTitle
                oneResult.numCorrect = correct
                oneResult.numQuestions = numQuests
                oneResult.percentScore = totalScore / numQuests
                print(oneResult)
                testResults.append(oneResult)
            }
        }
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

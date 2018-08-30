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
    var dummy: String = ""
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

        return testResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
//        let resultCell = cell as! AllResultsTableViewCell
        print("getting cell data")
        
//        resultCell.ResultsTitle.text = testResults[indexPath.row].testTitle
        cell.textLabel?.text = testResults[indexPath.row].testTitle
//        var resultLabel: UILabel!
//        let container = UIView(frame: CGRect(x: 2, y: 5, width: 200, height: 100))
        
        let detail = String(testResults[indexPath.row].percentScore) + "% " +
            String(testResults[indexPath.row].numCorrect) + "/" + String(testResults[indexPath.row].numQuestions) + " correct"
//could add icon - star etc - to detail
//        if testResults[indexPath.row].percentScore > 49  {
//            resultCell.gradeButton.setTitle("✵", for: .normal)
//            resultCell.gradeButton.setTitleColor(UIColor.yellow, for: .normal)
//        } else {
//            resultCell.gradeButton.setTitle("◉", for: .normal)
//            resultCell.gradeButton.setTitleColor(UIColor.purple, for: .normal)
//        }

//        resultCell.ScoreLabel.text = detail
        
//        resultLabel.text = detail
//        resultLabel.frame = container.frame
//        container.addSubview(resultCell.ScoreLabel)
//        resultCell.contentView.addSubview(container)
//        resultCell.detailTextLabel?.text = detail
        
        cell.detailTextLabel?.text = detail
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
            //get the title of the current results so it can be passed on to be deleted from Database
            let testTitle = testResults[indexPath.row].testTitle
            testResults.remove(at: indexPath.row)
            
            //delete the row from the table view
            resultsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            delQuestionIndexPath = nil
//            OutMessageLabel.text = "Question \(questId) was deleted"
            resultsTableView.endUpdates()
            //now delete the question from database too
            resultsTable.deleteResultOnDB(testTitle: testTitle)
        }
    }
    
    //What to do when Cancel is chosen - nothing reset delete
    func cancelDeleteQuestion(alertAction: UIAlertAction!) {
        delQuestionIndexPath = nil
    }
    
    func gatherResults() {
        
        var testResultTitles: [String] = []

        var oneResult: (testTitle: String, percentScore: Int, numCorrect: Int, numQuestions: Int )
        //get a copy of results used to scan over to find same tests
        let copyResults = allResults
        //hold the current position from the copy
        for result in copyResults {
            var totalScore: Int = 0
            var numQuests: Int = 0
            var correct: Int = 0
            
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

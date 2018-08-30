//
//  TestTableTableViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 19/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class TestsTableViewController: UITableViewController {
    
    //passed in data
    
    
    //class variables
    var testsList = ["All Units","Unit 1","Unit 2","Unit 3"]
    var segueIdentifier = "showTestQuestionsSegue"
    var allQuestionsList = [Question]()
    var currentList = [Question]()
    let manageDB = ManageDBData()
    let manageData = ManageQuestionData()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tests"
        
        //get all the data from db
        
        allQuestionsList = manageDB.getDataFromDB()
        
        // set up lists with only the area selected
        manageData.createLists(questionList: allQuestionsList)
//  not till selected ??        currentList = manageData.getUnitRevisionQuestions(unitName: unitName)
    }



    // MARK: - Table view data source and delegate implementation
    @IBOutlet weak var testTableView: UITableView!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return testsList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Do random Questions from:"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = testsList[indexPath.row]

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //get the value of the row selected
        let unitIndex = testTableView.indexPathForSelectedRow?.row
        
        //get a list of all the questions for that unit
        currentList = manageData.getUnitRevisionQuestions(unitName: testsList[unitIndex!], QuestionList: allQuestionsList)
        
        print ("current number \(String(currentList.count))")
        //pass data over to view controllers depending on where it has come from
        let destination = (segue.destination as? MasterPageViewController)!
        //send the title of what was chosen with the word test added to the title
        destination.titleName  = testsList[unitIndex!] + " Test"
        //set for what buttons displayed in the questions
        // this is a test - set up questions as appropriate
        destination.testType = "Test"

        //when exam questions added this will change ? or make exam a question tyepe
        destination.questionsList = currentList
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }

}

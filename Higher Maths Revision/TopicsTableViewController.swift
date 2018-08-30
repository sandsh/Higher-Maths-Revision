//
//  AlgebraTableViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 28/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController, UISearchBarDelegate{

    //MARK: properties
    
    var QuestionList = [Question]()
    
    //create an instance of the database manager
    let manageDB = ManageDBData()
    
    //outlets
    @IBOutlet var topicsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //input name and unit passed to use when setting up view
    var areaName: String = ""
    var unitName: String = ""
    
    var currentList = [Question]()              // the list to be displayed on this view
    var actualQuestions = [Question]()          //the list of questions that will be displayed
    var tagsArray: [String] = []
    var currentTopics: [String] = []                   //those topics that we have
    var currentFilteredTopics: [String] = []
    var topicTags: [[String]] = []              //2D array with topic and tags
    var currentTopicsAll: [String] = []
    var topicName:String!
    
    let segueIdentifier = "showQuestionsSegue"       //move to questions Screen

    //get an instance of the model for handling the data
    let manageData = ManageQuestionData()
    
    //initial display and functions to be performed only once
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in topics")
        
        QuestionList = manageDB.getDataFromDB()
        // set up a list with only the area selected
        self.title = areaName
        searchBar.delegate = self
        
        //sort all the question data into area lists
        manageData.createLists(questionList: QuestionList)
        if areaName == "Revision" {
            //get all the topics in that area
            currentList = manageData.getUnitRevisionQuestions(unitName: unitName, QuestionList: QuestionList)
        }else {
        //get a subset of the question list for the topic selected
            currentList = manageData.getCurrentList(areaName: areaName, questionList: QuestionList )
        }
        //get a list of the unique topics in this list to display
        topicTags = manageData.getTopicsList(currentList: currentList)
        
        //need to get 2 lists -  currentTopics may change due to filter so keep an original list
        for topicTitle in topicTags {               // get each array from 2D array but only want title for this display
            currentTopicsAll.append(topicTitle[0])  //title is the first element in the array
        }
        currentTopics = currentTopicsAll
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //if revision is chosen - add in a section for unit revision
        if areaName == "Revision" {
            return 2
        //otherwise just have one section with topics
        } else { return 1 }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //Only one row in the unit revision section
        if areaName ==  "Revision" && section == 0 {
            return 1
        } else {
            return currentTopics.count
        }
    }

    // display only those on the current list that have a unique title
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let topicCell = tableView.dequeueReusableCell(withIdentifier: "tCell", for: indexPath)
        if indexPath.section == 0 {
            if areaName == "Revision"  {
                topicCell.textLabel?.text = "Random questions from \(unitName)"
                topicCell.textLabel?.textColor = UIColor.purple
                return topicCell
            }
        }
        topicCell.textLabel?.text = currentTopics[indexPath.row]
        topicCell.textLabel?.textColor = UIColor.blue
        return topicCell
    }
    
    //this is where the properties of the section header is set
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //changing the color of the header to light grey
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    //set up a title for the header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //only want text on the header at certain positions
        if areaName == "Revision" {
            //only display a header on the second section
            if section == 1 {
                return "or Select a Topic"
            } else {  return " " }
        } else {
                return "Select a Topic"
        }
        
    }
    
    //MARK: SEARCH bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty else {            //if delete search text
            currentTopics = currentTopicsAll        //put all topics back
            topicsTableView.reloadData()            //update the view again
            return
        }
        //does the search text appear in the current topics?
        //filter the topics if the text within the array is the same as that typed in
        // if true will create a new currentTopics array - using an inline function - called a closure
        currentTopics = currentTopicsAll.filter({ (text: String) -> Bool in
            text.lowercased().contains(searchText.lowercased())     //contains any characters
        })
        topicsTableView.reloadData()
     }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        let unitIndex = topicsTableView.indexPathForSelectedRow?.row
        let sellectSection = topicsTableView.indexPathForSelectedRow?.section

        //pass data over to view controllers depending on type of question ??
        let destination1 = (segue.destination as? MasterPageViewController)!
        // if we want to do unit revision only - i chosen the first section option
        if areaName == "Revision" && sellectSection == 0 {
            destination1.titleName  = "\(unitName) Revision"
            destination1.testType = "Revision"
        } else {
            destination1.titleName  = currentTopics[unitIndex!]
            destination1.testType = "practice"
        }
        
        destination1.questionsList = currentList
        
    }

    // use this when for moving to segue of choice
    //when a question topic has been selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        performSegue(withIdentifier: segueIdentifier, sender: self)
    
    }


}

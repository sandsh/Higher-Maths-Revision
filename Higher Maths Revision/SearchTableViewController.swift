//
//  SearchTableViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 16/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topicsTable: UITableView!
    
    var currentTopics:[[String]] = []
    var allQuestions: [Question] = []
    let segueIdentifier = "showQuestionsSegue"
    var tagsTopicsAll: [[String]] = []

    
    let manageDbData = ManageDBData()
    let manageData = ManageQuestionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" in searchbar from entry")
        searchBar.delegate = self

        allQuestions = manageDbData.getDataFromDB()
        
        tagsTopicsAll = manageData.getTopicsList(currentList: allQuestions)
        //set the current to all at the start before searching
        currentTopics = tagsTopicsAll
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        print("in rows")
        return currentTopics.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topicCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var outTags: String = " "
        //make a copy of the array - so it can be amended
        var eachTopicAry = currentTopics[indexPath.row]
        //set the title on the cell to the topic name
        topicCell.textLabel?.text = eachTopicAry[0]
        //remove the title now that it is set
        eachTopicAry.remove(at: 0)
        //remove title from array?
        for tag in eachTopicAry {
            outTags = outTags + tag + " "
        }
        topicCell.detailTextLabel?.text = outTags
        return topicCell
    }
    
    //MARK: Entry search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty else {        //if there is a search text
            currentTopics = tagsTopicsAll       //set all the topics found to current
            topicsTable.reloadData()            //update the view again
            return
        }
        //does the search text appear in the questions?
        //filter the topics if the text within the array is the same as that typed in
        // if true will create a new currentQuestions array

        currentTopics = tagsTopicsAll.filter({
            (topics: [String]) -> Bool in        //take each tags array from quetions to check for the searchtext
            checkForText(inWords: topics, searchText: searchText)
        }) 
        topicsTable.reloadData()
    }

    //search for entered word
    func checkForText (inWords: [String], searchText: String) -> Bool {
        
        //Check all members of the array
        //The title is the first element and tags follow - if any
        for word in inWords {
            if word.lowercased().contains(searchText.lowercased()) {
                return true
            }
        }
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let unitIndex = topicsTable.indexPathForSelectedRow?.row
        
        //pass data over to view controllers depending on type of question ??
        let destination = (segue.destination as? MasterPageViewController)!
        destination.titleName  = currentTopics[unitIndex!][0]
        destination.testType = "practice"
        destination.questionsList = allQuestions
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
}

//
//  Unit1TableViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 28/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var unit = String()
    var topicList = [String]()
}

class UnitsTableViewController: UITableViewController {
    
    var tableViewData = [cellData]()
    var U1TopicsList = ["Algebra","Trig Expressions","Functions", "Vectors", "Unit 1 Revision"]
    var U2TopicsList = ["Equations","Trig Equations","Differentiation","Integration", "Unit 2 Revision"]
    var U3TopicsList = ["Straight Lines","Circles","Sequences", "Calculus", "Unit 3 Revision"]
    
    
    //a name for the unit passed form the segue - could use to set up each view maybe??
//    var unitName = String()
    let segueIdentifier = "showTopicsSegue"
    
    @IBOutlet var unitsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = "Unit Topics"
        
        tableViewData =
            [cellData(opened: false, unit: "Unit 1", topicList: U1TopicsList),
             cellData(opened: false, unit: "Unit 2", topicList: U2TopicsList),
            cellData(opened: false, unit: "Unit 3", topicList: U3TopicsList) ]
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableViewData[section].opened == true {
            //add one on to the number of topics to allow for the title
            return tableViewData[section].topicList.count + 1
        } else {
            return 1
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //offset the list for the title - to get the correct row subtract 1
        let dataIndex = indexPath.row - 1
        //if this is the element in the section
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].unit
            cell.textLabel?.textColor = UIColor.blue

            cell.textLabel?.textAlignment = .center
            return cell
        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = tableViewData[indexPath.section].topicList[dataIndex]
            cell.textLabel?.textColor = UIColor.purple
            cell.textLabel?.textAlignment = .left
            return cell
            
        }

    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle: String = ""
        if section == 0 {
            headerTitle = "Select a Topic"
        }
        return headerTitle
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as? TopicsTableViewController
        let section = unitsTableView.indexPathForSelectedRow?.section
        // offset the index for the title - data at 1 less than current index to
        let topicIndex = (unitsTableView.indexPathForSelectedRow?.row)! - 1
        //if unit revision is selected then change the name passed in to just revision
        if topicIndex == 4 {
            destination?.areaName  = "Revision"
            destination?.unitName = tableViewData[section!].unit
        } else {
        destination?.areaName  = tableViewData[section!].topicList[topicIndex]
        destination?.unitName = tableViewData[section!].unit
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                //load the sections from the right
                tableView.reloadSections(sections, with: .right )
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                //load the sections from the right
                tableView.reloadSections(sections, with: .left )
            }
        } else {
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
    
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.

}
extension QuestionViewController {
    
    //this makes the return back to the units screen once done is selected on results screen
    @IBAction func cancelToUnitsTbViewController(_ segue: UIStoryboardSegue) {
        //no code required as nothing is passed back
    }
    
}//end extension





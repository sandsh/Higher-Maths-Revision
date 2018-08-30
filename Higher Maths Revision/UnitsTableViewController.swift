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
    
    var topicImages = [[UIImage]]()
    
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
        
        addTopicImages()
        
        
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
        //if this is the first element in the section
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            let topicCell = cell as! TopicTableViewCell
            topicCell.textLabel?.text = tableViewData[indexPath.section].unit

            topicCell.textLabel?.textColor = UIColor.blue
            topicCell.textLabel?.textAlignment = .center
            //hide any images that may have lingered from the previous view

            topicCell.topicLabel.isHidden = true
            topicCell.topicImage.isHidden = true
            print("hiding image section \(tableViewData[indexPath.section].unit) \(indexPath.section) row \(indexPath.row)  ")
            return topicCell
        } else {
          //get the correct topic depending on the section and row
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = " "
            
            let topicCell = cell as! TopicTableViewCell
            let topictext = tableViewData[indexPath.section].topicList[dataIndex]

            topicCell.topicLabel.text = topictext
            topicCell.textLabel?.textAlignment = .left
//
            topicCell.topicLabel.isHidden = false
            topicCell.topicImage.isHidden = false
            
            let imageview:UIImageView = UIImageView(frame: CGRect(x: 250, y: 10, width: 50, height: 30))
            imageview.clearsContextBeforeDrawing = true
            let image:UIImage = topicImages[indexPath.section][dataIndex]
            imageview.image = image

            //set the content as the imageview
            cell.contentView.addSubview(imageview)
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
    //MARK: Class methods
    
    func addTopicImages() {
        var U1TopicImages: [UIImage] = []
        var U2TopicImages: [UIImage] = []
        var U3TopicImages: [UIImage] = []
        
        U1TopicImages.append(#imageLiteral(resourceName: "algebra logs"))
        U1TopicImages.append(#imageLiteral(resourceName: "sine curve"))
        U1TopicImages.append(#imageLiteral(resourceName: "functions"))
        U1TopicImages.append(#imageLiteral(resourceName: "vector"))
        U1TopicImages.append(#imageLiteral(resourceName: "units3"))
        
        topicImages.append(U1TopicImages)
        
        U2TopicImages.append(#imageLiteral(resourceName: "synthetic division"))
        U2TopicImages.append(#imageLiteral(resourceName: "trig eqn"))
        U2TopicImages.append(#imageLiteral(resourceName: "differentiation"))
        U2TopicImages.append(#imageLiteral(resourceName: "integration"))
        U2TopicImages.append(#imageLiteral(resourceName: "units3"))
        
        topicImages.append(U2TopicImages)
        U3TopicImages.append(#imageLiteral(resourceName: "straightline"))
        U3TopicImages.append(#imageLiteral(resourceName: "circles"))
        U3TopicImages.append(#imageLiteral(resourceName: "limit"))
        U3TopicImages.append(#imageLiteral(resourceName: "calculus"))
        U3TopicImages.append(#imageLiteral(resourceName: "units3"))
        
        topicImages.append(U3TopicImages)
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





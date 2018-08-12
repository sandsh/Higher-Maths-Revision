//
//  Unit2CollectionViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 28/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit


class Unit2CollectionViewController: UICollectionViewController {

//    var QuestionList = [Question]()
    private let reuseIdentifier = "TopicCell"
    @IBOutlet weak var cellLabel: UILabel!
    
    var areaName: String = ""
    
    var currentList = [Question]()              // the list to be displayed on this view
    var actualQuestions = [Question]()          //the list of questions that will be displayed
    var currentIndex: Int!
    var currentTopics: [String] = []                   //those topics that we have
 //   var currentQuestsSeq: [Int] = []            //an empty integer array - hooray
    
//    let manageDB = ManageDBData()
    let segueIdentifier = "showTopicsSegue"       //move to questions Screen
    
    let manageData = ManageQuestionData()
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    //@IBOutlet weak var topicImage: UIImageView!
    
    var U2TopicsList = ["Equations","Trig Equations","Differentiation","Integration", "Revision"]
    var topicImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up the images of the topics
        topicImages.append(#imageLiteral(resourceName: "equations"))
        topicImages.append(#imageLiteral(resourceName: "Trig eqns"))
        topicImages.append(#imageLiteral(resourceName: "differentiation"))
        topicImages.append(#imageLiteral(resourceName: "Integration1"))
        topicImages.append(#imageLiteral(resourceName: "unit 2 Revision"))
        
//        QuestionList = manageDB.getDataFromDB()
//        // set up a list with only the area selected
//        self.title = areaName
//
//        //sort all the question data into area lists
//        manageData.createLists(questionList: QuestionList)
//        //get a subset of the question list for the area selected
//        currentList = manageData.getCurrentList(areaName: areaName, questionList: QuestionList )
//        //get a list of the unique topics in this list to display
//        currentTopics = manageData.getTopicsList(currentList: currentList)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return U2TopicsList.count
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCell", for: indexPath)
        let header = collectionView.dequeueReusableCell(withReuseIdentifier: "head", for: indexPath)
      
        // set label to text from array
        let topicCell = cell as! TopicTableViewCell
        let topictext = U2TopicsList[indexPath.item]
        topicCell.topicLabel.text = topictext
        
        //create an imageview then move the image into it
        let imageview:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 130))
        let image:UIImage = topicImages[indexPath.row]
        imageview.image = image
        //set the content as the imageview
        cell.contentView.addSubview(imageview)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the name of the selected object to the new view controller.
        let unitIndex = currentIndex
        
        let destination = segue.destination as? TopicsTableViewController
        destination?.areaName  = U2TopicsList[unitIndex!]
        destination?.unitName = "Unit 2"            //the next view needs to know for the revsion questions 

        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row               //the index of the selected cell
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
}


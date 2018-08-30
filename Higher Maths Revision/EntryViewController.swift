//
//  EntryViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 22/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit
import iosMath

class EntryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomeModelProtocol {
    
    func itemsDownloaded(items: NSArray) {
        let setUpData = SetUpDatabase()
        let questionList = items
        setUpData.openOrCreateDB(fileURL: fileURL)
        for question in questionList {
            setUpData.addValuesToDB(newQ: question as! Question, fileURL: fileURL)
        }
    }
    
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("questionsTable4.sqlite")
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    var mainViewImages: [UIImage] = []
    var unitName: String!
    var unitIndex: Int!
    
    let segueIds = ["showUnitsSegue", "showTestsSegue", "showDailySegue", "showFormulaSegue", "showSavesSegue", "showAllResultsSegue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //don't forget datasource and delegate protocol above
        areaCollectionView.dataSource = self
        areaCollectionView.delegate = self
        // load the images for the entry screen
        mainViewImages.append(#imageLiteral(resourceName: "units3"))
        mainViewImages.append(#imageLiteral(resourceName: "tests3"))
        mainViewImages.append(#imageLiteral(resourceName: "daily3"))
        mainViewImages.append(#imageLiteral(resourceName: "formula3"))
        mainViewImages.append(#imageLiteral(resourceName: "saves3"))
        mainViewImages.append(#imageLiteral(resourceName: "results3"))
        
        let setUpData = SetUpDatabase()
        let readJson = ReadJson()
        //if no question data in the table
        if !setUpData.doesTableExist(fileURL: fileURL) {
            print("setting up data - table not exist")
            readJson.delegate = self
            let questionList = readJson.downloadItems()
        } else {
            print("table does exist")
        }
        
//        collectionView?.setCollectionViewLayout(CustomFlowLayout(), animated: false)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return mainViewImages.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = areaCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        // set label to text from array
        let imageCell = cell as! EntryCollectionViewCell
        
        //create an imageview then move the image into it
        let imageview:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 130))
        let areaImage:UIImage = mainViewImages[indexPath.row]
        imageview.image = areaImage

//        imageview.animationImages = mainViewImages
//        imageview.animationDuration = 0.1
//        imageview.startAnimating()
//        imageCell.areaImageView = imageview
        //set the content as the imageview
        imageCell.contentView.addSubview(imageview)
        
        return cell
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showUnitsSegue":
            let destination = segue.destination as? UnitsTableViewController
        case "showTestsSegue":
            let destination = segue.destination as? TestsTableViewController
        case "showDailySegue":
            let destination = segue.destination as? DailyViewController
        case "showFormulaeSegue":
            let destination = segue.destination as? FormulaeTableViewController
            destination?.viewType  = "All"
        case "showResultsSegue":
            let destination = segue.destination as? ResultsViewController
            destination?.dummy  = "Results"
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unitIndex = indexPath.row
        performSegue(withIdentifier: segueIds[unitIndex], sender: self)
        
    }
    
}
extension EntryViewController {
    
    //this makes the return back to the question screen once done is selected on answer screen
    @IBAction func cancelToHomeViewController(_ segue: UIStoryboardSegue) {
        //no code required as nothing is passed back
    }
    
}//end extension



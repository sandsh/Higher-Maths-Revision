//
//  EntryViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 22/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit
import iosMath

////MARK: - Animate the cells as they are displayed
//class CustomFlowLayout : UICollectionViewFlowLayout {
//    var insertingIndexPaths = [IndexPath]()
//
//    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
//
//        //if insertingIndexPaths.contains(itemIndexPath) {
// //       attributes?.alpha = 0.0
////        attributes?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
////        attributes?.transform = CGAffineTransform(translationX: 0, y: 500.0)
//
//        //}
//
//        return attributes
//    }
//}


//test this is still ok after pull

class EntryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("questionsTable4.sqlite")
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    var mainViewImages: [UIImage] = []
    var unitName: String!
    var unitIndex: Int!
    
    
    let segueIds = ["showUnitsSegue", "showTestsSegue", "showDailySegue", "showFormulaSegue", "showSavesSegue", "showAllResultsSegue"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //don't forget datasource and delegate class above
        areaCollectionView.dataSource = self
        areaCollectionView.delegate = self
        // load the images for the entry screen
        mainViewImages.append(#imageLiteral(resourceName: "units 2"))
        mainViewImages.append(#imageLiteral(resourceName: "Tests"))
        mainViewImages.append(#imageLiteral(resourceName: "Daily Revision copy"))
        mainViewImages.append(#imageLiteral(resourceName: "Formulae 2"))
        mainViewImages.append(#imageLiteral(resourceName: "Saves"))
        mainViewImages.append(#imageLiteral(resourceName: "Results 2 "))
        
        let setUpData = SetUpDatabase()
        
        //if no question data in the table
        if !setUpData.doesTableExist(fileURL: fileURL) {
            print("setting up data - table not exist")
            let questionList = ReadJason.data()
            setUpData.openOrCreateDB(fileURL: fileURL)
            for question in questionList {
                setUpData.addValuesToDB(newQ: question, fileURL: fileURL)
            }
        } else {
            print("table does exist")
        }
        
        print("aftertable updated")
//        collectionView?.setCollectionViewLayout(CustomFlowLayout(), animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        print("after view appeared")
        
//        areaCollectionView.setCollectionViewLayout(CustomFlowLayout(), animated: false)
        
//            imageview.animationImages = mainViewImages
//        self.imageview.animationDuration = 0.25
//        self.imageview.startAnimating()
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
        print("selecting")
        unitIndex = indexPath.row
        performSegue(withIdentifier: segueIds[unitIndex], sender: self)
        
    }
    
}


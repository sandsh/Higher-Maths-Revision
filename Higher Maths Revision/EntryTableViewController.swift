//
//  ViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 28/06/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit
//make a global variable of the file path - so I only have to change table names here
//let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("questionsTable3.sqlite")

class EntryTableViewController: UITableViewController {

    @IBOutlet var entryTable: UITableView!
    
    var unitName: String!
    var unitIndex: Int!
    let unitNames = ["Unit 1", "Unit 2", "Unit 3", "Tests", "Daily", "Formulae", "Results"]
    
    let segueIds = ["showUnitsSegue", "showUnit2Segue", "showUnitsSegue", "showTestsSegue", "showDailySegue", "showFormulaeSegue", "showResultsSegue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }


    //MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "showUnitsSegue":
            let destination = segue.destination as? UnitsTableViewController
//        case "showUnit2Segue":
//            let destination = segue.destination as? Unit2CollectionViewController
        case "showTestsSegue":
            let destination = segue.destination as? TestsTableViewController
//        case "showDailySegue":
//            let destination = segue.destination as? UnitsTableViewController
        case "showFormulaeSegue":
            let destination = segue.destination as? FormulaeTableViewController
            //information for formulae to display depending on where selected
            destination?.viewType  = "All"
            
//        case "showResultsSegue":
//            let destination = segue.destination as? UnitsTableViewController
//            destination?.unitName  = unitNames[unitIndex]
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        unitIndex = indexPath.row
        performSegue(withIdentifier: segueIds[unitIndex], sender: self)
        
    }
}


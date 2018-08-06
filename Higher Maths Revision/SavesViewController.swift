//
//  SavesViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 25/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class SavesViewController: UIViewController {

    
    @IBOutlet weak var savedImageView: UIImageView!
    
    var questionImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()

        //simply just display the image
        
        savedImageView.image = questionImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

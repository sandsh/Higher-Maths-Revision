//
//  DataFiles.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 23/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation
import UIKit

class DataFiles {
    
    
    var fileNames: [String] = []
    var fileImages: [UIImage] = []
    
    func saveImagetoFile(image: UIImage, saveName: String) {
        
        createDirectory()
        //get the image passed in and save as a png in documents directory
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("MQ\(saveName).png")
            try? data.write(to: filename)
        }
        
    }
    
    // get the URl for the
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Questions")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already directory created.")
        }
    }
    func getImagesFromFile () -> [UIImage] {
        
//        let directorypath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        for fileSaved in directorypath {
//        
//        }
        var fileImages: [UIImage] = []
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            let fileNamesURLs = fileURLs
            //gets the names of the files correctly - but we don't want all the guff
//            fileNames = fileNamesURLs.map{ $0.deletingPathExtension().lastPathComponent}
            //now get the name and image data of each file
            for fileUrl in fileNamesURLs{
                //get the end string of the url - this should be name saved as
                var fileName = fileUrl.deletingPathExtension().lastPathComponent
                //we only want those of the right format
                if fileName.hasPrefix("MQ") {
                    fileName.removeFirst(2)
                    fileNames.append(fileName)
                    //now get the data
                    if let data = try? Data(contentsOf: fileUrl) {
                        let image: UIImage = UIImage(data: data)!
                        fileImages.append(image)
                    }
                }
            }
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        return fileImages
        
        
    }
    
    
}

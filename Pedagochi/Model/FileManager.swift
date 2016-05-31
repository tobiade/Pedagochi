//
//  FileManager.swift
//  Pedagochi
//
//  Created by Lanre Durosinmi-Etti on 30/05/2016.
//  Copyright © 2016 Tobi Adewuyi. All rights reserved.
//

import Foundation
import XCGLogger
class FileManager {
    let log = XCGLogger.defaultInstance()
    static let sharedInstance = FileManager()
    
    func getDocumentsURL() -> NSURL{
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
        let documentsURL = NSURL(string: directories.first!)
        return documentsURL!
    }
    
    func fileNameInDocumentsDirectory(filename: String) -> String{
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    func loadImageFromPath(path: String) -> UIImage?{
        let image = UIImage(contentsOfFile: path)
        
        guard image != nil else{
            return nil
        }
        return image
    }
    
    func saveImage(image: UIImage, path: String) -> Bool{
        let pngImage = UIImagePNGRepresentation(image)
        let result = pngImage?.writeToFile(path, atomically: true)
        return result!
    }
    func removeFileAtPath(path: String){
        do {
          try  NSFileManager.defaultManager().removeItemAtPath(path)
        }catch{
            log.debug("error is \(error)")
        }
    }
}

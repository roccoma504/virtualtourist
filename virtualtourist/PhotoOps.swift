//
//  PhotoOps.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/15/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import UIKit

class PhotoOps {
    
    private var image = UIImage()
    
    init (image : UIImage) {
    self.image = image
    }
    
    
    private func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, completion: (result: Bool) -> Void)  {
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            guard let data = data where error == nil else { return }
            print(response?.suggestedFilename ?? "")
            print("Download Finished")
            self.image = UIImage(data: data)!
            completion(result: true)
        }
    }
    
    func photoImage() -> UIImage {
        return self.image
    }
    
}


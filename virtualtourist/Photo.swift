//
//  Photo.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/6/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import MapKit

class Photo : NSManagedObject {
    
    @NSManaged var url: String?
    @NSManaged var pin: Pin?

    
    /**
     Contains all of the keys for the diectionary.
     - url: url of the image
     */
    struct Keys {
        static var url = "url"
    }

    override init(
        entity: NSEntityDescription, insertIntoManagedObjectContext
        context: NSManagedObjectContext?) {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /**
     Initializes the photo object.
     - Parameters:
     - dictionary: the input dictionary when creating the object
     - context: the content for Core Dat
     */
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Define the entity from the model.
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Assign the image url from the input dictionary.
        url = dictionary[Keys.url] as? String
        
    }
    
}
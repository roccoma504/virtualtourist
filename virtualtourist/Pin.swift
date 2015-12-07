//
//  Pin.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/6/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import MapKit

class Pin : NSManagedObject, MKAnnotation {
    
    // Define a coordinate as this class is a sub of MKAnnotation.
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    // Defines all of the Core Data managed elements.
    @NSManaged var title: String?
    @NSManaged var long: Double
    @NSManaged var lat: Double
    @NSManaged var images: [Photo]
    
    /**
     Contains all of the keys for the diectionary.
     - lat: latitude of the pin
     - long: longitude of the pin
     */
    struct Keys {
        static var lat = "lat"
        static var long = "long"
        static var title = "title"
    }
    
    override init(
        entity: NSEntityDescription, insertIntoManagedObjectContext
        context: NSManagedObjectContext?) {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /**
     Initializes the Pin object.
     - Parameters:
     - dictionary: the input dictionary when creating the object
     - context: the content for Core Dat
     */
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Define the entity from the model.
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Assign the lat and long from the input dictionary.
        long = dictionary[Keys.long] as! Double
        lat = dictionary[Keys.lat] as! Double
        title = dictionary[Keys.title] as? String
    }
}
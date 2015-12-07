//
//  Photo.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/6/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import MapKit

class Photo : NSManagedObject, MKAnnotation {
    
    @NSManaged var coordinate: CLLocationCoordinate2D
    @NSManaged var title: String?
    @NSManaged var pin: Pin?
    
    struct defaults {
        static let lat = "lat"
        static let long = "long"
        static let title = "title"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        title = dictionary[defaults.title] as? String
        coordinate.latitude = dictionary[defaults.lat] as! Double
        coordinate.longitude = dictionary[defaults.long] as! Double
        
    }
    
    func getPin() -> Photo {
        return self
    }
    
}
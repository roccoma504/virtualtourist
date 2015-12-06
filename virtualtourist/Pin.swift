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
    
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @NSManaged var title: String?
    @NSManaged var images: [Photo]
    @NSManaged var long: Double
    @NSManaged var lat: Double
    
    struct defaults {
        static var title = "title"
        static var lat = "lat"
        static var long = "long"
        static var test = "test"
    }
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        title = dictionary[defaults.title] as? String
        print(title)
        long = dictionary[defaults.long] as! Double
        lat = dictionary[defaults.lat] as! Double
        
        coordinate.latitude = lat
        coordinate.longitude = long

    }
    
    func getPin() -> Pin {
        return self
    }
}
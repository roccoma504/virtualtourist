//
//  mapViewTests.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/3/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import Foundation
import XCTest

@testable import virtualtourist

class PinTests: XCTestCase {
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func testPin() {
        
        // Define the dictionary.
        let dictionary: [String : AnyObject] = [
            Pin.Keys.lat : 100.0,
            Pin.Keys.long : 100.0,
            Pin.Keys.title : ""]
        
        let pin = Pin(dictionary: dictionary, context: sharedContext)
        XCTAssertEqual("", pin.title)
        XCTAssertEqual(100.0, pin.lat)
        XCTAssertEqual(100.0, pin.long)
    }
}

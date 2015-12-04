//
//  Region.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/3/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import MapKit


struct Region {
    let center : CLLocationCoordinate2D
    let span : MKCoordinateSpan
    
    func region() -> Region {
        return self
    }
}
//
//  MapViewController.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/3/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import Foundation
import MapKit
import UIKit

private var coordinates:CLLocationCoordinate2D!

class MapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        // Set the delegate
        mapView.delegate = self
        // Load and configure the mapview.
        loadMapConfig()
    }
    
    override func viewDidDisappear(animated: Bool) {
        setMapConfig()
    }
    
    /**
     Configure the mapview based on what is in defaults.
     */
    func loadMapConfig() {
        
        // Define the defaults.
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        // If there is data in the defaults, configure the mapview. The center
        // lat is the first thing that gets set so if the set fails on a data
        // element before it then nothing will exist here.
        if let _ = defaults.objectForKey("deltaLong") {
            
            // Set the center coord and span and adjust the map accordingly.
            let centerCoord = CLLocationCoordinate2D(
                latitude:  (defaults.objectForKey("centerLat") as? Double)!,
                longitude: (defaults.objectForKey("centerLong") as? Double)!)
            let span = MKCoordinateSpan(
                latitudeDelta: (defaults.objectForKey("deltaLat") as? Double)!,
                longitudeDelta: (defaults.objectForKey("deltaLong") as? Double)!)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(centerCoord, span)
            
            mapView.centerCoordinate = centerCoord
            mapView.setRegion(region, animated: true)
        }
    }
    
    /**
     Set the current map configuration based on the current state
     of the mapview.
     */
    func setMapConfig() {
        NSUserDefaults.standardUserDefaults().setObject(
            mapView.centerCoordinate.latitude, forKey: "centerLat")
        NSUserDefaults.standardUserDefaults().setObject(
            mapView.centerCoordinate.longitude, forKey: "centerLong")
        NSUserDefaults.standardUserDefaults().setObject(
            mapView.region.span.latitudeDelta, forKey: "deltaLat")
        NSUserDefaults.standardUserDefaults().setObject(
            mapView.region.span.longitudeDelta, forKey: "deltaLong")
        
    }
}
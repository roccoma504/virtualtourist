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
        // Add a tap action to the view.
        addTapAction(mapView: mapView, target:self, action: "addAnnotation:")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        setMapConfig()
    }
    
    /**
     Adds a gesture recognizer to the mapview.
     
     - Parameters:
         - mapView: the mapview to add the action to
         - target: the target for the tap (self)
         - action: the action to be performed
         - tapDuration: the length of the tap before activation
     */
    func addTapAction(mapView mapView: MKMapView,
        target: AnyObject,
        action: Selector,
        tapDuration: Double = 1){
            // Define the recongizer based on the input parameters and set the tap
            // length to 1 second.
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: target,
                action: action)
            longPressRecognizer.minimumPressDuration = tapDuration
            
            // Add gesture recognizer to the map.
            mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    /**
     Returns a location based on the tap.
     
     - Parameters:
         - mapView: the mapview to add the action to
         - gestureRecognizer: the gesture that the user performed
     
     - Returns: A 2d location
     */
    func getTappedLocation(mapView mapView: MKMapView,
        gestureRecognizer: UIGestureRecognizer) -> CLLocationCoordinate2D{
            
            // Get the position on the screen where the user pressed, relative to the mapView
            let touchPoint = gestureRecognizer.locationInView(mapView)
            
            // Get location coordinate in map
            return mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
    }
    
    /**
     Adds the annotation to the map
     
     - Parameters:
     - gestureRecognizer: the gesture that the user performed
     
     */
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        let location = getTappedLocation(mapView: mapView, gestureRecognizer: gestureRecognizer)
        
        // Add an annotation to the map. We need to remove the gesture recognizer
        // to prevent a bunch of pins from being created.
        let annotation = MKPointAnnotation()
        annotation.coordinate = location;
        annotation.title = "You created this annotation!"
        mapView.addAnnotation(annotation)
        mapView.removeGestureRecognizer(mapView.gestureRecognizers![0])
        addTapAction(mapView: mapView, target:self, action: "addAnnotation:")
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
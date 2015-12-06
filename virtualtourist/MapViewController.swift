//
//  MapViewController.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/6/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import MapKit
import UIKit


class MapViewController : UIViewController, MKMapViewDelegate {
    
    var photos = [Photo]()
    var pins = [Pin]()

    
    // MARK: - Life Cycle
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate
        mapView.delegate = self
        // Load and configure the mapview.
        loadMapConfig()
        // Add a tap action to the view.
        addTapAction(mapView: mapView, target:self, action: "addAnnotation:")
        pins = fetchAllActors()
        print(pins.count)
        //print(pins)
        
        // Check to see if we already have this actor. If so, return.
        for i in pins {
            print(i.lat)
            print(i.long)
            i.coordinate.latitude = i.lat
            i.coordinate.longitude = i.long
            processAnnotation([i])
        }
    }
    
    func processAnnotation(pin : [Pin]) {
        mapView.addAnnotations(pin)
    }
    
    override func viewDidDisappear(animated: Bool) {
        setMapConfig()
    }
    
    // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    /**
     * This is the convenience method for fetching all persistent actors.
     * Right now there are three actors pre-loaded into Core Data. Eventually
     * Core Data will only store the actors that the users chooses.
     *
     * The method creates a "Fetch Request" and then executes the request on
     * the shared context.
     */
    
    func fetchAllActors() -> [Pin] {
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Execute the Fetch Request
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllActors(): \(error)")
            return [Pin]()
        }
    }
    
    // MARK: - Saving the array
    
    var actorArrayURL: NSURL {
        let filename = "favoriteActorsArray"
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        return documentsDirectoryURL.URLByAppendingPathComponent(filename)
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Set up the custom bins. Add an animation, the callout, and a button.
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.animatesDrop = true
        pin.canShowCallout = true
        return pin
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
        mapView.addAnnotation(annotation)
        mapView.removeGestureRecognizer(mapView.gestureRecognizers![0])
        addTapAction(mapView: mapView, target:self, action: "addAnnotation:")
        
        print(location.latitude)
        print(location.longitude)

        let dictionary: [String : AnyObject] = [
            Pin.defaults.title : "new pin",
            Pin.defaults.lat : location.latitude,
            Pin.defaults.long : location.longitude,
            Pin.defaults.test : ""]
        
        // Now we create a new Person, using the shared Context
        
        let actorToBeAdded = Pin(dictionary: dictionary, context: sharedContext)
        
        // And add append the actor to the array as well
        pins.append(actorToBeAdded)
        print(pins.count)
        print(pins)
        
        CoreDataStackManager.sharedInstance().saveContext()

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
            print("data loaded")

            
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
        print("data set")
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
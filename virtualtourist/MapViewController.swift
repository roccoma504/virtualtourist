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
    
    private var pins = [Pin]()
    private var clickedPin = Pin()
    private var clickedAnnotation : MKAnnotationView!
    
    // Define all UI elements.
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Perform setup processing.
     - Set delegates
     - Load the map configuration from user defaults
     - Add the tap recognizer
     - Set the global pin variable
     - Remove the pins and then re-add them
     */
    override func viewDidAppear(animated: Bool) {
        mapView.delegate = self
        addTapAction(mapView: mapView, target:self, action: "addAnnotation:")
        loadMapConfig()
        pins = fetchPins()
        processAnnotations(true)
    }
    
    /**
     On disappear set the current state of the map into defaults and remove
     the pins.
     */
    override func viewDidDisappear(animated: Bool) {
        processAnnotations(false)
        setMapConfig()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    /**
     Controls the placement of pins on the map.
     - Parameters:
     - add - if true, pins are added else they are removed
     */
    func processAnnotations(add : Bool) {
        for i in pins {
            i.coordinate.latitude = i.lat
            i.coordinate.longitude = i.long
            if add {mapView.addAnnotations([i]) }
            else {mapView.removeAnnotations([i]) }
        }
    }
    
    /**
     Fetch all of the pins from persistent storage.
     - Returns: an array of pins. Can be empty if there is an error.
     */
    func fetchPins() -> [Pin] {
        
        // Create the request from the modal.
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Execute the fetch. If the fetch is successful post
        // all of the pins on the map. Else log the error and
        // present an alert to the user.
        do {
            let pins = try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
            return pins
        } catch  let error as NSError {
            print("Error in fetchPins(): \(error)")
            showAlert("There was an error retrieving data. Please reload.")
            return [Pin]()
        }
    }
    
    /**
     Adds a gesture recognizer to the mapview.
     - Parameters:
     - mapView - the mapview to add the action to
     - target - the target for the tap (self)
     - action - the action to be performed
     - tapDuration - the length of the tap before activation
     */
    func addTapAction(mapView mapView: MKMapView,
        target: AnyObject,
        action: Selector,
        tapDuration: Double = 0.5) {
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
     - mapView - the mapview to add the action to
     - gestureRecognizer - the gesture that the user performed
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
     Configures the pin(s).
     - Parameters:
     - mapView - the mapview to add the action to
     - viewForAnnotation - the annotation view
     - Returns: a custom pin.
     */
    func mapView(mapView: MKMapView, viewForAnnotation : MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: viewForAnnotation, reuseIdentifier: "pin")
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
        annotation.title = "View Pictures"
        mapView.addAnnotation(annotation)
        mapView.removeGestureRecognizer(mapView.gestureRecognizers![0])
        addTapAction(mapView: mapView, target:self, action: "addAnnotation:")
        
        // Define the dictionary.
        let dictionary: [String : AnyObject] = [
            Pin.Keys.lat : location.latitude,
            Pin.Keys.long : location.longitude,
            Pin.Keys.title : "View Pictures"]
        
        // Create a new pin with the dictionary and add it to the array.
        let newPin = Pin(dictionary: dictionary, context: sharedContext)
        pins.append(newPin)
        
        // Save the new pin into core data.
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
    
    func mapView(mapView: MKMapView, didSelectAnnotationView: MKAnnotationView) {
        clickedAnnotation = didSelectAnnotationView
        self.performSegueWithIdentifier("mapToPictures", sender: self)
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
    
    /** This subprogram generates an alert for the user based upon conditions
     in the application. This view controller can generate two different
     alerts so this is here only for reuseability.
     */
    func showAlert(message : String) {
        dispatch_async(dispatch_get_main_queue(),{
            let alertController = UIAlertController(title: "Error!", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss",
                style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController,animated: true,completion: nil)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "mapToPictures") {
            let navigationController = segue.destinationViewController
            let destView = navigationController as! AlbumViewController
            destView.receivedAnnotation = clickedAnnotation
            destView.receivedPin = pins[0]
        }
    }
}
//
//  AlbumViewController.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/6/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import CoreData
import Foundation
import MapKit
import UIKit

class AlbumViewController : UICollectionViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionPress: UIBarButtonItem!
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    private var detailMemeImage : UIImage!
    
    var receivedAnnotation : MKAnnotationView!
    var receivedPin : Pin!

    private var photos = [Photo]()
    
    /**
     Perform setup processing.
     - Set the mapview up
     - Drop the pin that was selected
     - Retrieve Flickr photos
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        
        // Scope the mapview.
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5 , 0.5)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(
            (receivedAnnotation.annotation?.coordinate)!, span)
        self.mapView.centerCoordinate = (receivedAnnotation.annotation?.coordinate)!
        self.mapView.setRegion(region, animated: true)
        mapView.addAnnotation(receivedAnnotation.annotation!)
        
        let networkingOps = NetworkingOps(
            lat: (receivedAnnotation.annotation?.coordinate.latitude)!,
            long: (receivedAnnotation.annotation?.coordinate.longitude)!)
        
        networkingOps.getFlikrPhoto()
        
        // Define the dictionary.
        let dictionary: [String : AnyObject] = [
            Photo.Keys.url : "test"]
        
        // Create a new pin with the dictionary and add it to the array.
        let newPhoto = Photo(dictionary: dictionary, context: sharedContext)
        print(receivedPin)
        newPhoto.pin = receivedPin
        photos.append(newPhoto)
        print(photos)
        //newPhoto.pin = receivedPin
        //photos.pin = pin
        
        // Save the new pin into core data.
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Defines the number of sections in the collection.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Defines the number of cells in the section, this scales depending on
    // the number of memes.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PictureCollectionCell
        cell.backgroundColor = UIColor.blackColor()
        //cell.flickrImage = UIImage(named: <#T##String#>)
        // Configure the cell
        return cell
    }
}
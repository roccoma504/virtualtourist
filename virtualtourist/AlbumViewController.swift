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
    
    @IBOutlet weak var newCollectionPress: UIBarButtonItem!
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    private var detailMemeImage : UIImage!
    private var photos = [Photo]()
    
    private var imageArray = [UIImage]()
    
    var receivedAnnotation : MKAnnotationView!
    var receivedPin : Pin!
    
    
    /**
     Perform setup processing.
     - Set the mapview up
     - Drop the pin that was selected
     - Retrieve Flickr photos
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        
        setCollection()
    }
    
    func setCollection() {
        parsePhotoURL()
        setImages()
        
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func parsePhotoURL() {
        
        let networkingOps = NetworkingOps(
            lat: (receivedAnnotation.annotation?.coordinate.latitude)!,
            long: (receivedAnnotation.annotation?.coordinate.longitude)!)
        
        networkingOps.getFlikrPhoto { (result) -> Void in
            
            for i in 0...(networkingOps.urls().urls().count-1) {
                
                // Define the dictionary.
                let dictionary: [String : AnyObject] = [
                    Photo.Keys.url : networkingOps.urls().urls()[i]]
                
                self.photos = self.fetchPhotos()
                
                // Create a new pin with the dictionary and add it to the array.
                let newPhoto = Photo(dictionary: dictionary, context: self.sharedContext)
                newPhoto.pin = self.receivedPin
                newPhoto.url = String(networkingOps.urls().urls()[i])
                self.photos.append(newPhoto)
            }
            
            print(self.photos)
            print("printed photos")
            
            
            dispatch_async(dispatch_get_main_queue(),{
                
                for i in 0...networkingOps.urls().urls().count - 1 {
                    
                    var photoOps = PhotoOps(image: UIImage())
                    
                    photoOps.downloadImage((NSURL(string: String(networkingOps.urls().urls()[i]))!)) { (result) -> Void in
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            self.imageArray.append(photoOps.photoImage())
                            self.collectionVIew.reloadData()
                        })}}})
            
            // Save the new photos into core data.
            CoreDataStackManager.sharedInstance().saveContext()
            
        }
    }
    
    func setImages () {
        
        dispatch_async(dispatch_get_main_queue(),{
            
            print("in set image")
            self.collectionVIew.reloadData()
        })
        
    }
    
    /**
     Fetch all of the pins from persistent storage.
     - Returns: an array of pins. Can be empty if there is an error.
     */
    func fetchPhotos() -> [Photo] {
        
        // Create the request from the modal.
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        // Execute the fetch. If the fetch is successful post
        // all of the pins on the map. Else log the error and
        // present an alert to the user.
        do {
            let photos = try sharedContext.executeFetchRequest(fetchRequest) as! [Photo]
            return photos
        } catch  let error as NSError {
            print("Error in fetchPins(): \(error)")
            showAlert("There was an error retrieving data. Please reload.")
            return [Photo]()
        }
    }
    
    // Defines the number of sections in the collection.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Defines the number of cells in the section, this scales depending on
    // the number of memes.
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PictureCollectionCell
        cell.backgroundColor = UIColor.blackColor()
        
        cell.flickrImage.image = imageArray[indexPath.row]
        
        // Configure the cell
        return cell
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
}
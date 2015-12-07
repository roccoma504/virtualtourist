//
//  AlbumViewController.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/6/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class AlbumViewController : UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionPress: UIBarButtonItem!
    
    var receivedPin : MKAnnotationView!
    
    /**
     Perform setup processing.
     - Set the mapview up
     - Drop the pin that was selected
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Scope the mapview.
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5 , 0.5)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(
            (receivedPin.annotation?.coordinate)!, span)
        self.mapView.centerCoordinate = (receivedPin.annotation?.coordinate)!
        self.mapView.setRegion(region, animated: true)
        mapView.addAnnotation(receivedPin.annotation!)
    }
}
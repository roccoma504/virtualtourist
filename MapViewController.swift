//
//  MapViewController.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/3/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class MapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate
        mapView.delegate = self
    }

}
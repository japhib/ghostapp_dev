//
//  ViewController.swift
//  MapsTutorial
//
//  Created by JanPaul on 1/23/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var mapView: GMSMapView?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var marker: GMSMarker?
    var initial_update = false
    
    var path: GMSMutablePath?
    var polyline: GMSPolyline?
    
    var coord_list: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    let initial_zoom: Float = 13.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            initLocationServices()
        } else {
            print("Location services disabled!")
        }
    }
    
    private func initLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: nil)
        self.mapView!.myLocationEnabled = true
        self.mapView!.settings.myLocationButton = true
        self.view = mapView
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location:CLLocation = locations[locations.count-1] as CLLocation
        let newlongitude = location.coordinate.longitude
        let newlatitude = location.coordinate.latitude
        
        if newlongitude == longitude && newlatitude == latitude {
            return
        }
        // else, update position on map
        
        latitude = newlatitude
        longitude = newlongitude
        print("Latitude: \(latitude). Longitude: \(longitude)")
        
        // First time we update location, center camera on user's current location
        if !initial_update {
            let newPosition = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: initial_zoom)
            self.mapView?.camera = newPosition
            initial_update = true
        }
        
        // Init marker if it hasn't been init'ed already
        if self.marker == nil {
            self.marker = GMSMarker()
            self.marker!.map = mapView
        }
        
        // update marker position
        self.marker!.position = CLLocationCoordinate2DMake(latitude, longitude)
        
        // add to coord list
        coord_list.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        // add polyline
        // NOTE: This adds a whole new polyline to the map each time instead of updating just one at a time
        let path = GMSMutablePath()
        for coord in coord_list {
            path.addCoordinate(coord)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        polyline.map = self.mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


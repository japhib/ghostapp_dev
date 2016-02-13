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
    
    let start = NSDate()
    
    var coord_list: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var past_coord_list: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    let initial_zoom: Float = 13.0
    
    var curr_trip = Trip()
    var past_trip: Trip?
    var timer : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            initLocationServices()
        } else {
            print("Location services disabled!")
        }
        
        self.loadTrip()
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
    

    var pointIndex = 0
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // start timer for tracking the amount of time elapsed from start to current location
        let location:CLLocation = locations[locations.count-1] as CLLocation
        let newlongitude = location.coordinate.longitude
        let newlatitude = location.coordinate.latitude
   
        
////////////////////// START TESTING PAST PATH   /////////////////////////
        if past_trip != nil {
            let past_trip_points = past_trip!.getPoints()
            let currentTime = NSDate();
            let timeInterval: Double = currentTime.timeIntervalSinceDate(start);
            //// PAST PATH
            // add to coord list
            while(past_trip_points[pointIndex].time<timeInterval && pointIndex < past_trip_points.count-1){
                
                past_coord_list.append(CLLocationCoordinate2D(latitude: past_trip_points[pointIndex].latitude, longitude: past_trip_points[pointIndex].longitude))
            
                ++pointIndex
            }
            // add polyline
            // NOTE: This adds a whole new polyline to the map each time instead of updating just one at a  time
            let past_path = GMSMutablePath()
            for coord in past_coord_list {
                past_path.addCoordinate(coord)
            }
            let past_polyline = GMSPolyline(path: past_path)
            past_polyline.strokeWidth = 5.0
            past_polyline.strokeColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            past_polyline.map = self.mapView
            print("Finished drawing next point of past path")
        }
////////////////////// END TESTING PAST PATH   /////////////////////////
        
        if newlongitude == longitude && newlatitude == latitude {
            return
        }
        // else, update position on map
        
        latitude = newlatitude
        longitude = newlongitude
       // print("\(latitude) \n \(longitude)")
        
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
        
        if path == nil {
            path = GMSMutablePath()
        }
        
        addCoordinate(latitude, longitude: longitude)
        updatePolyline()
    }
    
    func addCoordinate(latitude: Double, longitude: Double) {
        path!.addCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        let curr_time = timer.elapsed_seconds()
        // add to trip object
        self.curr_trip.addPoint(Point(time: curr_time, latitude: latitude, longitude: longitude))
        // save
        saveTrip()
    }
    
    func saveTrip() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.curr_trip, toFile: FileSaveStaticData.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        else {
            print("Successful save!")
        }
    }
    
    func updatePolyline() {
        if polyline != nil {
            polyline!.map = nil
        }
        polyline = GMSPolyline(path: path)
        polyline!.strokeWidth = 5.0
        polyline!.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        polyline!.map = self.mapView
    }
    
    func loadTrip() {
        self.past_trip = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? Trip
        
        if self.past_trip == nil {
            print("No Trip found to load.")
        } else {
            print("Loaded a trip!")
            print(self.past_trip!.toString())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




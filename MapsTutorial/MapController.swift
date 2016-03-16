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

class MapController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var subMapView: GMSMapView!
    
    var selectedTrip:Int?
    var locationManager: CLLocationManager!
    var mapView: GMSMapView?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var marker: GMSMarker?
    var initial_update = false
    
    var path: GMSMutablePath?
    var polyline: GMSPolyline?
    var past_polyline: GMSPolyline?
    
    let start = NSDate()
    
    var coord_list: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var past_coord_list: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    let initial_zoom: Float = 13.0
    
    var curr_trip = Trip()
    var past_trip: Trip?
    var timer : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map controller Selected Trip: \(selectedTrip!)")
        if (CLLocationManager.locationServicesEnabled()) {
            initLocationServices()
        } else {
            print("Location services disabled!")
        }
        
        self.loadTrip()
        self.timer.start()
    }
    
    private func initLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let camera = GMSCameraPosition.cameraWithLatitude(37.33766286,
            longitude: -122.03305549, zoom: 12)
        
        self.subMapView.camera = camera
        self.subMapView!.myLocationEnabled = true
        self.subMapView!.settings.myLocationButton = true
//        self.view = mapView
    }
    
    var pointIndex = 0
    
    /** Method called each time we get a new GPS location update
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // start timer for tracking the amount of time elapsed from start to current location
        let location:CLLocation = locations[locations.count-1] as CLLocation
        let newlongitude = location.coordinate.longitude
        let newlatitude = location.coordinate.latitude
        
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
            self.subMapView?.camera = newPosition
            initial_update = true
        }
        
        // Init marker if it hasn't been init'ed already
        if self.marker == nil {
            self.marker = GMSMarker()
            self.marker!.map = subMapView
        }
        
        // update marker position
        self.marker!.position = CLLocationCoordinate2DMake(latitude, longitude)
        
        if path == nil {
            path = GMSMutablePath()
        }
        
        addCoordinate(latitude, longitude: longitude)
        updateCurrentPolyline()
        updatePastPolyline()
    }
    
    func addCoordinate(latitude: Double, longitude: Double) {
        path!.addCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        let curr_time = timer.elapsed_seconds()
        // add to trip object
        self.curr_trip.addPoint(Point(time: curr_time, latitude: latitude, longitude: longitude))
        // save
//      saveTrip()
    }
    
    func saveTrip() {
        
        var trips = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? [Trip]
        
        if(trips == nil){
            trips = [Trip]()
        }
        
        trips!.append(self.curr_trip)
       
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( trips!, toFile: FileSaveStaticData.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
        else {
            print("Successful save!")
        }
    }
    
    func updateCurrentPolyline() {
        if polyline != nil {
            polyline!.map = nil
        }
        polyline = GMSPolyline(path: path)
        polyline!.strokeWidth = 5.0
        polyline!.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        polyline!.map = self.subMapView
    }
    
    func updatePastPolyline() {
        if past_trip == nil {
            return
        }
        let curr_time = timer.elapsed_seconds()
        let past_path = past_trip!.getPathObj(curr_time)
        
        print("Number of points before time \(curr_time) in past path: \(past_path.count())")
        if past_polyline != nil {
            past_polyline!.map = nil
        }
//        drawFullPastPath()
        past_polyline = GMSPolyline(path: past_path)
        past_polyline!.strokeWidth = 5.0
        past_polyline!.strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        past_polyline!.map = self.subMapView
    }
    
    func drawFullPastPath(){
        let past_path = past_trip!.getPathObj()
        
        if past_polyline != nil {
            past_polyline!.map = nil
        }
        past_polyline = GMSPolyline(path: past_path)
        past_polyline!.strokeWidth = 5.0
        past_polyline!.strokeColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.2)
        past_polyline!.map = self.subMapView

        
    }
    
    func loadTrip() {
        var trips = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? [Trip]
        //        self.past_trip = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? Trip
        
        if trips == nil {
            print("No Trips found to load.")
        } else {
            print("Loaded a trip! at index: \(selectedTrip!)")
            if(selectedTrip == nil){
                selectedTrip = 0
            }
            self.past_trip = trips![selectedTrip!]
            print(self.past_trip!.toString())
        }
    }
    
    @IBAction func stopButtonPressed() {
        saveTrip()
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




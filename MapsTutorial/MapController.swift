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
    
    @IBOutlet weak var statusLbl: UILabel!
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
        self.statusLbl.backgroundColor = UIColor.lightGrayColor()
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
        // update camera
        
        let current_past_path_coordinate = updatePastPolyline()
        print("current past path coord lat: \(current_past_path_coordinate.latitude) long: \(current_past_path_coordinate.longitude)")
        let current_coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        print("current coord lat: \(current_coordinate.latitude) long: \(current_coordinate.longitude)")
        
        
//        let bounds = GMSCoordinateBounds.init(coordinate: current_coordinate, coordinate: current_coordinate)
        
//        print("Northeast bound: \(bounds.northEast)")
//        print("Southwest bound: \(bounds.southWest)")
        
//        let update = GMSCameraUpdate.fitBounds(bounds, withPadding: 50.0)
//        self.subMapView.moveCamera(update)
//        print(camera)
//        if(camera != nil){
//            print("workin on bounds dog!")
////            self.subMapView.camera = camera!
//        }
        
        
        if let past_trip = self.past_trip {
            let tripstats = TripStats(ghost: self.past_trip!, current: self.curr_trip)
//            print(tripstats.toString())
            statusLbl.text = tripstats.getStatusStr()
        }
        else {
            print("No ghost, dry run")
            statusLbl.hidden = true;
        }
    }
    
    func addCoordinate(latitude: Double, longitude: Double) {
        path!.addCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        let curr_time = timer.elapsed_seconds()
        // add to trip object
        self.curr_trip.addPoint(Point(time: curr_time, latitude: latitude, longitude: longitude))
        // save
//      saveTrip()
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
    
    func updatePastPolyline()->CLLocationCoordinate2D{

        if past_trip == nil {
            return curr_trip.getPathObj().coordinateAtIndex(curr_trip.getPathObj().count())
        }
        
        
        let curr_time = timer.elapsed_seconds()
        let past_path = past_trip!.getPathObj(curr_time)
        

        
        print("Number of points before time \(curr_time) in past path: \(past_path.count()) of \(past_trip!.points.count)")
        if past_polyline != nil {
            past_polyline!.map = nil
        }
        drawFullPastPath()
        past_polyline = GMSPolyline(path: past_path)
        past_polyline!.strokeWidth = 5.0
        past_polyline!.strokeColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        past_polyline!.map = self.subMapView
        print("PAST PATH COUNT: \(past_path.count())")
        return past_path.coordinateAtIndex(past_path.count())
    }
////////////////
    func drawFullPastPath(){
        let past_path = past_trip!.getPathObj()
        
        if past_polyline != nil {
            past_polyline!.map = nil
        }
        past_polyline = GMSPolyline(path: past_path)
        past_polyline!.strokeWidth = 5.0
        past_polyline!.strokeColor = UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 0.5)
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
    func saveTrip() {
        
//        var trips = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? [Trip]
//        
//        if(trips == nil){
//            trips = [Trip]()
//        }
//        
//        trips!.append(self.curr_trip)
//        
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( trips!, toFile: FileSaveStaticData.ArchiveURL.path!)
//        if !isSuccessfulSave {
//            print("Failed to save meals...")
//        }
//        else {
//            print("Successful save!")
//        }
    }
    @IBAction func stopButtonPressed() {
        saveTrip()
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var trips = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? [Trip]
        
        if(trips == nil){
            trips = [Trip]()
        }
        
        trips!.append(self.curr_trip)
       
        print(trips!.last)
        
        if(segue.identifier == "toNameTripController") {
            var nameTripController = (segue.destinationViewController as! NameTripController)
            nameTripController.self.trips = trips!
            nameTripController.self.test = "hello world"
        }
    }
    
    

}




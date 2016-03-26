//
//  Trip.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit
import GoogleMaps

class Trip : NSObject, NSCoding {
    
    var points : [Point]
    var timestamp : NSDate
    var name: String
    
    struct PropertyKey {
        static let pointsKey = "points"
        static let timestampKey = "timestamp"
        static let nameKey = "name"
    }
    
    override init() {
        points = [Point]()
        timestamp = NSDate() // gives timestamp of right now
        name = "No Name"
        super.init()
    }
    
    convenience init(points: [Point], timestamp: NSDate, name: String) {
        self.init()

        self.points = points
        self.timestamp = timestamp
        self.name = name
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let points = aDecoder.decodeObjectForKey(PropertyKey.pointsKey) as! [Point]
        let timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! NSDate
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.init(points: points, timestamp: timestamp, name: name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(points, forKey: PropertyKey.pointsKey)
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
    }

    func addPoint(point: Point){
        print("added a point")
        points.append(point)
    }
    
    func getPoints()->[Point]{
        return points
    }
    
    func updateTimestampNow() {
        timestamp = NSDate()
    }
    
    func getName()->String{
        return name
    }
    
    func setTripName(inputName:String){
        print("In Set name input name: "+inputName)
        name = inputName
    }
    
    func getTimestamp() -> NSDate {
        return timestamp
    }
    
    func getFirstPoint() -> Point? {
        return points.first
    }
    
    func getLastPoint() -> Point? {
        return points.last
    }
    
    func getLength() -> Double {
        return points.last!.time;
    }
    
    func toString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        var ret = "Trip with start time: " + formatter.stringFromDate(self.timestamp) + "\n"
        
        for point in points {
            ret += "Time: \(point.time) -- Latitude: \(point.latitude) -- Longitude: \(point.longitude)\n"
        }
        
        return ret
    }
    
    func getPathObj() -> GMSMutablePath {
        let ret = GMSMutablePath()
        for point in points {
            ret.addCoordinate(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        }
        return ret
    }
    
    func getPathObj(time_delta : Double) -> GMSMutablePath {
        let ret = GMSMutablePath()
        for point in points {
            if point.time > time_delta {
                break
            }
            ret.addCoordinate(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        }
        return ret
    }
    
    func getDistUntilTime(end_time: Double) -> Double {
        var so_far = 0.0
        var previous : Point? = nil
        for point in points {
            if previous == nil {
                previous = point
                continue
            }
            if point.time > end_time {
                break
            }
            let time_delta = point.time - previous!.time
            so_far += time_delta
        }
        return so_far
    }
    
    func getTotalDist() -> Double {
        var so_far = 0.0
        var previous : Point? = nil
        for point in points {
            if previous == nil {
                previous = point
                continue
            }
            let time_delta = point.time - previous!.time
            so_far += time_delta
        }
        return so_far
    }
    
    func getTotalTime() -> Double {
        let last = getLastPoint()
        if last == nil {
            return 0.0
        }
        return last!.time
    }
}

//
//  Trip.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Trip : NSObject, NSCoding {
    
    var points : [Point]
    var timestamp : NSDate
    
    struct PropertyKey {
        static let pointsKey = "points"
        static let timestampKey = "timestamp"
    }
    
    override init() {
        points = [Point]()
        timestamp = NSDate() // gives timestamp of right now
        
        super.init()
    }
    
    init(points: [Point], timestamp: NSDate) {
        self.points = points
        self.timestamp = timestamp
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let points = aDecoder.decodeObjectForKey(PropertyKey.pointsKey) as! [Point]
        let timestamp = aDecoder.decodeObjectForKey(PropertyKey.timestampKey) as! NSDate
        
        self.init(points: points, timestamp: timestamp)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(points, forKey: PropertyKey.pointsKey)
        aCoder.encodeObject(timestamp, forKey: PropertyKey.timestampKey)
    }

    func addPoint(point: Point){
        points.append(point)
    }
    
    func getPoints()->[Point]{
        return points
    }
    
    func updateTimestampNow() {
        timestamp = NSDate()
    }
    
    func getTimestamp() -> NSDate {
        return timestamp
    }
    
    func getFirstPoint() {
        
    }
    
    func getLastPoint() {
        
    }
    
    func getLength() -> Double {
        return points.last!.time;
    }
}

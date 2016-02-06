//
//  Trip.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Trip {//: NSObject, NSCoding {
    
    var points : [Point]
    var timestamp : NSDate
    
    struct PropertyKey {
        static let pointsKey = "points"
        static let timestampKey = "timestamp"
    }
    
    init() {
        points = [Point]()
        timestamp = NSDate() // gives timestamp of right now
    }
    
    init(points: [Point], timestamp: NSDate) {
        self.points = points
        self.timestamp = timestamp
    }
    
//    required convenience init?(coder aDecoder: NSCoder) {
////        let points = aDecoder.decodeObjectForKey(PropertyKey.
//    }
    
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

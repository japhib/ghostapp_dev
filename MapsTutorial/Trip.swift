//
//  Trip.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Trip {
    var points : [Point] = [Point]()
    var timestamp : NSDate = NSDate() // gives timestamp of right now
    
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

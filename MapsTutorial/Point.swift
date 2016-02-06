//
//  Point.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Point : NSObject, NSCoding {
    
    var latitude: Double
    var longitude: Double
    var time: Double // Elapsed seconds since first point
    
    struct PropertyKey {
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let timeKey = "time"
    }
    
    init(time: Double, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let lat = aDecoder.decodeDoubleForKey(PropertyKey.latitudeKey) as Double
        let long = aDecoder.decodeDoubleForKey(PropertyKey.longitudeKey) as Double
        let time = aDecoder.decodeDoubleForKey(PropertyKey.timeKey) as Double
        
        self.init(time: time, latitude: lat, longitude: long)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(latitude, forKey: PropertyKey.latitudeKey)
        aCoder.encodeDouble(longitude, forKey: PropertyKey.longitudeKey)
        aCoder.encodeDouble(time, forKey: PropertyKey.timeKey)
    }
    
}

//
//  Path.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Path : NSObject, NSCoding {
    var name : String
    var trips : [Trip]
//    var fastestTrip : Trip
    
    struct PropertyKey {
        static let nameKey = "name"
        static let tripsKey = "trips"
    }
    
    init(trip: Trip, name: String) {
        self.trips = [Trip]()
        self.trips.append(trip)
//        self.fastestTrip = trip
        self.name = name
        
        super.init()
    }
    
    convenience init(trips: [Trip], name: String) {
        self.init(trip: trips[0], name: name)
        
        for t in trips {
            self.addTrip(t)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let trips = aDecoder.decodeObjectForKey(PropertyKey.tripsKey) as! [Trip]
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        self.init(trips: trips, name: name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.trips, forKey: PropertyKey.tripsKey)
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
    }
    
    func addTrip(trip: Trip) {
        self.trips.append(trip)
        
        // if that trip is faster than the current fastest trip, make it the fastest
    }
    
    func getFastestTime() {
        
    }
    
    func getAverageTime() {
        
    }
    
    func getLength() {
        
    }
}

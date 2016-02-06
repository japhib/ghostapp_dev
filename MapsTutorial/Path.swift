//
//  Path.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Path {
    var name : String
    var trips : [Trip]
    var fastestTrip : Trip
    
    init(trip: Trip, name: String) {
        self.trips = [Trip]()
        self.trips.append(trip)
        self.fastestTrip = trip
        self.name = name
    }
    
    func getFastestTime() {
        
    }
    
    func getAverageTime() {
        
    }
    
    func getLength() {
        
    }
}

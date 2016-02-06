//
//  Point.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Point {
    var latitude: Double
    var longitude: Double
    var time: Double // Elapsed seconds since first point
    
    init(time: Double, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
    }
}

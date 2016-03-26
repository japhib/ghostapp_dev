//
//  TripStats.swift
//  
//
//  Created by JanPaul on 3/19/16.
//
//

import UIKit

class TripStats {
    
    var ghost: Trip
    var current: Trip
    
    
    // Calculated stat variables
    var total_dist: Double
    
    var curr_dist: Double
    var ghost_dist: Double
    
    var curr_percent_dist: Double
    var ghost_percent_dist: Double
    
    var curr_latest_time: Double
    
    init(ghost: Trip, current: Trip)
    {
        self.ghost = ghost
        self.current = current
        
        calculate()
    }
    
    func calculate() {
        total_dist = ghost.getTotalDist()
        curr_dist = current.getTotalDist()
        curr_latest_time = current.getTotalTime()
        ghost_dist = ghost.getDistUntilTime(curr_latest_time)
        
        curr_percent_dist = curr_dist / total_dist * 100
        ghost_percent_dist = ghost_dist / total_dist * 100
    }
    
    func toString() -> String {
        let ret = "Stats for the trip:"
        + "\ntotal distance: " + total_dist
        + "\ncurrent distance: " + current_distance
    }
    
    
}

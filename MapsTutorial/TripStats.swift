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
        
        total_dist = ghost.getTotalDist()
        curr_dist = current.getTotalDist()
        curr_latest_time = current.getTotalTime()
        ghost_dist = ghost.getDistUntilTime(curr_latest_time)
        
        curr_percent_dist = curr_dist / total_dist * 100
        ghost_percent_dist = ghost_dist / total_dist * 100
    }
    
    func toString() -> String {
        var ret = "Stats for the trip:"
        ret += "\ntotal distance: \(total_dist)"
        ret += "\ncurrent distance: \(curr_dist)"
        ret += "\nghost distance: \(ghost_dist)"
        
        ret += "\n\ncurrent percent distance: \(curr_percent_dist)"
        ret += "\nghost percent distance: \(ghost_percent_dist)"
        
        ret += "\n\n" + getStatusStr()
        
        return ret
    }
    
    func getStatusStr() -> String {
        var dist_diff = ghost_dist - curr_dist
        var direction = ""
        if dist_diff > 0 {
            direction = "behind"
        }
        else {
            dist_diff = -dist_diff
            direction = "ahead"
        }
        
        if dist_diff < 0.25 {
            let dist_m = dist_diff * 1609.34
            return "\(dist_m) meters " + direction
        } else {
            // round distance to nearest .25
            let denominator = 4.0
            var dist_str = String(round(dist_diff*denominator )/denominator );
            return "\(dist_str) miles " + direction
        }
    }
    
    
}

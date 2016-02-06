//
//  Connection.swift
//  MapsTutorial
//
//  Created by JanPaul on 2/6/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit

class Connection: NSObject, NSCoding {
    
    var name : String
    var paths : [Path]
    
    struct PropertyKey {
        static let nameKey = "name"
        static let pathsKey = "paths"
    }
    
    init(name: String) {
        self.name = name
        self.paths = [Path]()
        
        super.init()
    }
    
    convenience init(name: String, paths: [Path]) {
        self.init(name: name)
        for p in paths {
            self.addPath(p)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let paths = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! [Path]
        
        self.init(name: name, paths: paths)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(paths, forKey: PropertyKey.pathsKey)
    }
    
    func addPath(path: Path) {
        paths.append(path)
    }
    
    func getFastestTime() {
        
    }
    
    func getAverageTime() {
        
    }
}

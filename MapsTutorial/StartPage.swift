//
//  StartPage.swift
//  MapsTutorial
//
//  Created by LosNinos on 3/4/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class StartPage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var trips:[Trip]?
    var selectedTrip: Int?
    
    
    @IBOutlet weak var tripsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start page")
        self.trips = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? [Trip]
        if(trips != nil){
            print(trips!.count)
        }
        tripsTable.dataSource = self
        tripsTable.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(trips == nil){
            return 0
        }
        return trips!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        label.text = "cell number: \(indexPath.row)!"
        cell.addSubview(label)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTrip = indexPath.row
        print("You selected cell number: \(selectedTrip!)!")
        
//        self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toMapController") {
            if(selectedTrip == nil){
                selectedTrip = 0
            }
            
            var yourNextViewController = (segue.destinationViewController as! MapController)
            yourNextViewController.selectedTrip = selectedTrip
        }
    }
    
}

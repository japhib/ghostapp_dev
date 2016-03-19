//
//  NameTripController.swift
//  MapsTutorial
//
//  Created by LosNinos on 3/19/16.
//  Copyright © 2016 JanPaul. All rights reserved.
//
import UIKit

class NameTripController: UIViewController{
    var trips = [Trip]()
    var test = "nothing"
    @IBOutlet weak var TripNameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this is name Trip Controller")
        print(self.trips.last)
        print(self.test)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.trips.last?.setTripName(self.TripNameInput.text!)
        print("set name!!!: "+(self.trips.last?.getName())!)
                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( self.trips, toFile: FileSaveStaticData.ArchiveURL.path!)
                if !isSuccessfulSave {
                    print("Failed to save trips...")
                }
                else {
                    print("Successful save!")
                }
        
        if(segue.identifier == "toStartPageController") {
            var startPageController = (segue.destinationViewController as! StartPage)
            startPageController.self.test = self.TripNameInput.text!
        }
    }
    

    
}
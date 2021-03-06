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
    var test = "nothing"
    
    @IBOutlet weak var tripsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start page "+test)
        self.trips = NSKeyedUnarchiver.unarchiveObjectWithFile(FileSaveStaticData.ArchiveURL.path!) as? [Trip]
        if(trips != nil){
            print(trips!.count)
        }

        
//        var label = UILabel(frame: CGRectMake(0, 0, 200, 21));
//        label.textAlignment = NSTextAlignment.Center
//        label.text = "Trips"
        
        let headerView = UIView();
        
//        headerView.addSubview(label)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
//        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = 20
//        frame.
        headerView.frame = frame
        headerView.backgroundColor =  UIColor.orangeColor()
        tripsTable.tableHeaderView = headerView
        
//        tripsTable.tableHeaderView.
        
        tripsTable.dataSource = self
        tripsTable.delegate = self
        tripsTable.separatorColor = UIColor.whiteColor()
        tripsTable.tableFooterView = UIView()

    }
    
    // initializes the data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(trips == nil){
            return 0
        }
        return trips!.count
    }
    
    // This populates the table and is set when we do tripsTable.dataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        let cell = UITableViewCell()
//        tableView.separatorColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.lightGrayColor()
//        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
//        label.text = "\(trips![indexPath.row].getName())"

        cell.textLabel!.text = "\(trips![indexPath.row].getName())"
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    // This is the delegate method and gets called when you click on a cell.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedTrip = indexPath.row
        print("You selected cell number: \(selectedTrip!)")
    }
    // This sends the index of the selected trip in through the segue to the next view. 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toMapController") {
            if(selectedTrip == nil){
                selectedTrip = 0
            }
            var yourNextViewController = (segue.destinationViewController as! MapController)
            yourNextViewController.selectedTrip = selectedTrip
        }
    }
    
    
   // set up for delete and edit tabs on swipe
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
// I think this is for if we want to change the styling of the swipe
    func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
    }
// handles the actions of buttons in the swipe
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {action in
            //handle delete
            print("Delete \(self.trips![indexPath.row].getName())")
            print("row index \(indexPath.row)")
            print(self.trips!.count)
            
            //remove the trip from the model
            self.trips?.removeAtIndex(indexPath.row)
        
            //remove the trip from the view
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print(self.trips!.count)
            
            //save edited trips array to file
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( self.trips!, toFile: FileSaveStaticData.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save trips...")
            }
            else {
                print("Successful save!")
            }
        }
        
        
        var inputTextField: UITextField?
        let passwordPrompt = UIAlertController(title: "Rename Trip", message: " ", preferredStyle: UIAlertControllerStyle.Alert)
        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)
            
            //set text in input field to text of the trip in the trips array
            self.trips![indexPath.row].setTripName(inputTextField!.text!)
            
            //save edited trips array to file
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject( self.trips!, toFile: FileSaveStaticData.ArchiveURL.path!)
            if !isSuccessfulSave {
                print("Failed to save trips...")
            }
            else {
                print("Successful save!")
            }
            
            // reload the cell in the view
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Right)
            

            
        }))
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "New Trip Name"
            inputTextField = textField
        })
        
       
        
        var editAction = UITableViewRowAction(style: .Normal, title: "Edit") {action in
           print("Edit \(self.trips![indexPath.row].getName())")
             self.presentViewController(passwordPrompt, animated: true, completion: nil)
        }
        
        return [deleteAction, editAction]
    }
    
}

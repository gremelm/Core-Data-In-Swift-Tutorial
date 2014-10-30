//
//  ViewController.swift
//  MyLog
//
//  Created by Jameson Quave on 10/30/14.
//  Copyright (c) 2014 Jameson Quave. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Create an empty array of LogItem's
    var logItems = [LogItem]()

    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    // Create the table view as soon as this class loads
    var logTableView = UITableView(frame: CGRectZero, style: .Plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LogItem.createInManagedObjectContext(self.managedObjectContext!, title: "1st Item", text: "This is my first log item")
        LogItem.createInManagedObjectContext(self.managedObjectContext!, title: "2nd Item", text: "This is my second log item")
        LogItem.createInManagedObjectContext(self.managedObjectContext!, title: "3rd Item", text: "This is my third log item")
        LogItem.createInManagedObjectContext(self.managedObjectContext!, title: "4th Item", text: "This is my fourth log item")
        LogItem.createInManagedObjectContext(self.managedObjectContext!, title: "5th Item", text: "This is my fifth log item")
        LogItem.createInManagedObjectContext(self.managedObjectContext!, title: "6th Item", text: "This is my sixth log item")
        
        // Now that the view loaded, we have a frame for the view, which will be (0,0,screen width, screen height)
        // This is a good size for the table view as well, so let's use that
        // The only adjust we'll make is to move it down by 20 pixels, and reduce the size by 20 pixels
        // in order to account for the status bar
        
        // Store the full frame in a temporary variable
        var viewFrame = self.view.frame
        
        // Adjust it down by 20 points
        viewFrame.origin.y += 20
        
        // Reduce the total height by 20 points
        viewFrame.size.height -= 20
        
        // Set the logTableview's frame to equal our temporary variable with the full size of the view
        // adjusted to account for the status bar height
        logTableView.frame = viewFrame
        
        // Add the table view to this view controller's view
        self.view.addSubview(logTableView)
        
        // Here, we tell the table view that we intend to use a cell we're going to call "LogCell"
        // This will be associated with the standard UITableViewCell class for now
        logTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "LogCell")
        
        // This tells the table view that it should get it's data from this class, ViewController
        logTableView.dataSource = self
        logTableView.delegate = self
        
        fetchLog()
    }
    
    func fetchLog() {
        let fetchRequest = NSFetchRequest(entityName: "LogItem")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [LogItem] {
            logItems = fetchResults
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // How many rows are there in this section?
        // There's only 1 section, and it has a number of rows
        // equal to the number of logItems, so return the count
        return logItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as UITableViewCell
        
        // Get the LogItem for this index
        let logItem = logItems[indexPath.row]
        
        // Set the title of the cell to be the title of the logItem
        cell.textLabel.text = logItem.title
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let logItem = logItems[indexPath.row]
        let alert = UIAlertView(title: logItem.title, message: logItem.itemText, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
        alert.show()
    }


}


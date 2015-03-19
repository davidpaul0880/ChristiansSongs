//
//  FolderSelectionTableViewController.swift
//  christiansongs
//
//  Created by jijo on 3/13/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import UIKit
import CoreData

protocol FolderSelection {
    
    func folderSelected(selectedFolder : Folder)
}

class FolderSelectionTableViewController: UITableViewController {
    
    var arrayFolders : [Folder]!
    var delegate : FolderSelection!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        arrayFolders = BMDao().getAllFolders()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.editing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
        
            return arrayFolders.count
        }else{
            return 1
        }
        
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.section == 1 {
            return true
        } else{
            return false
        }
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 1 {
            
            return UITableViewCellEditingStyle.Insert
        }
        
        return UITableViewCellEditingStyle.None
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            
            var actionSheet =  UIAlertController(title: "Christian Songs", message: "Enter Folder Name:", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            actionSheet.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Folder Name"
                
            }
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheet.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
                //Code for launching the camera goes here
                
                
                let loginTextField = actionSheet.textFields![0] as UITextField
                println("\(loginTextField.text)")
                
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                let managedObjectContext = appDelegate.managedObjectContextUserData!
                var fldr = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext: managedObjectContext) as? Folder
                fldr?.created_date = NSDate()
                fldr?.folder_label = loginTextField.text
                fldr?.orderfield = NSDate.timeIntervalSinceReferenceDate()
                
                
                self.tableView.beginUpdates()
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.arrayFolders.count, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.arrayFolders.append(fldr!)
                self.tableView.endUpdates()
                
            }
            actionSheet.addAction(takePictureAction)
            
            
            
            
            
            //We need to provide a popover sourceView when using it on iPad
            //actionSheet.popoverPresentationController?.so = sender
            
            //Present the AlertController
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }    
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FolderCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = arrayFolders[indexPath.row].folder_label
            cell.imageView?.image = UIImage(named: "folder.png")
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("NewFolder", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "Add Folder"
            return cell
        }
        
        // Configure the cell...

        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        delegate.folderSelected(arrayFolders[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true);
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  BMTableViewController.swift
//  christiansongs
//
//  Created by jijo on 3/10/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import UIKit
import CoreData

class BMTableViewController: UITableViewController {
    
    var arrayFolder = [Folder]()
    var arrayBookmarks = [BookMarks]()
    var parentFolder : Folder?
    
    //var bookMarkArry = []
    
    func getAllBookMarks() {
        
        if parentFolder == nil {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContextUserData!
            
            let fetchRequest = NSFetchRequest()
            // Edit the entity name as appropriate.
            let entity = NSEntityDescription.entityForName("Folder", inManagedObjectContext: managedObjectContext)
            fetchRequest.entity = entity
            
            //caseInsensitiveCompare localizedCaseInsensitiveCompare localizedStandardCompare
            // Edit the sort key as appropriate.
            let sortDescriptor = NSSortDescriptor(key: "orderfield", ascending: true)
            
            //let sortDescriptors = [sortDescriptor]
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            var error: NSError?
            
            var objects: [AnyObject]?
            do {
                objects = try managedObjectContext.executeFetchRequest(fetchRequest)
            } catch let error1 as NSError {
                error = error1
                objects = nil
            }
            
            if let results = objects {
                
                
                for value in results {
                    
                    let foldert : Folder = value as! Folder
                    if foldert.folder_label == "Bookmarks" {
                        let sett : NSSet = foldert.bookmarks
                        if sett.count > 0 {
                            
                            let allchilds : NSArray = sett.allObjects
                            let sortDescriptorchild = NSSortDescriptor(key: "orderfield", ascending: true)
                            arrayBookmarks = allchilds.sortedArrayUsingDescriptors([sortDescriptorchild]) as! [BookMarks]
                            
                        }
                    }else{
                        arrayFolder.append(foldert)
                    }
                    //("\(foldert.folder_label)")
                    
                    
                }
                
            }
            
            //bookMarkArry = [arrayBookmarks, arrayFolder]
        }else{
            
            
            let allchilds : NSArray = parentFolder!.bookmarks.allObjects
            let sortDescriptorchild = NSSortDescriptor(key: "orderfield", ascending: true)
            arrayBookmarks = allchilds.sortedArrayUsingDescriptors([sortDescriptorchild]) as! [BookMarks]
            
            //bookMarkArry = [arrayBookmarks]
        }
        

        
    }
    func cancelClicked() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContextUserData!
        managedObjectContext.rollback()
        //managedObjectContext.reset()
        
        self.setEditing(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.reloadData()
        
    }
    
    override func setEditing(editing: Bool, animated: Bool){
        
        super.setEditing(editing, animated: animated);
        
        if editing == true {
            
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancelClicked"))
        }else{
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDelegate.managedObjectContextUserData!
            
            var error: NSError?
            do {
                try managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
            }
            
            if let err = error {
                print("\(error)")
            } else {
                //("success")
            }
            
            self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        }
        
        
        self.navigationItem.setHidesBackButton(editing, animated: animated)
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        
        self.getAllBookMarks()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        if parentFolder != nil {
            
            self.navigationItem.title = parentFolder?.folder_label
            
            if !arrayBookmarks.isEmpty {
                self.navigationItem.rightBarButtonItem = self.editButtonItem()
            }
            
        }else{
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if tableView.editing == true && parentFolder == nil { //+20150528
            
            return 1 + 2
        }
        if parentFolder == nil  {
            return 2
        }else{
            return 1
        }
        ///return bookMarkArry.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return arrayBookmarks.count
        }else if section == 1 {
            return arrayFolder.count
        }else{
            return 1
        }
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.performSegueWithIdentifier("showDetail", sender: self)
        if indexPath.section == 0{
            
            if self.tableView.editing == false {
                
                let controller = self.navigationController?.viewControllers[0] as! MasterViewController
                controller.selectedSongFromBM = BMDao().getSelectedSong(arrayBookmarks[indexPath.row].songs_id)
                
                controller.performSegueWithIdentifier("showDetail", sender: self)
            }else{
                
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                
                let controler : BMAddTableViewController = storyboard.instantiateViewControllerWithIdentifier("addeditcontroller") as! BMAddTableViewController
                
                controler.editingBookMark = arrayBookmarks[indexPath.row]
                controler.folder = arrayBookmarks[indexPath.row].folder as! Folder
                //let navigationController = UINavigationController(rootViewController: vc)
                
                //self.presentViewController(navigationController, animated: true, completion: nil)
               
                self.navigationController?.pushViewController(controler, animated: true)
            }
            
            

        }
        
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var ident = "BookmarkCell"
        if indexPath.section == 1 {
            ident = "FolderCell"
        }else if indexPath.section == 2 {
            ident = "NewFolder"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ident, forIndexPath: indexPath) 

        if indexPath.section == 0 {
            
            let bm = arrayBookmarks[indexPath.row]
            cell.textLabel?.text = bm.songtitle
        }else if indexPath.section == 1 {
            
            let fl = arrayFolder[indexPath.row]
            cell.textLabel?.text = fl.folder_label
            cell.imageView?.image = UIImage(named: "folder.png")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell.textLabel?.text = "Add Folder"
            
        }
        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if self.editing == true {
        
            if indexPath.section == 0 {
                
                return UITableViewCellEditingStyle.Delete
                
            }else if indexPath.section == 1 {
        
                return UITableViewCellEditingStyle.Delete
            }
            else {
                return UITableViewCellEditingStyle.Insert
            }
        }
        return UITableViewCellEditingStyle.None
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.tableView.beginUpdates()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            var obj : NSManagedObject?
            if indexPath.section == 0 {
                obj = self.arrayBookmarks.removeAtIndex(indexPath.row)
            }else if indexPath.section == 1 {
                
                obj = self.arrayFolder.removeAtIndex(indexPath.row)
            }
            if obj != nil {
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDelegate.managedObjectContextUserData!
                managedObjectContext.deleteObject(obj!)
            }
            
            
            
            self.tableView.endUpdates()
            
        } else if editingStyle == .Insert {
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
                
                
                let loginTextField = actionSheet.textFields![0] 
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDelegate.managedObjectContextUserData!
                var fldr = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext: managedObjectContext) as? Folder
                fldr?.lastaccessed = NSDate()
                fldr?.created_date = NSDate()
                fldr?.folder_label = loginTextField.text!
                fldr?.orderfield = NSDate.timeIntervalSinceReferenceDate()
                
                
                self.tableView.beginUpdates()
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.arrayFolder.count, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.arrayFolder.append(fldr!)
                self.tableView.endUpdates()

            }
            actionSheet.addAction(takePictureAction)
            
            
            
            
            
            //We need to provide a popover sourceView when using it on iPad
            //actionSheet.popoverPresentationController?.so = sender
            
            //Present the AlertController
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        if fromIndexPath.section == 0 {
            
            if toIndexPath.section == 0 {
                
                let diff = fromIndexPath.row - toIndexPath.row
                if diff == 1 {
                    
                        let bm1 = arrayBookmarks[fromIndexPath.row]
                        let bm2 = arrayBookmarks[toIndexPath.row]
                        
                        let dateTemp = bm1.orderfield
                        bm1.orderfield = bm2.orderfield
                        bm2.orderfield = dateTemp
                        
                        arrayBookmarks[toIndexPath.row] = bm1
                        arrayBookmarks[fromIndexPath.row] = bm2
                    
                }else{
                    
                    if fromIndexPath.row > toIndexPath.row {
                        arrayBookmarks.insert(self.arrayBookmarks[fromIndexPath.row], atIndex: toIndexPath.row)
                        arrayBookmarks.removeAtIndex(fromIndexPath.row+1)
                        
                    }else{
                        arrayBookmarks.insert(self.arrayBookmarks[fromIndexPath.row], atIndex: toIndexPath.row+1)
                        arrayBookmarks.removeAtIndex(fromIndexPath.row)
                        
                    }
                    
                    for var i = 0 ; i < self.arrayBookmarks.count ; i++ {
                        
                        let obj : BookMarks = self.arrayBookmarks[i]
                        obj.orderfield = i
                        
                    }
                    
                }
                
                

            }/*else if toIndexPath.section == 1 { //change default folder to custom folder
                
                
                self.tableView.beginUpdates()
                
                let bmc : BookMarks = self.arrayBookmarks.removeAtIndex(fromIndexPath.row)
                
                //self.arrayFolder.append(Folder())
                
                //self.tableView.endUpdates()
                
                
                
                //self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([toIndexPath], withRowAnimation: .Fade)
                //self.arrayFolder.removeLast()
                bmc.folder = self.arrayFolder[toIndexPath.row - 1]
                self.tableView.endUpdates()
                
                
                self.tableView.reloadData()
                
            }*/
        }else if fromIndexPath.section == 1 {
            
            if toIndexPath.section == 1 {
                
                let diff = fromIndexPath.row - toIndexPath.row
                
                if diff == 1 {
                    
                    let f1 = arrayFolder[fromIndexPath.row]
                    let f2 = arrayFolder[toIndexPath.row]
                    
                    let dateTemp = f1.orderfield
                    f1.orderfield = f2.orderfield
                    f2.orderfield = dateTemp
                    
                    arrayFolder[fromIndexPath.row] = f2
                    arrayFolder[toIndexPath.row] = f1

                }else{
                    
                    if fromIndexPath.row > toIndexPath.row {
                        arrayFolder.insert(self.arrayFolder[fromIndexPath.row], atIndex: toIndexPath.row)
                        arrayBookmarks.removeAtIndex(fromIndexPath.row+1)
                        
                    }else{
                        arrayFolder.insert(self.arrayFolder[fromIndexPath.row], atIndex: toIndexPath.row+1)
                        arrayFolder.removeAtIndex(fromIndexPath.row)
                        
                    }
                    
                    for var i = 0 ; i < self.arrayFolder.count ; i++ {
                        
                        let obj : Folder = self.arrayFolder[i]
                        obj.orderfield = i
                        
                    }
                    
                }
                
                
            }
        }
        
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.section < 2 {
            return true
        }else{
            return false
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        /*if sourceIndexPath.section == 0 && (sourceIndexPath.section != proposedDestinationIndexPath.section) {
            
            if proposedDestinationIndexPath.row == 0 {
                var row = 0;
                if sourceIndexPath.section < proposedDestinationIndexPath.section {
                    row = tableView.numberOfRowsInSection(sourceIndexPath.section) - 1;
                }
                return NSIndexPath(forRow: row, inSection: sourceIndexPath.section)

            }else{
                return proposedDestinationIndexPath;
            }
            
        }else if sourceIndexPath.section == 1 && proposedDestinationIndexPath.section == 0 {
            
            return NSIndexPath(forRow: 0, inSection: sourceIndexPath.section)
        }
        
        return proposedDestinationIndexPath;
        */
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0;
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = tableView.numberOfRowsInSection(sourceIndexPath.section) - 1;
            }
            return NSIndexPath(forRow: row, inSection: sourceIndexPath.section)
        }
        
        return proposedDestinationIndexPath;
    }
    
    
    // MARK: - Segues
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        if identifier == "showChildBookmarks" { // you define it in the storyboard (click on the segue, then Attributes' inspector > Identifier
            
            if self.tableView.editing == true {
                return false
            }
        }
        
        // by default, transition
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        /*if segue.identifier == "showDetail" {
            
           
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                
                let bm = arrayBookmarks[indexPath.row]
                let object :Songs? = BMDao().getSelectedSong(bm.songs_id)
                
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                if(object != nil){
                    
                    controller.songObj = object
                }
                
                //controller.language = bm.language
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else*/
        if segue.identifier == "showChildBookmarks" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let controller = segue.destinationViewController as! BMTableViewController
                
                controller.parentFolder = self.arrayFolder[indexPath.row]
            }
            
            
        }
    }
    

}

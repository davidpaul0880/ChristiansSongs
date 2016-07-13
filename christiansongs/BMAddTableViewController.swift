//
//  BMAddTableViewController.swift
//  christiansongs
//
//  Created by jijo on 3/11/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import UIKit
import CoreData

class BMAddTableViewController: UITableViewController , FolderSelection{
    
    var newBM : Dictionary<String, AnyObject>?
    var folder : Folder!
    var editingBookMark : BookMarks?

    @IBAction func cancelBM(sender: UIBarButtonItem?) {
        
        if editingBookMark != nil {
            self.navigationController?.popViewControllerAnimated(true);
        }else{
        
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    @IBAction func saveBM(sender: UIBarButtonItem) {
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContextUserData!
        let entity1 = NSEntityDescription.entityForName("BookMarks", inManagedObjectContext: managedObjectContext)
        
        let newBMTemp = BookMarks(entity: entity1!, insertIntoManagedObjectContext: managedObjectContext)

               //managedObjectContext.insertObject(newBM!)
        newBMTemp.createddate = NSDate()
        newBMTemp.folder = self.folder!
        newBMTemp.songtitle = newBM!["songtitle"]! as! String
        newBMTemp.song_id = newBM!["song_id"]! as! NSNumber
        
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
        
        self.cancelBM(nil)
    }
    func updatedBM(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContextUserData!

        editingBookMark!.folder = self.folder
        
        var error: NSError?
        
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let _ = error {
            print("\(error)")
        } else {
            //("success")
        }
        
        self.cancelBM(nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if editingBookMark != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("updatedBM"))
            
            self.navigationItem.title = "Edit Bookmark"
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
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var ident = "CellTitle"
        if indexPath.section == 1 {
            ident = "FolderCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(ident, forIndexPath: indexPath) 
        
        if indexPath.section == 0 {
            
            if editingBookMark != nil {
                cell.textLabel?.text = editingBookMark!.songtitle
                
            }else{
                cell.textLabel?.text = newBM!["songtitle"] as? String
            }
            
            
        }else{
           
            cell.textLabel?.text = self.folder!.folder_label
            cell.imageView?.image = UIImage(named: "folder.png")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "SelectFolder" {
            
            let controller = segue.destinationViewController  as! FolderSelectionTableViewController
            controller.delegate = self
            
            
        }
    }
    // MARK: protocol FolderSelection
    func folderSelected(selectedFolder : Folder) {
        
        self.folder = selectedFolder
        self.folder.lastaccessed = NSDate()
        self.tableView.reloadData()
    }

}

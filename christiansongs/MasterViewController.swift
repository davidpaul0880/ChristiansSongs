//
//  MasterViewController.swift
//  christiansongs
//
//  Created by jijo on 3/9/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import UIKit
import CoreData


extension NSManagedObject {
    
    func uppercaseFirstLetterOfName() -> String {
    
        self.willAccessValueForKey("uppercaseFirstLetterOfName")
        
        let us = self.valueForKey("title_ml")!.uppercaseString as NSString
        let restr = us.substringToIndex(1)
        self.didAccessValueForKey("uppercaseFirstLetterOfName")
        
        return String(restr)
        
    }
    func uppercaseFirstLetterOfEngName() -> String {
        
        self.willAccessValueForKey("uppercaseFirstLetterOfEngName")
        
        let us = self.valueForKey("title_en")!.uppercaseString as NSString
        let restr = us.substringToIndex(1)
        self.didAccessValueForKey("uppercaseFirstLetterOfEngName")
        
        return String(restr)
        
    }
    
}

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    //@IBOutlet weak var searchhBar: UISearchBar!
    typealias Closure = () -> ()
    private var closures = [String: Closure]()
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var selectedSongFromBM : Songs?
    //@IBOutlet weak var searchBar : UISearchBar!
    //@IBOutlet weak var searchDisplayController : UISearchDisplayController!
    enum LangType {
        
        case Malyalam
        case Englisg
    }

    var language : LangType = LangType.Malyalam
    var titleField : String {
        
        if language == LangType.Malyalam {
            return "title_ml"
        }else{
            return "title_en"
        }
    }
    
    func infoClicked() {
        
        [self.performSegueWithIdentifier("showInfo", sender: self)]
        
    }
    func bookMarkClicked(){
        
    }
    func languageChanged(sender:UIBarButtonItem!) {
        
        if sender.title == "ENG" {
            language = LangType.Englisg
            sender.title = "MAL"
        }else{
            language = LangType.Malyalam
            sender.title = "ENG"
        }
        _fetchedResultsController = nil
        self.tableView.reloadData()
    }
    func reFetchData(searchText : String, Scope selectedScope : Int){
        
        var tfield = titleField

        let range1 = searchText.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"))
        if range1?.startIndex >= searchText.startIndex {
            
            
            tfield = "title_en"
        }
        
        
        //("searchText =\(searchText)")
        
        let fetchRequest = self.fetchedResultsController.fetchRequest
        
        
        
        //if selectedScope == 0 {
        let predicate = NSPredicate(format: "(\(tfield) BEGINSWITH[c] %@)", argumentArray: [searchText])
        fetchRequest.predicate = predicate
        
        /*}else{
        let predicate = NSPredicate(format: "(%@ CONTAINS[c] %@)", argumentArray: [titleField, searchText])
        fetchRequest.predicate = predicate
        }*/
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        self.tableView.reloadData()
        
    }
    func delayed(delay: Double, name: String, closure: Closure){
        
        closures[name] = closure
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)) ) , dispatch_get_main_queue()){
        
            if let clor = self.closures[name] {
        
                clor()
                
                
                self.closures[name] = nil
            }
        
        
        }
    }
    func cancelDelayed(name: String) {
        
        closures[name] = nil
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        //self performSelector:@selector(sendInlineSearch:) withObject:searchBar afterDelay:1.0];
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendInlineSearch:) object:searchBar];

        //self.cancelDelayed("search")
        //self.delayed(0.5, name: "search"){
            
            self.reFetchData(searchText, Scope: 0)
        //}
        //self.reFetchData(searchText, Scope: 0) //self.searchDisplayController!.searchBar.selectedScopeButtonIndex
        
    }
    /*func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        self.reFetchData(searchBar.text, Scope: selectedScope)
    }*/
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.text = nil
        let fetchRequest = self.fetchedResultsController.fetchRequest
        
        
        fetchRequest.predicate = nil
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    //optional func searchBarSearchButtonClicked(searchBar: UISearchBar) // called when keyboard search button pressed
    //optional func searchBarCancelButtonClicked(searchBar: UISearchBar)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewWillAppear(animated: Bool) {
        //self.navigationController!.toolbarHidden = false;
        selectedSongFromBM = nil;
        super.viewWillAppear(animated);
    }
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        //self.navigationController!.toolbarHidden = true;
        
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        if isPad {
            
            if self.detailViewController?.songObj == nil {
                
                self.detailViewController!.songObj = BMDao().getSelectedSong("34")
                if self.detailViewController!.songObj != nil {
                    self.detailViewController!.configureView()
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let btn : UIButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
        btn.addTarget(self, action: Selector("infoClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        
        //let infoButton = UIBarButtonItem(customView: btn)
        
        
        self.navigationItem.leftBarButtonItem?.customView = btn

        
        let titlee = language == LangType.Malyalam ? "ENG" : "MAL"
        let langbuttom = UIBarButtonItem(title: titlee, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("languageChanged:"))
        langbuttom.possibleTitles = NSSet(array: ["ENG", "MAL"]) as Set<NSObject>
        
        self.navigationItem.rightBarButtonItem = langbuttom
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func insertNewObject(sender: AnyObject) {
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as NSManagedObject
             
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
             
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
    }*/

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            if selectedSongFromBM != nil {
                
                
               
                controller.language = self.language
                controller.songObj = selectedSongFromBM
                
                
                
            }
            else if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Songs
                
                controller.language = self.language
                controller.songObj = object
                
            }
            
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            
            if orientation.isPortrait {
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.hideMaster()
                // Portrait
            } else {
                // Landscape
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.name!
    }
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        return self.fetchedResultsController.sectionForSectionIndexTitle(title, atIndex: index)
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        return self.fetchedResultsController.sectionIndexTitles
    }
    
   
    /*override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    */
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Songs
        if language == LangType.Malyalam {
            cell.textLabel!.text = object.title_ml
        }else{
            cell.textLabel!.text = object.title_en
        }
        
    }

    
    
    // MARK: - Fetched results controller

    var fetchedResultsController: MyNSFetchedResultsController {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Songs", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        //caseInsensitiveCompare localizedCaseInsensitiveCompare localizedStandardCompare
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: titleField, ascending: true, selector: Selector("caseInsensitiveCompare:"))
        
        //let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var keypath = "uppercaseFirstLetterOfName"
        if language == LangType.Englisg {
            keypath = "uppercaseFirstLetterOfEngName"
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = MyNSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: keypath, cacheName: nil)
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
    	var error: NSError? = nil
    	if !_fetchedResultsController!.performFetch(&error) {
    	     // Replace this implementation with code to handle the error appropriately.
    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //println("Unresolved error \(error), \(error.userInfo)")
    	     abort()
    	}
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: MyNSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
        
        //("end fetch");
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}


//
//  BMDao.swift
//  christiansongs
//
//  Created by jijo on 3/11/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BMDao {
    
    func getAllFolders() -> [Folder] {
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContextUserData!
        
        let fetchRequest1 = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity1 = NSEntityDescription.entityForName("Folder", inManagedObjectContext: managedObjectContext)
        fetchRequest1.entity = entity1
        
        /*let pred1 = NSPredicate(format: "(folder_label != 'Bookmarks')", argumentArray: nil)
        fetchRequest1.predicate = pred1
        */
        
        var error: NSError?
        
        let objects = (try! managedObjectContext.executeFetchRequest(fetchRequest1)) as! [Folder]
        
        return objects
    }
    
    func getSelectedSong(songId : NSNumber) -> Songs? {
        
        //("songId = \(songId)")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        
        let fetchRequest1 = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity1 = NSEntityDescription.entityForName("Songs", inManagedObjectContext: managedObjectContext)
        fetchRequest1.entity = entity1
        
        let pred1 = NSPredicate(format: "(song_id = %@)", argumentArray: [songId])
        fetchRequest1.predicate = pred1
        
        var error: NSError?
        
        var objects = (try! managedObjectContext.executeFetchRequest(fetchRequest1)) as! [Songs]
        
        if objects.count > 0 {
            
            //("got bm song")
            return objects[0]
        }else{
            //("got no song \(error?.localizedDescription)")
            return nil
        }
        
        
    }
    
    func getDefaultFolder() -> Folder {
        
        var fldr : Folder?
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContextUserData!
        
        let fetchRequest1 = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity1 = NSEntityDescription.entityForName("Folder", inManagedObjectContext: managedObjectContext)
        fetchRequest1.entity = entity1

        
        let sortDescriptor = NSSortDescriptor(key: "lastaccessed", ascending: false)
        fetchRequest1.sortDescriptors = [sortDescriptor]
        
        //let pred1 = NSPredicate(format: "(folder_label = 'Bookmarks')", argumentArray: nil)
        //fetchRequest1.predicate = pred1
        
        var error: NSError?
        
        var objects = (try! managedObjectContext.executeFetchRequest(fetchRequest1)) as! [Folder]
        
        if objects.count == 0 {
            
            fldr = NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext: managedObjectContext) as? Folder
            fldr?.created_date = NSDate()
            fldr?.folder_label = "Bookmarks"
            fldr?.lastaccessed = NSDate()
            fldr?.orderfield = NSDate().timeIntervalSinceReferenceDate
            var error: NSError?
            
            do {
                try managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
            }
            
            if let err = error {
                print("\(error)")
            }else{
                
                
                //("success")
                
                let fetchRequest = NSFetchRequest()
                // Edit the entity name as appropriate.
                let entity = NSEntityDescription.entityForName("Folder", inManagedObjectContext: managedObjectContext)
                fetchRequest.entity = entity
                
                let pred = NSPredicate(format: "(folder_label = 'Bookmarks')", argumentArray: nil)
                fetchRequest.predicate = pred
                
                var error: NSError?
                
                var objects = (try! managedObjectContext.executeFetchRequest(fetchRequest)) as! [Folder]
                if objects.count > 0 {
                    
                    fldr = objects[0]
                }

            }
            
            
        }else{
            //("exist")
            fldr = objects[0]
            
        }
        return fldr!
    }
}
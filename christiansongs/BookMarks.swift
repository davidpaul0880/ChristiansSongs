//
//  BookMarks.swift
//  christiansongs
//
//  Created by jijo on 3/13/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import Foundation
import CoreData

class BookMarks: NSManagedObject {

    @NSManaged var bmdescription: String
    @NSManaged var createddate: NSDate
    @NSManaged var lastaccesseddate: NSDate
    @NSManaged var orderfield: NSNumber
    @NSManaged var songs_id: String
    @NSManaged var songtitle: String
    @NSManaged var language: String
    @NSManaged var folder: NSManagedObject

}

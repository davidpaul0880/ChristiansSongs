//
//  Folder.swift
//  christiansongs
//
//  Created by jijo on 3/13/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import Foundation
import CoreData

class Folder: NSManagedObject {

    @NSManaged var created_date: NSDate
    @NSManaged var folder_label: String
    @NSManaged var orderfield: NSNumber
    @NSManaged var bookmarks: NSSet

}

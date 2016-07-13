//
//  Songs.swift
//  christiansongs
//
//  Created by jijo on 3/9/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import Foundation
import CoreData

class Songs: NSManagedObject {

    @NSManaged var filename_en: String
    @NSManaged var filename_ml: String
    @NSManaged var song_id: NSNumber
    @NSManaged var title_en: String
    @NSManaged var title_ml: String
    
    

}

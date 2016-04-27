//
//  MyNSFetchedResultsController.swift
//  christiansongs
//
//  Created by jijo on 3/9/15.
//  Copyright (c) 2015 jeesmon. All rights reserved.
//

import CoreData


class MyNSFetchedResultsController : NSFetchedResultsController {
    
    
    override func sectionIndexTitleForSectionName(sectionName: String) -> String? {
        
        return sectionName;
    }
}
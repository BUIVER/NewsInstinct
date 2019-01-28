//
//  News+CoreDataClass.swift
//  PropertyList
//
//  Created by Ivan Ermak on 1/26/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//
//

import Foundation
import CoreData

@objc(News)
public class News: NSManagedObject {
    convenience init() {
        self.init(context: CoreDataManager.instance.managedObjectContext)
    }
}

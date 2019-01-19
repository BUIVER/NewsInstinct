//
//  News+CoreDataProperties.swift
//  PropertyList
//
//  Created by Ivan Ermak on 1/3/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var image_ref: NSData?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}

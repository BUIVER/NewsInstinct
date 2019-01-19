//
//  DataBase+CoreDataProperties.swift
//  
//
//  Created by Ivan Ermak on 1/2/19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension DataBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataBase> {
        return NSFetchRequest<DataBase>(entityName: "DataBase")
    }

    @NSManaged public var image_ref: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}

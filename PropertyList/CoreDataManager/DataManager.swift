//
//  DataManager.swift
//  PropertyList
//
//  Created by Ivan Ermak on 1/2/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    static let instance = CoreDataManager()
    let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
    private init() {}
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: nil, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("DataModel.sql")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func deleteObject(_ object: NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
    
    func insertObject(_ serverMatch: NetworkLoadStructure) {
        let insertedObject = News()
        insertedObject.id = serverMatch.id
        insertedObject.title = serverMatch.title
        insertedObject.subtitle = serverMatch.subtitle
        insertedObject.imageUrl = serverMatch.imageUrl
        insertedObject.updateTime = serverMatch.updateTime
        insertedObject.hasUpdated = false
    }
    
    func updateObject(_ object: NetworkLoadStructure, existObject: News) {
            if (existObject.updateTime != object.updateTime){
                if (existObject.title != object.title)
                {
                    existObject.title = object.title
                }
            
                if (existObject.subtitle != object.subtitle)
                {
                    existObject.subtitle = object.subtitle
                }
                if (existObject.id != object.id)
                {
                    existObject.id = object.id
                }
                if (existObject.imageUrl != object.imageUrl)
                {
                    existObject.imageUrl = object.imageUrl
                }
                    existObject.updateTime = object.updateTime
                
          
            }
       
    }
}

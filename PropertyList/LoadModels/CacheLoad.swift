//
//  CacheLoad.swift
//  PropertyList
//
//  Created by Ivan Ermak on 1/27/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation
import CoreData
import UIKit
protocol CachedLoadDelegate: class {
    func syncCompleted()
}

class CacheLoad
{
    let fetchedResultController : NSFetchedResultsController<News>
    var mainDelegate: CachedLoadDelegate?
    
   
    init(delegate: NSFetchedResultsControllerDelegate) {
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: CoreDataManager.instance.managedObjectContext,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultController.delegate = delegate
    }
    
    func loadData()
    {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        
    }
    
    
    
    func startSync(data: [NetworkLoadStructure]) {
        var serverData: [String:NetworkLoadStructure] = [:]
        let arrayedServerData = data
        let cachedData = loadFromLocalStorage()
        
       for index in 0..<arrayedServerData.count
        {
            
            let appendedValue = arrayedServerData[index]
            
            serverData.updateValue(appendedValue, forKey: appendedValue.id)
        }
        
        var amountOfData: Set<String> = []
        cachedData.keys.forEach{key in
            amountOfData.insert(key)
        }
        serverData.keys.forEach{key in
            amountOfData.insert(key)
        }
        amountOfData.formUnion(serverData.keys)
        amountOfData.forEach({usedId in
            if let serverMatch = serverData[usedId]
            {
                
                if let cachedObject = cachedData[usedId] {
                    CoreDataManager.instance.updateObject(serverMatch, existObject: cachedObject)
                }
                else {
                    CoreDataManager.instance.insertObject(serverMatch)
                    
                }
            }
            else
            {
                if let cachedMatch = cachedData[usedId]{
                    CoreDataManager.instance.deleteObject(cachedMatch)
                }
            }
            
        })
        CoreDataManager.instance.saveContext()
        
       
        
        mainDelegate?.syncCompleted()
    
    
        
    }
    func loadFromLocalStorage() -> [String:News]
    {
        var resultDict: [String:News] = [:]
        
        if let fetchedObjects = self.fetchedResultController.fetchedObjects {
            for result in fetchedObjects {
              
                resultDict.updateValue(result, forKey: result.id)
            }
        
        return resultDict
        }
        else {return [:]}
    }
}

/* insert -> update values & save them +
 class for image loads +
 cache repair -
 replace DataStructure with DB model +
 add check of update in data +
 */

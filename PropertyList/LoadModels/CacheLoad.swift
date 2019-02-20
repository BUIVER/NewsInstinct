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
    var cachedData: [String:News] = [:]
   
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
        var serverIdList: Set<String> = []
        let (cahr, idList) = loadFromLocalStorage()
        
       for index in 0..<arrayedServerData.count
        {
            
            let appendedValue = arrayedServerData[index]
            serverIdList.insert(appendedValue.id)
            
            serverData.updateValue(appendedValue, forKey: appendedValue.id)
        }
        var amountOfData = idList
        amountOfData.formUnion(serverIdList)
        amountOfData.forEach({usedId in
            if let serverMatch = serverData[usedId]
            {
                
                if let cachedObject = cachedData[usedId] {
                    CoreDataManager.instance.updateObject(serverMatch, existObject: cachedObject)
                }
                else {
                   // CoreDataManager.instance.insertObject(serverMatch)
                    let insertedObject = News()
                    insertedObject.id = serverMatch.id
                    insertedObject.title = serverMatch.title
                    insertedObject.subtitle = serverMatch.subtitle
                    insertedObject.imageUrl = serverMatch.imageUrl
                    insertedObject.updateTime = serverMatch.updateTime
                }
            }
            else
            {
                if let cachedMatch = cachedData[usedId]{
                    CoreDataManager.instance.deleteObject(cachedMatch)
                }
            }
            
        })
        cachedData = [:]
        CoreDataManager.instance.saveContext()
       
       
        
        mainDelegate?.syncCompleted()
    
    
        
    }
    func loadFromLocalStorage() -> (data: [News], idList: Set<String>)
    {
        var idList: Set<String> = []
        if let fetchedObjects = self.fetchedResultController.fetchedObjects {
            for result in fetchedObjects {
                idList.insert(result.id)
                cachedData.updateValue(result, forKey: result.id)
            }
        
        return (data: fetchedObjects, idList: idList)
        }
        else {return (data: [], idList: idList)}
    }
}

/* insert -> update values & save them +
 class for image loads +
 cache repair -
 replace DataStructure with DB model +
 add check of update in data +
 */

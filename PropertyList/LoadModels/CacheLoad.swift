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
    var idList: Set<Int32> = []
    var mainDelegate: CachedLoadDelegate?
    var cachedData: [Int32:DataStructure] = [:]
    var serverData: [Int32:DataStructure] = [:]
    
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
    
    func saveToLocalStorage(data: DataStructure/*, image: UIImage*/) {
      
        let emptyElement = News()
        
        emptyElement.id = Int32(data.id)
        emptyElement.subtitle = data.subtitle
        emptyElement.title = data.title
        emptyElement.imageUrl = data.image_ref
        
        
        CoreDataManager.instance.insertObject(emptyElement)
//        CoreDataManager.instance.saveContext()
       
    }
    
    
    func startSync(data: [DataStructure]) {
        
        let arrayedLocalData = loadFromLocalStorage().data
        let arrayedServerData = data
        var serverIdList: Set<Int32> = []
        for index in 0..<arrayedServerData.count
        {
            
            let appendedValue = arrayedServerData[index]
            serverIdList.insert(appendedValue.id)
            
            serverData.updateValue(appendedValue, forKey: arrayedServerData[index].id)
        }
        
        var toRemoveList = self.idList
        
        var amountOfData = idList
        amountOfData.formUnion(serverIdList)
        toRemoveList.subtract(serverIdList)
        
        let localIds = Array(cachedData.keys)
        for index in 0..<amountOfData.count
        {
            if(index < localIds.count)
            {
                
                if(toRemoveList.contains(localIds[index]))
                {
                    let removedObject = structureToObject(data: cachedData[localIds[index]]!)
                    
                        CoreDataManager.instance.deleteObject(removedObject)
                    
                    cachedData.removeValue(forKey: localIds[index])
                   
                    
                    
                }
            }
            else if let value = serverData[Int32(index)]
            {
                cachedData.updateValue(value, forKey: Int32(index))
            }
        }
        
        cachedData.forEach({
            self.saveToLocalStorage(data: $0.value)
        })
        
        CoreDataManager.instance.saveContext()
        
        mainDelegate?.syncCompleted()
    
    
    
        for index in 0..<arrayedLocalData.count
        {
            cachedData.updateValue(arrayedLocalData[index], forKey: arrayedLocalData[index].id)
        }
       
        
    }
    func loadFromLocalStorage() -> (data: [DataStructure], idList: Set<Int32>)
    {
        var fetchedData: [DataStructure] = []

        if let fetchedObjects = self.fetchedResultController.fetchedObjects {
            for result in fetchedObjects {
                idList.insert(result.id)
                let nsData = UIImage(imageLiteralResourceName: "amfora").pngData()
                let emptyElement = DataStructure(image_ref: result.imageUrl ?? "", id: result.id, subtitle: result.subtitle ?? "", title: result.title ?? "", image: nsData! as NSData)
                fetchedData.append(emptyElement)
                
                
            }
        }
        return (data: fetchedData, idList: idList)
    }
    func structureToObject(data: DataStructure) -> News
    {
        let resultValue = News()
        resultValue.id = data.id
        resultValue.imageUrl = data.image_ref
        resultValue.subtitle = data.subtitle
        resultValue.title = data.title
        return resultValue
    }
}

/* insert -> update values & save them
 class for image loads
 cache repair
 replace DataStructure with DB model
 add check of update in data
 */

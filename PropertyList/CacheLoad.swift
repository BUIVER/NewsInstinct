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
    var mainDelegate: CachedLoadDelegate? = nil
    let networkLoad = NetworkLoad()
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
        
//        emptyElement.image = image.pngData() as NSData?
        emptyElement.id = Int32(data.id)
        emptyElement.subtitle = data.subtitle
        emptyElement.title = data.title
        emptyElement.imageUrl = data.image_ref
        
        
        CoreDataManager.instance.insertObject(emptyElement)
//        CoreDataManager.instance.saveContext()
       
    }
    
    
    func startSync() {
        networkLoad.delegate = self
        let arrayedLocalData = loadFromLocalStorage().data
        for index in 0..<arrayedLocalData.count
        {
            cachedData.updateValue(arrayedLocalData[index], forKey: arrayedLocalData[index].id)
        }
        networkLoad.dataDownload()
        
    }
    func loadFromLocalStorage() -> (data: [DataStructure], idList: Set<Int32>)
    {
        var fetchedData: [DataStructure] = []

        if let fetchedObjects = self.fetchedResultController.fetchedObjects {
            for result in fetchedObjects {
                idList.insert(result.id)
                
                let emptyElement = DataStructure(image_ref: result.imageUrl ?? "", id: result.id, subtitle: result.subtitle ?? "", title: result.title ?? "", image: result.image ?? NSData())
                fetchedData.append(emptyElement)
                
                
            }
        }
//        var fetchedData: [DataStructure] = []
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
//        do {
//            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
//            for result in results as! [News] {
//                idList.insert(result.id)
//
//                let emptyElement = DataStructure(image_ref: result.imageUrl ?? "", id: result.id, subtitle: result.subtitle ?? "", title: result.title ?? "", image: result.image ?? NSData())
//                fetchedData.append(emptyElement)
//
//
//            }
//        } catch {
//            print(error)
//        }
        return (data: fetchedData, idList: idList)
    }
}

extension CacheLoad: DataLoadDelegate
{
    func dataLoadCompleted(data: [DataStructure]) {
        let arrayedServerData = data
        var serverIdList: Set<Int32> = []
        for index in 0..<arrayedServerData.count
        {
            
            let appendedValue = arrayedServerData[index]
            serverIdList.insert(appendedValue.id)
           
            serverData.updateValue(appendedValue, forKey: arrayedServerData[index].id)
        }
        
        var idList = self.idList
        
        var resultCount = idList
        resultCount.formUnion(serverIdList)
        idList.subtract(serverIdList)
       
//        idList.forEach { (id) in
//            CoreDataManager.deleteObject(<#T##CoreDataManager#>)
//        }
        
        let array = Array(cachedData.keys)
        for index in 0..<resultCount.count
        {
            if(index < array.count)
            {
                if(idList.contains(array[index]))
                {
                    cachedData.removeValue(forKey: array[index])
                }
            }
            else if let value = serverData[Int32(index)]
            {
                cachedData.updateValue(value, forKey: Int32(index))
//                if let url = URL(string: value.image_ref){
//                    networkLoad.loadImage(url: url, index: index)
//                }
            }
        }
        
        cachedData.forEach({
            self.saveToLocalStorage(data: $0.value)
        })
        
        CoreDataManager.instance.saveContext()

        mainDelegate?.syncCompleted()
    }
    
    func imageLoadCompleted(image: UIImage, index: Int) {
        
//        saveToLocalStorage(data: cachedData[Int32(index)]!, image: image)
        mainDelegate?.syncCompleted()
//        delegate?.syncCompleted()
    }
    
    
}


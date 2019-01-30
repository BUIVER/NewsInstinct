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
class CacheLoad
{
    let networkLoad = NetworkLoad()
    
    func DataLoad(view: ViewController)
    {
        let data = localStorageLoad()
        if (data.count != 0)
        {
            view.cachedData = data
            
        }
        else {  networkLoad.dataDownload(view: view)
            
        }
        
    }
    
    func localStorageSave(data: DataStructure, image: UIImage){
      //  var managedObject : [News] = []
        let emptyElement = News()
        
        emptyElement.image = image.pngData() as NSData?
        emptyElement.id = Int32(data.id)
        emptyElement.subtitle = data.subtitle
        emptyElement.title = data.title
        emptyElement.imageUrl = data.image_ref
        
       // managedObject.append(emptyElement)
        CoreDataManager.instance.saveContext()
        
    }
    
    
    func localStorageSyncStarts(data: [DataStructure]){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do
        {
            try CoreDataManager.instance.persistentStoreCoordinator.execute(deleteRequest, with: CoreDataManager.instance.managedObjectContext.self)
        }
        catch _ as NSError {}
       // CoreDataManager.instance.saveContext()
        
    }
    func localStorageLoad() -> [DataStructure]
    {
        var fetchedData: [DataStructure] = []
        var idList: [Int32] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [News] {
                idList.append(result.id)
                
                let emptyElement = DataStructure(image_ref: result.imageUrl ?? "", id: result.id, subtitle: result.subtitle ?? "", title: result.title ?? "", image: result.image ?? NSData())
                fetchedData.append(emptyElement)
                
                
            }
        } catch {
            print(error)
        }
        return fetchedData
    }
    
    
}

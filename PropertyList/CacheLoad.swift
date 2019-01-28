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
    
    func localStorageSave(data: UploadDataStructure, image: UIImage){
      //  var managedObject : [News] = []
        let emptyElement = News()
        
        emptyElement.image_ref = image.pngData() as NSData?
        emptyElement.id = Int32(data.id)
        emptyElement.subtitle = data.subtitle
        emptyElement.title = data.title
        
       // managedObject.append(emptyElement)
        CoreDataManager.instance.saveContext()
        
    }
    
    
    func localStorageSyncStarts(data: [StoredDataStructure]){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do
        {
            try CoreDataManager.instance.persistentStoreCoordinator.execute(deleteRequest, with: CoreDataManager.instance.managedObjectContext.self)
        }
        catch _ as NSError {}
       // CoreDataManager.instance.saveContext()
        
    }
    func localStorageLoad() -> [StoredDataStructure]
    {
        var fetchedData: [StoredDataStructure] = []
        var idList: [Int32] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [News] {
                idList.append(result.id)
                
                let emptyElement = StoredDataStructure(image: result.image_ref ?? NSData(), id: result.id, subtitle: result.subtitle ?? "", title: result.title ?? "")
                fetchedData.append(emptyElement)
                
                
            }
        } catch {
            print(error)
        }
        return fetchedData
    }
    
    
}

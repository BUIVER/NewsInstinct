//
//  DataUpload.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/13/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit

protocol DataLoadDelegate: class {
    func dataLoadCompleted(data: [News])
}

class LoadDataFromNetwork
{
    weak var delegate : DataLoadDelegate?
    let urlSession = URLSession()
    

    var loadedImages : [URL:UIImage?] = [:]

    
    func dataDownload()
    {
    
        
        let url = URL(string: "https://api.backendless.com/8FA06EE1-1C10-07F0-FF07-F05A0F78EA00/E2BC3E0D-149E-3D84-FF61-3CE7338E4700/data/table")
        
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        
        
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            guard error == nil else
            {
                debugPrint("error")
                return
            }
            guard let data = data else {
                debugPrint("data")
                return
            }
            
            
            do
            {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [NSDictionary]{
                    var fullLoadedData = [News]()
                    for index in 0..<json.count
                    {
                        let cluster = json[index]
                        let title = cluster.value(forKey: "title") as? String
                        let subtitle = cluster.value(forKey: "subtitle") as? String
                        let imageUrl = cluster.value(forKey: "image_ref") as? String
                        let id = cluster.value(forKey: "objectId") as! String
                    
                       // debugPrint(type(of: cluster.value(forKey: "updated")))
                     
                        let updateTime = String(describing: cluster.value(forKey: "updated"))
                     
                        let partialData = News()

//                        CoreDataManager.instance.deleteObject(partialData)
                        partialData.title = title
                        partialData.id = id
                        partialData.imageUrl = imageUrl
                        partialData.subtitle = subtitle
                        partialData.updateTime = updateTime
                        fullLoadedData.append(partialData)
                        
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate?.dataLoadCompleted(data: fullLoadedData)
                        
                    }
                    
                    
                }
                
            } catch let error {
                debugPrint(debugPrint(error.localizedDescription))
            }
            
        })
        
        task.resume()
 
    }
   
   
}

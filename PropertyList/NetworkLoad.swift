//
//  DataUpload.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/13/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit
import CoreData

protocol DataLoadDelegate: class {
    func dataLoadCompleted(data: [DataStructure])
    func imageLoadCompleted(image: UIImage, index: Int)
}

class NetworkLoad
{
    weak var delegate : DataLoadDelegate?
    let urlSession = URLSession()
    let imageSession = URLSession.shared
    var loadedImages : [URL:UIImage?] = [:]

    
    func dataDownload()
    {
    
//
//        let element1: DataStructure = DataStructure.init(image_ref: "", id: 0, subtitle: "123", title: "1", image: NSData())
//        let element2: DataStructure = DataStructure.init(image_ref: "", id: 1, subtitle: "124", title: "2", image: NSData())
//        let element3: DataStructure = DataStructure.init(image_ref: "", id: 2, subtitle: "125", title: "3", image: NSData())
//
//
//        self.delegate?.dataLoadCompleted(data: [element1, element2, element3])

        
        
        let url = URL(string: "https://api.backendless.com/8FA06EE1-1C10-07F0-FF07-F05A0F78EA00/E2BC3E0D-149E-3D84-FF61-3CE7338E4700/data/table")
        
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        var fullLoadedData = [DataStructure]()
        
        
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
                    
                    for index in 0..<json.count
                    {
                        let cluster = json[index]
                        let title = cluster.value(forKey: "title") as! String
                        let subtitle = cluster.value(forKey: "subtitle") as! String
                        let imageUrl = cluster.value(forKey: "image_ref") as! String
                        let id = cluster.value(forKey: "ID") as! Int32
                        let image = NSData()
                        var partialData: DataStructure
                        partialData = DataStructure(image_ref: imageUrl, id: id, subtitle: subtitle, title: title, image: image)
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
    
    func loadImage(url: URL, index: Int)
       
    {
        
        if let value = loadedImages[url]  {
            if let gottenImage = value {
                DispatchQueue.main.async {
                    self.delegate?.imageLoadCompleted(image: gottenImage, index: index)
                }
            }
            return
        }
        
        loadedImages.updateValue(nil, forKey: url)
        
        let imageDownloadTask = imageSession.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard error == nil else
            {
                self?.loadedImages.removeValue(forKey: url)
                debugPrint("error")
                return
            }
            guard let data = data else {
                self?.loadedImages.removeValue(forKey: url)
                debugPrint("data")
                return
            }
            
            let gottenImage = UIImage(data: data)
            self?.loadedImages.updateValue(gottenImage, forKey: url)
            DispatchQueue.main.async {
                self!.delegate?.imageLoadCompleted(image: gottenImage!, index: index)
            }
            
        })
        imageDownloadTask.resume()
        
    }
   
}

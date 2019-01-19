//
//  DataUpload.swift
//  PropertyList
//
//  Created by Ivan Ermak on 12/13/18.
//  Copyright © 2018 Ivan Ermak. All rights reserved.
//

import UIKit
import CoreData

class DataLoad
{
    let urlSession = URLSession()
    let imageSession = URLSession.shared
    var loadedImages : [URL:UIImage?] = [:]

    func DataLoad(view: ViewController)
    {
        
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
                        let image_ref = cluster.value(forKey: "image_ref") as! String
                        var partialData: DataStructure
                        partialData = DataStructure(image_ref: image_ref, subtitle: subtitle, title: title)
                        fullLoadedData.append(partialData)
                        
                    }
                    DispatchQueue.main.async {
                        view.loadCompleted(data: fullLoadedData)
                    }
             
                    
                }
            
            } catch let error {
                debugPrint(debugPrint(error.localizedDescription))
            }
        
        })
       
        task.resume()
       
        
        }
    
        
    
    func loadImage(url: URL, index: Int, view: ViewController)
        
    {
        if let value = loadedImages[url]  {
            if let gottenImage = value {
                DispatchQueue.main.async {
                    view.imageLoadCompleted(Image: gottenImage, index: index)
                }
            }
            return
        }
        
        loadedImages.updateValue(nil, forKey: url)
        
        let imageDownloadTask = imageSession.dataTask(with: url, completionHandler: { [weak self, weak view] data, response, error in
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
                view?.imageLoadCompleted(Image: gottenImage!, index: index)
            }
            
        })
        imageDownloadTask.resume()
        
    }
    func localStorageSave(data: DataStructure, image: UIImage){
        var managedObject : [News] = []
            let emptyElement = News()
    
        emptyElement.image_ref = image.pngData() as NSData?
//        UIImage.init(data: emptyElement.image_ref! as Data)
            emptyElement.subtitle = data.subtitle
            emptyElement.title = data.title
            managedObject.append(emptyElement)
        CoreDataManager.instance.saveContext()
        
    }
    func localStorageLoad()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [News] {
                debugPrint("name - \(result.title!)")
            }
        } catch {
            print(error)
        }

    }
    
}

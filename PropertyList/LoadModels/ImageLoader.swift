//
//  LoadImage.swift
//  PropertyList
//
//  Created by Ivan Ermak on 2/13/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation
import UIKit


class ImageLoader
{
    let cachedHandler = URLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity: 0, diskPath: nil)
    let imageSession = URLSession.shared
    var urlsOfCompletedTasks: Set<URL> = []
    var imageDownloadTask: URLSessionDataTask?
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        let dataTask = imageSession.dataTask(with: url)
        if (urlsOfCompletedTasks.contains(url)){
            cachedHandler.getCachedResponse(for: dataTask, completionHandler: {response in
                if let imageData = response?.data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            })
        } else {
            loadData(url: url, completionHandler: { response in
                if let cacheResponseUnwrap = response{
                    self.cachedHandler.storeCachedResponse(cacheResponseUnwrap, for: dataTask)
                    let image = UIImage(data: cacheResponseUnwrap.data)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                    return
                }
                DispatchQueue.main.async{
                    completion(nil)
                }
                })
           }
        }

    private func loadData(url: URL, completionHandler: @escaping (CachedURLResponse?) -> ()) {
        let imageDownloadTask = imageSession.dataTask(with: url, completionHandler: { data, response, error in
            
            guard error == nil else
            {
                
                debugPrint("error")
                completionHandler(nil)
                return
            }
            guard let data = data else {
                
                debugPrint("data")
                completionHandler(nil)
                return
            }
            if let responseUnwrap = response {
                let cacheResponse = CachedURLResponse(response: responseUnwrap, data: data)
                self.urlsOfCompletedTasks.insert(url)
                completionHandler(cacheResponse)
                //save url of finished request
            }
            else {completionHandler(nil)}
        })
        
        imageDownloadTask.resume()
    }
}
      
        


//check if tast is cahed

//if yes, return image

//if not, start new task

//in completion
//  save response to cache
//  return image or nil into completion handler



//DetailedViewController: edit and add.
//Create Post of data, find and add image post from gallery & camera


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
    var cacheResponse: CachedURLResponse?
    var dataTasksLists: [URL: URLSessionDataTask] = [:]
    func loadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        if let dataTask = dataTasksLists[url]
        {
            cachedHandler.getCachedResponse(for: dataTask, completionHandler: {response in
                if let imageData = response?.data{
                    if let image = UIImage(data: imageData){
                        completion(image)
                    }
                    else {completion(UIImage())}
                }
                
            })
        }
        else {
            let imageDownloadTask = imageSession.dataTask(with: url, completionHandler: { data, response, error in
                guard error == nil else
                {
                    
                    debugPrint("error")
                    return
                }
                guard let data = data else {
                    
                    debugPrint("data")
                    return
                }
                if let responseUnwrap = response{
                    self.cacheResponse = CachedURLResponse(response: responseUnwrap, data: data)
                }
            })
            imageDownloadTask.resume()
            if let cacheResponseUnwrap = self.cacheResponse {
            cachedHandler.storeCachedResponse(cacheResponseUnwrap, for: imageDownloadTask)
                let image = UIImage(data: cacheResponseUnwrap.data)
                completion(image)
            }
            
           
        }
        //check if tast is cahed
        
        //if yes, return image
        
        //if not, start new task
        
        //in completion
        //  save response to cache
        //  return image or nil into completion handler
    }
    
   
      
        
    }

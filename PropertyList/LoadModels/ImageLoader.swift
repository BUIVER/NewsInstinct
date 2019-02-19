//
//  LoadImage.swift
//  PropertyList
//
//  Created by Ivan Ermak on 2/13/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation
import UIKit
protocol LoadImageDelegate: class {
    func imageLoadCompleted(imageSession: URLSessionDataTask, index: Int)
}
class ImageLoader
{
    let cachedHandler: URLCache!
     let imageSession = URLSession.shared
    var delegate: LoadImageDelegate?
    init(cachedHandler: URLCache)
    {
        self.cachedHandler = cachedHandler
    }
    func loadImage(url: URL, index: Int)
        
    {
    
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
            
//            let gottenImage = UIImage(data: data)
            DispatchQueue.main.async {
               
            }
            
        })
        imageDownloadTask.resume()
        self.delegate?.imageLoadCompleted(imageSession: imageDownloadTask, index: index)
        
    
      
        
    }
}

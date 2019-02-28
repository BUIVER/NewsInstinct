//
//  UploadDataToServer.swift
//  PropertyList
//
//  Created by Ivan Ermak on 2/27/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation


class UploadDataToServer{
    func PushToServer()
    {
        let data1 = NetworkLoadStructure(title: "", id: "", subtitle: "", imageUrl: "", updateTime: "", hasUpdated: false)
        var request = URLRequest(url: URL(string: "google.com")!)
        request.httpMethod = "PUT"
        request.addValue("multipart/form-data" , forHTTPHeaderField: "application/json")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data1)
            debugPrint(data)
            
        }
        
        catch {fatalError("")}
    }

}

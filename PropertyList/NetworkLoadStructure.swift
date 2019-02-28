//
//  NetworkLoadStructure.swift
//  PropertyList
//
//  Created by Ivan Ermak on 2/20/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation

struct NetworkLoadStructure: Codable {
    var title: String?
    var id: String
    var subtitle: String?
    var imageUrl: String?
    var updateTime: String?
    var hasUpdated: Bool
}

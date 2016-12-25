//
//  ProjectDigest.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import ObjectMapper

final class ProjectDigest: Mappable {
    var id: String!
    var name: String!
    var isArchived = false
    
    init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        isArchived <- map["isArchived"]
    }
}

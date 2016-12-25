//
//  TaskDigest.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import ObjectMapper

final class TaskDigest: Mappable {
    var id: String!
    var content: String?
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["_id"]
        content <- map["content"]
    }
}

//
//  Event.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import ObjectMapper

final class Event: Mappable {
    var id: String!
    var startDate: Date?
    var endDate: Date?
    var projectID: String?
    var creatorID: String?
    var sourceID: String?
    var status: String?
    var recurrence: [String]?
    var untilDate: Date?
    var tagIDs: [String]?
    var updated: Date?
    var created: Date?
    var isDeleted = false
    var visible: String?
    var involveMembers: [String]?
    var location: String?
    var content: String?
    var title: String?
    var url: URL?
    var isFavorite = false
    var project: ProjectDigest?
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["_id"]
        startDate <- (map["startDate"], ISO8601DateTransform())
        endDate <- (map["endDate"], ISO8601DateTransform())
        projectID <- map["_projectId"]
        creatorID <- map["_creatorId"]
        sourceID <- map["_sourceId"]
        status <- map["status"]
        recurrence <- map["recurrence"]
        untilDate <- (map["untilDate"], ISO8601DateTransform())
        tagIDs <- map["tagIds"]
        updated <- (map["updated"], ISO8601DateTransform())
        created <- (map["created"], ISO8601DateTransform())
        isDeleted <- map["isDeleted"]
        visible <- map["visible"]
        involveMembers <- map["involveMembers"]
        location <- map["location"]
        content <- map["content"]
        title <- map["title"]
        url <- (map["url"], URLTransform())
        isFavorite <- map["isFavorite"]
        project <- map["project"]
    }
}

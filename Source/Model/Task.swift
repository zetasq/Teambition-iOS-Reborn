//
//  Task.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import ObjectMapper

protocol TaskSortable {
    var isDone: Bool { get }
    var priority: Int? { get }
    var dueDate: Date? { get }
    var startDate: Date? { get }
    var created: Date? { get }
}

func sortTaskSortableInPlace(_ array: inout [TaskSortable]) {
    array.sort {
        if $0.isDone < $1.isDone {
            return true
        } else if $0.isDone > $1.isDone {
            return false
        }
        
        if ($0.priority ?? 0) > ($1.priority ?? 0) {
            return true
        } else if ($0.priority ?? 0) < ($1.priority ?? 0) {
            return false
        }
        
        if ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) {
            return true
        } else if ($0.dueDate ?? .distantFuture) > ($1.dueDate ?? .distantFuture) {
            return false
        }
        
        if ($0.startDate ?? .distantFuture) < ($1.startDate ?? .distantFuture) {
            return true
        } else if ($0.startDate ?? .distantFuture) > ($1.startDate ?? .distantFuture) {
            return false
        }
        
        if ($0.created ?? .distantFuture) < ($1.created ?? .distantFuture) {
            return true
        } else if ($0.created ?? .distantFuture) > ($1.created ?? .distantFuture) {
            return false
        }
        
        return true
    }
}

final class Task: Mappable, TaskSortable {
    var id: String!
    var executorID: String?
    var tasklistID: String?
    var stageID: String?
    var projectID: String?
    var creatorID: String?
    var pos: Int?
    var visible: String?
    var subtaskIDs: [String]?
    var involveMembers: [String]?
    var tagIDs: [String]?
    var updated: Date?
    var created: Date?
    var isDeleted = false
    var isDone = false
    var source: String?
    var priority: Int?
    var dueDate: Date?
    var startDate: Date?
    var note: String?
    var content: String?
    var url: URL?
    var isFavorite = false
    var project: ProjectDigest?
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["_id"]
        executorID <- map["_executorId"]
        tasklistID <- map["_tasklistId"]
        stageID <- map["_stageId"]
        projectID <- map["_projectId"]
        creatorID <- map["_creatorId"]
        pos <- map["pos"]
        visible <- map["visible"]
        subtaskIDs <- map["subtaskIds"]
        involveMembers <- map["involveMembers"]
        tagIDs <- map["tagIds"]
        updated <- (map["updated"], ISO8601DateTransform())
        created <- (map["created"], ISO8601DateTransform())
        isDeleted <- map["isDeleted"]
        isDone <- map["isDone"]
        source <- map["source"]
        priority <- map["priority"]
        dueDate <- (map["dueDate"], ISO8601DateTransform())
        startDate <- (map["startDate"], ISO8601DateTransform())
        note <- map["note"]
        content <- map["content"]
        url <- (map["url"], URLTransform())
        isFavorite <- map["isFavorite"]
        project <- map["project"]
    }
}

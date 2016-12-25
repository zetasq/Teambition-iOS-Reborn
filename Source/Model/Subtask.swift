//
//  Subtask.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import ObjectMapper

final class Subtask: Mappable, TaskSortable {
    var id: String!
    var taskID: String!
    var executorID: String?
    var projectID: String?
    var creatorID: String?
    var updated: Date?
    var created: Date?
    var isDone = false
    var dueDate: Date?
    var content: String?
    var project: ProjectDigest?
    var task: TaskDigest?
    
    // for task sort only
    var priority: Int? {
        return 0
    }
    
    var startDate: Date? {
        return nil
    }
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["_id"]
        taskID <- map["_taskId"]
        executorID <- map["_executorId"]
        projectID <- map["_projectId"]
        creatorID <- map["_creatorId"]
        updated <- (map["updated"], ISO8601DateTransform())
        created <- (map["created"], ISO8601DateTransform())
        isDone <- map["isDone"]
        dueDate <- (map["dueDate"], ISO8601DateTransform())
        content <- map["content"]
        project <- map["project"]
        task <- map["task"]
    }
}

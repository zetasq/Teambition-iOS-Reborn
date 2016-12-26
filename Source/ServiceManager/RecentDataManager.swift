//
//  RecentDataManager.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import SwiftDate
import Alamofire
import ObjectMapper

final class RecentDataManager {
    enum RecentDataItem {
        case task(taskObj: Task)
        case subtask(subtaskObj: Subtask)
        case event(eventObj: Event)
    }
    
    static var todayItems: [RecentDataItem] = []
    static var tomorrowItems: [RecentDataItem] = []
    static var futureItems: [RecentDataItem] = []
    
    static func requestRecentData(completion: @escaping (_ result: Result<Void>) -> Void) {
        let dueDateString = (Date().startOf(component: .day) + 7.days).tbISOFormattedString
        let parameters = ["dueDate": dueDateString]
        
        Alamofire.request(RequestRouter.api(path: "api/users/recent", parameters: parameters, method: .get))
            .validate()
            .responseJSON { response in
                if case .success(let info) = response.result, let jsonArray = info as? [[String: Any]] {
                    DispatchQueue.global(qos: .background).async {
                        let processedItems = processServerData(jsonArray)
                        DispatchQueue.main.async {
                            todayItems = processedItems.today
                            tomorrowItems = processedItems.tomorrow
                            futureItems = processedItems.future
                            
                            completion(.success(()))
                        }
                    }
                } else {
                    completion(.failure(TBError(response: response)))
                }
        }
    }
    
    private static func processServerData(_ jsonArray: [[String: Any]]) -> (today: [RecentDataItem], tomorrow: [RecentDataItem], future: [RecentDataItem]) {
        let taskMapper = Mapper<Task>()
        let subtaskMapper = Mapper<Subtask>()
        let eventMapper = Mapper<Event>()
        
        var taskItems: [TaskSortable] = []
        var eventItems: [Event] = []
        
        for jsonObj in jsonArray {
            if let objectType = jsonObj["type"] as? String {
                switch objectType {
                case "task":
                    let task = taskMapper.map(JSON: jsonObj)!
                    taskItems.append(task)
                case "subtask":
                    let subtask = subtaskMapper.map(JSON: jsonObj)!
                    taskItems.append(subtask)
                case "event":
                    let event = eventMapper.map(JSON: jsonObj)!
                    eventItems.append(event)
                default:
                    break
                }
            }
        }
        
        sortTaskSortableInPlace(&taskItems)
        eventItems.sort {
            return ($0.startDate ?? .distantFuture) < ($1.startDate ?? .distantFuture)
        }
        
        let now = Date()
        let endOfToday = now.endOfDay
        let endOfTomorrow = endOfToday + 1.days
        
        var todayItems: [RecentDataItem] = []
        var tomorrowItems: [RecentDataItem] = []
        var futureItems: [RecentDataItem] = []
        
        for taskSortable in taskItems {
            if (taskSortable.startDate != nil && taskSortable.startDate! < endOfToday) || (taskSortable.dueDate != nil && taskSortable.dueDate! < endOfToday) {
                if let task = taskSortable as? Task {
                    todayItems.append(.task(taskObj: task))
                } else if let subtask = taskSortable as? Subtask {
                    todayItems.append(.subtask(subtaskObj: subtask))
                }
            } else if (taskSortable.startDate != nil && taskSortable.startDate! < endOfTomorrow) || (taskSortable.dueDate != nil && taskSortable.dueDate! < endOfTomorrow) {
                if let task = taskSortable as? Task {
                    tomorrowItems.append(.task(taskObj: task))
                } else if let subtask = taskSortable as? Subtask {
                    tomorrowItems.append(.subtask(subtaskObj: subtask))
                }
            } else {
                if let task = taskSortable as? Task {
                    futureItems.append(.task(taskObj: task))
                } else if let subtask = taskSortable as? Subtask {
                    futureItems.append(.subtask(subtaskObj: subtask))
                }
            }
        }
        
        for event in eventItems {
            if let startDate = event.startDate, let endDate = event.endDate {
                if startDate < endOfToday && endDate > now {
                    todayItems.append(.event(eventObj: event))
                } else if startDate.isIn(date: endOfTomorrow, granularity: .day) {
                    tomorrowItems.append(.event(eventObj: event))
                } else if startDate > endOfTomorrow {
                    futureItems.append(.event(eventObj: event))
                }
            }
        }
        
        return (todayItems, tomorrowItems, futureItems)
    }
}

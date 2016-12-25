//
//  ReachabilityManager.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import Alamofire

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    static let statusChanged = Notification.Name(rawValue: "Network Status Changed")
    
    private let _manager = NetworkReachabilityManager(host: "www.teambition.com")!
    
    var status: NetworkReachabilityManager.NetworkReachabilityStatus {
        return _manager.networkReachabilityStatus
    }
    
    private init() {
        _manager.listener = { status in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: ReachabilityManager.statusChanged, object: nil)
            }
        }
    }
    
    func startListening() {
        _manager.startListening()
    }
}

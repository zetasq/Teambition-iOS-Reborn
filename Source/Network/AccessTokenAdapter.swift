//
//  AccessTokenAdapter.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 24/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import Alamofire

final class AccessTokenAdapter: RequestAdapter {
    static let shared = AccessTokenAdapter()
    
    private static let accessTokenKey = "accessTokenKey"
    static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: accessTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: accessTokenKey)
        }
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.invalidAccessToken(_:)), name: TinboxNotification.invalidAccessToken, object: nil)
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let accessToken = AccessTokenAdapter.accessToken {
            urlRequest.setValue("OAuth2 \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
    @objc
    func invalidAccessToken(_ notification: Notification) {
        AccessTokenAdapter.accessToken = nil
    }
}

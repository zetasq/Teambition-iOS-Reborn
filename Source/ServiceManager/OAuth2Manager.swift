//
//  AppSessionManager.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 24/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import Alamofire

final class OAuth2Manager {
    private static let clientID = "bba667f0-ce62-11e5-a5fb-992c6e828910"
    private static let clientSecret = "2ea78589-02cc-4e20-9c1b-19a9726607a3"
    
    static let callBackURL = URL(string: "tinbox://com.zetasq.tinbox/oauth2/code-callback")!
    
    private static var OAuthState: String?
    
    private static func generateOAuthState() -> String {
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = dateFormatter.string(from: now)
        
        return "\(dateString.hashValue ^ clientSecret.hashValue)"
    }
    
    static func generateAuthorizeURL() -> URL {
        let state = generateOAuthState()
        OAuthState = state
        
        let redirect_uri = callBackURL.absoluteString.percentEncodedURI()!
        
        let authorizeURL = try! "\(RequestRouter.tbAccountURLString)/oauth2/authorize?client_id=\(clientID)&redirect_uri=\(redirect_uri)&state=\(state)&lang=\(Language.current.formattedStringForServer)".asURL()
        
        return authorizeURL
    }
    
    static func handleOAuthCallback(url: URL) {
        var parameters: [String: String] = [:]
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let queryItems = urlComponents?.queryItems {
            for queryItem in queryItems {
                parameters[queryItem.name] = queryItem.value
            }
        }
        
        guard let state = parameters["state"], state == OAuthState else {
            return
        }
        
        OAuthState = nil
        
        if let token = parameters["access_token"] {
            AccessTokenAdapter.accessToken = token
            NotificationCenter.default.post(name: TinboxNotification.accessTokenFetched, object: nil)
            return
        }
        
        guard let code = parameters["code"] else {
            NotificationCenter.default.post(name: TinboxNotification.accessTokenRequestFailed, object: nil)
            return
        }
        
        requestAccessToken(authorizeCode: code)
    }
    
    private static func requestAccessToken(authorizeCode code: String) {
        let parameters = ["client_id": clientID,
                          "client_secret": clientSecret,
                          "code": code,
                          "grant_type": "code"]
        Alamofire.request(RequestRouter.account(path: "oauth2/access_token", parameters: parameters, method: .post))
            .validate()
            .responseJSON { response in
                if case .success(let info) = response.result, let jsonDic = info as? [String: Any], let token = jsonDic["access_token"] as? String {
                    AccessTokenAdapter.accessToken = token
                    NotificationCenter.default.post(name: TinboxNotification.accessTokenFetched, object: nil)
                } else {
                    NotificationCenter.default.post(name: TinboxNotification.accessTokenRequestFailed, object: nil)
                }
        }
    }
}


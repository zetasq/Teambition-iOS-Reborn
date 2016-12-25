//
//  TBError.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import Alamofire

struct TBError: Error {
    let name: String?
    let message: String?
    let rawError: Error?
    
    var localizedDescription: String {
        return message ?? rawError?.localizedDescription ?? ""
    }
    
    init(response: DataResponse<Any>) {
        guard let data = response.data else {
            name = nil
            message = nil
            rawError = nil
            
            return
        }
        
        let jsonDic = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
        
        name = jsonDic?["name"] as? String
        message = jsonDic?["message"] as? String
        rawError = response.result.error
        
        if name == "InvalidAccessToken" {
            NotificationCenter.default.post(name: TinboxNotification.invalidAccessToken, object: nil)
        }
    }
}

//
//  RequestRouter.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 24/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import Alamofire

enum RequestRouter: URLRequestConvertible {
    static let tbAccountURLString = "https://account.teambition.com"
    static let tbAPIURLString = "https://api.teambition.com"
    
    case account(path: String, parameters: Parameters, method: HTTPMethod)
    case api(path: String, parameters: Parameters, method: HTTPMethod)
    
    func asResult() -> (path: String, parameters: Parameters, method: HTTPMethod) {
        switch self {
        case .account(let path, let parameters, let method):
            return (path, parameters, method)
        case .api(let path, let parameters, let method):
            return (path, parameters, method)
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let result = asResult()
        
        let url = asURL().appendingPathComponent(result.path)
        let headers = ["Accept-Language": Language.current.formattedStringForServer]
        let urlRequest = try URLRequest(url: url, method: result.method, headers: headers)
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}

extension RequestRouter: URLConvertible {
    func asURL() -> URL {
        switch self {
        case .account:
            return try! RequestRouter.tbAccountURLString.asURL()
        case .api:
            return try! RequestRouter.tbAPIURLString.asURL()
        }
    }
}

//
//  String+Extension.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation

extension String {
    func percentEncodedURI() -> String? {
        let allowedCharacterSet =  CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
    
    func toNotification() -> Notification.Name {
        return Notification.Name(rawValue: self)
    }
}

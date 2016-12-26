//
//  Date+Extension.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 27/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation
import ObjectMapper

extension DateFormatter {
    static let tbISODateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(secondsFromGMT: 0)!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        return formatter
    }()
}

extension Date {
    var tbISOFormattedString: String {
        return DateFormatter.tbISODateFormatter.string(from: self)
    }
}

struct TBDateTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let dateString = value as? String else {
            return nil
        }
        
        return DateFormatter.tbISODateFormatter.date(from: dateString)
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let date = value else {
            return nil
        }
        
        return DateFormatter.tbISODateFormatter.string(from: date)
    }
}


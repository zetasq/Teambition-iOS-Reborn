//
//  Language.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation

enum Language: String, CustomStringConvertible {
    case English = "en"
    case SimplifiedChinese = "zh-Hans"
    case TraditionalChinese = "zh-Hant"
    
    var description: String {
        switch self {
        case .English:
            return "English"
        case .SimplifiedChinese:
            return "简体中文"
        case .TraditionalChinese:
            return "繁體中文"
        }
    }
    
    var formattedStringForServer: String {
        switch self {
        case .English:
            return "en"
        case .SimplifiedChinese:
            return "zh"
        case .TraditionalChinese:
            return "zh_tw"
        }
    }
    
    private static let currentLanguageKey = "currentLanguageKey"
    
    static var current: Language = _current {
        didSet {
            _current = current
        }
    }
    
    private static var _current: Language {
        get {
            if let langString = UserDefaults.standard.string(forKey: currentLanguageKey), let lang = Language(rawValue: langString) {
                return lang
            } else {
                let preferredLanguages = Locale.preferredLanguages
                let matchedLanguages = preferredLanguages.map { preferredLanguage -> String in
                    switch preferredLanguage {
                    case let lang where lang.hasPrefix(Language.English.rawValue):
                        return Language.English.rawValue
                    case let lang where lang.hasPrefix(Language.SimplifiedChinese.rawValue):
                        return Language.SimplifiedChinese.rawValue
                    case let lang where lang.hasPrefix(Language.TraditionalChinese.rawValue):
                        return Language.TraditionalChinese.rawValue
                    default:
                        return ""
                    }
                }.filter { !$0.isEmpty }
                
                let lang = Language(rawValue: matchedLanguages.first ?? Language.English.rawValue) ?? .English
                UserDefaults.standard.set(lang.rawValue, forKey: currentLanguageKey)
                
                return lang
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: currentLanguageKey)
        }
    }
}

//
//  TinboxNotification.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation

final class TinboxNotification {
    static let accessTokenFetched = "accessTokenFetched".toNotification()
    static let accessTokenRequestFailed = "accessTokenRequestFailed".toNotification()
    static let invalidAccessToken = "invalidAccessToken".toNotification()
}

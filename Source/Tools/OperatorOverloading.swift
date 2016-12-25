//
//  OperatorOverloading.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import Foundation

// MARK: - Compare Bools
func >(lhs: Bool, rhs: Bool) -> Bool {
    if case (true, false) = (lhs, rhs) {
        return true
    } else {
        return false
    }
}

func <(lhs: Bool, rhs: Bool) -> Bool {
    return rhs > lhs
}


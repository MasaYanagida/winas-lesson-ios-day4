//
//  MyPreference.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import Foundation

import SwiftyUserDefaults
import KeychainAccess

// MARK: - MyPreference

class MyPreference: NSObject {
    static let shared = MyPreference()
}

extension DefaultsKeys {
    static let isFirstLaunch = DefaultsKey<Bool>("isFirstLaunch", defaultValue: true)
}

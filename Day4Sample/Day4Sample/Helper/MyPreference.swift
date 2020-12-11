//
//  MyPreference.swift
//  Day4Sample
//
//  Created by 柳田昌弘 on 2020/12/07.
//

import Foundation

import SwiftyUserDefaults
import KeychainAccess

// MARK: - MyPreference

class MyPreference: NSObject {
    static let shared = MyPreference()
    
    private let userIdKey: String = "com.winas-lesson.ios.day4.Day4Sample.userId"
    var userId: String {
        set {
            let keychain = Keychain()
            keychain[userIdKey] = newValue
        }
        get {
            let keychain = Keychain()
            if let userId = keychain[userIdKey] {
                return userId
            } else {
                return ""
            }
        }
    }
    
    var isFirstLaunch: Bool {
        set {
            Defaults[.isFirstLaunch] = newValue
        }
        get {
            return Defaults[.isFirstLaunch]
        }
    }
}

extension DefaultsKeys {
    static let isFirstLaunch = DefaultsKey<Bool>("isFirstLaunch", defaultValue: true)
}

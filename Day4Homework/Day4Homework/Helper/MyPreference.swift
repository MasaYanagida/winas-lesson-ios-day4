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
    var userIdKey: String?
    var userPasswordKey: String?
    
    var userId: String {
        set {
            let keychain = Keychain()
            keychain[userIdKey ?? ""] = newValue
        }
        get {
            let keychain = Keychain()
            if let userId = keychain[userIdKey ?? ""] {
                return userId
            } else {
                return ""
            }
        }
    }
    var userPassword: String {
        set {
            let keychain = Keychain()
            keychain[userPasswordKey ?? ""] = newValue
        }
        get {
            let keychain = Keychain()
            if let userPassword = keychain[userPasswordKey ?? ""] {
                return userPassword
            } else {
                return ""
            }
        }
    }
}

extension DefaultsKeys {
    static let isFirstLaunch = DefaultsKey<Bool>("isFirstLaunch", defaultValue: true)
}

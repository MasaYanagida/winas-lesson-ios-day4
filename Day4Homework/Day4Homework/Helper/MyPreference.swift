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
    var passwordKey: String?
    
    var userIdDefaults: String {
        set {
            Defaults[.userIdDefaults] = newValue
        }
        get {
            return Defaults[.userIdDefaults]
        }
    }
    
    var passwordDefaults: String {
        set {
            Defaults[.passwordDefaults] = newValue
        }
        get {
            return Defaults[.passwordDefaults]
        }
    }
    
    var userIdKeychain: String {
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
    
    var passwordKeychain: String {
        set {
            let keychain = Keychain()
            keychain[passwordKey ?? ""] = newValue
        }
        get {
            let keychain = Keychain()
            if let userId = keychain[passwordKey ?? ""] {
                return userId
            } else {
                return ""
            }
        }
    }
}

extension DefaultsKeys {
    static let isFirstLaunch = DefaultsKey<Bool>("isFirstLaunch", defaultValue: true)
    static let userIdDefaults = DefaultsKey<String>("userIdDefaults", defaultValue: "")
    static let passwordDefaults = DefaultsKey<String>("passwordDefaults", defaultValue: "")
}

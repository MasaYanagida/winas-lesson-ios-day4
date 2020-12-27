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
    
    let userIdKey = "winas.user.id"
    let passwordKey = "winas.password.id"
    
    // Keychain Storage
    var userIdInKeychain: String {
        get {
            let keychain = Keychain()
            guard let userId = keychain[userIdKey] else {
                return ""
            }
            return userId
        }
        set {
            let keychain = Keychain()
            keychain[userIdKey] = newValue
        }
    }
    
    var passwordInKeychain: String {
        get {
            let keychain = Keychain()
            guard let userId = keychain[passwordKey] else {
                return ""
            }
            return userId
        }
        set {
            let keychain = Keychain()
            keychain[passwordKey] = newValue
        }
    }
    
    // Defaults Storage
    var userIdInDefaults: String {
        get { return Defaults[.userIdInDefaults] }
        set { Defaults[.userIdInDefaults] = newValue }
    }
    
    var passwordInDefaults: String {
        get { return Defaults[.passwordInDefaults] }
        set { Defaults[.passwordInDefaults] = newValue }
    }
    
    var isFirstLaunch: Bool {
        get { return Defaults[.isFirstLaunch] }
        set { Defaults[.isFirstLaunch] = newValue }
    }
}

extension DefaultsKeys {
    static let isFirstLaunch = DefaultsKey<Bool>("isFirstLaunch", defaultValue: true)
    static let userIdInDefaults = DefaultsKey<String>("userIdInDefaults", defaultValue: "")
    static let passwordInDefaults = DefaultsKey<String>("passwordInDefaults", defaultValue: "")
}

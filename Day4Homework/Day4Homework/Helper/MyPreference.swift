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
    
    private let userIdKey: String = "com.winas-lesson.ios.day4.Day4Homework.userId"
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
    private let passwordKey: String = "com.winas-lesson.ios.day4.Day4Homework.password"
    var password: String {
        set {
            let keychain = Keychain()
            keychain[passwordKey] = newValue
        }
        get {
            let keychain = Keychain()
            if let password = keychain[passwordKey] {
                return password
            } else {
                return ""
            }
        }
    }
    
    var userIdPref: String {
        set {
            Defaults[.userIdPref] = newValue
        }
        get { return Defaults[.userIdPref] }
    }
    var passwordPref: String {
        set {
            Defaults[.passwordPref] = newValue
        }
        get { return Defaults[.passwordPref] }
    }
}

extension DefaultsKeys {
    static let userIdPref = DefaultsKey<String>("userIdPref", defaultValue: "")
    static let passwordPref = DefaultsKey<String>("passwordPref", defaultValue: "")
}

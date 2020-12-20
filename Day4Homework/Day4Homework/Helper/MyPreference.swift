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
    private let userIdKeychain: String = "com.winas-lesson.ios.day4.Day4Homework.userId"
    private let passwordKeychain: String = "com.winas-lesson.ios.day4.Day4Homework.password"
    
    var userId: String? {
        set {
            Defaults[.userId] = newValue
        }
        get {
            return Defaults[.userId]
        }
    }
    
    var password: String?{
        set{
            Defaults[.password] = newValue
        }
        get{
            return Defaults[.password]
        }
        
    }
    
    var userIdKey: String?{
        set{
            let keychain = Keychain()
            keychain[userIdKeychain] = newValue
        }
        get{
            let keychain = Keychain()
            if let userId = keychain[userIdKeychain]{
                return userId
            }else{
                return ""
            }
        }
    }
    
    var passwordKey : String?{
        set{
            let keychain = Keychain()
            keychain[passwordKeychain] = newValue
        }
        get{
            let keychain = Keychain()
            if let password = keychain[passwordKeychain]{
                return password
            }else{
                return ""
            }
        }
    }
    
    var isFirstLaunch : Bool {
        set{
            Defaults[.isFirstLaunch] = newValue
        }
        get{
            return Defaults[.isFirstLaunch]
        }
    }
    
}

extension DefaultsKeys {
    static let userId = DefaultsKey<String?>("userId")
    static let password = DefaultsKey<String?>("password")
    static let isFirstLaunch = DefaultsKey<Bool>("isFirstLaunch", defaultValue: true)
}

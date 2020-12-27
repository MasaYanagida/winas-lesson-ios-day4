//
//  Account.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import Foundation
import RealmSwift

// MARK: Account

class Account: Object {
    
    @objc dynamic var userId: String = ""
    @objc dynamic var password: String = ""
    
    override class func primaryKey() -> String? {
        return "userId"
    }
    
    
    static func create(_ userId: String, with password: String) -> Account {
        let account = Account()
        account.userId = userId
        account.password = password
        return account
    }
    
    static func store(_ userId: String, with password: String) {
        RealmService.shared.delete(dataType: Account.self)
        RealmService.shared.add(object: create(userId, with: password))
    }
    
    static func fetchAccountInfo() -> Results<Account> {
        return RealmService.shared.fetch(dataType: Account.self)
    }
    
}

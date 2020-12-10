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
    @objc dynamic var id: String = ""
    @objc dynamic var password: String = ""
}

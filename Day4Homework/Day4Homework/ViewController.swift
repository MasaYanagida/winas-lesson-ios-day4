//
//  ViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit
import RealmSwift
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let realm = try! Realm()
    @IBOutlet private dynamic weak var idField: UITextField!
    @IBOutlet private dynamic weak var passwordField: UITextField!
    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        
        // TODO : save ID&Password into UserDefaults, Keychain and Realm(Models/Account.swift)
        
        let userId = idField.text ?? ""
        let password = passwordField.text ?? ""
        
        saveByUserDefaults(userId, password)
        saveByKeychain(userId, password)
        saveByRealm(userId, password)
        
        let controller = ContentsViewController.fromStoryboard()
        self.swapRootViewController(to: controller)
    }
    
    private func saveByUserDefaults(_ userId: String,_ password: String) {
        let myPreference = MyPreference.shared
        myPreference.userIdDefaults = userId
        myPreference.passwordDefaults = password
    }
    
    private func saveByKeychain(_ userId: String, _ password: String) {
        let myPreference = MyPreference.shared
        myPreference.userIdKeychain = userId
        myPreference.passwordKeychain = password
    }
    
    private func saveByRealm(_ userId: String, _ password: String) {
        let account = Account()
        account.id = userId
        account.password = password
        try! realm.write {
            realm.add(account)
        }
    }
}


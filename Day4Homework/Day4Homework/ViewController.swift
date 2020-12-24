//
//  ViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet private dynamic weak var idField: UITextField!
    @IBOutlet private dynamic weak var passwordField: UITextField!
    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        // save ID&Password into UserDefaults, Keychain and Realm(Models/Account.swift)
        let userId = idField.text ?? ""
        let password = passwordField.text ?? ""
        
        // 1: UserDefaults
        MyPreference.shared.userIdPref = userId
        MyPreference.shared.passwordPref = password
        
        // 2: Keychain
        MyPreference.shared.userId = userId
        MyPreference.shared.password = password
        
        // 3: Realm
        do {
            let realm = try Realm()
            let oldObjects = realm.objects(Account.self)
            try realm.write {
                // 1. delete all existing objects in advance
                realm.delete(oldObjects)
                // 2. create
                realm.create(Account.self, value: [userId, password])
            }
        } catch let error {
            // ignore errors
        }
        
        let controller = ContentsViewController.fromStoryboard()
        self.swapRootViewController(to: controller)
    }
}


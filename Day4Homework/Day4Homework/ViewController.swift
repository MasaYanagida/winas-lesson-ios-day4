//
//  ViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private dynamic weak var idField: UITextField!
    @IBOutlet private dynamic weak var passwordField: UITextField!
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        
        guard let userId = idField.text, let password = passwordField.text else { return }
        self.storeInfo(userId: userId, password: password)
        
        let controller = ContentsViewController.fromStoryboard()
        self.swapRootViewController(to: controller)
    }
    
    private func storeInfo(userId: String, password: String) {
        
        // 1: User Defaults
        MyPreference.shared.userIdInDefaults = userId
        MyPreference.shared.passwordInDefaults = password
        
        // 2: Keychain
        MyPreference.shared.userIdInKeychain = userId
        MyPreference.shared.passwordInKeychain = password
        
        // 3: Realm
        Account.store(userId, with: password)
    }
}


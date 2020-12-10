//
//  ViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet private dynamic weak var idField: UITextField!
    @IBOutlet private dynamic weak var passwordField: UITextField!
    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        
        // TODO : save ID&Password into UserDefaults, Keychain and Realm(Models/Account.swift)
        
        let controller = ContentsViewController.fromStoryboard()
        self.swapRootViewController(to: controller)
    }
}


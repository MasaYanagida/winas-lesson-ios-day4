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
        
        // TODO : save ID&Password into UserDefaults, Keychain and Realm(Models/Account.swift)
        MyPreference.shared.userId = idField.text
        MyPreference.shared.password = passwordField.text
        MyPreference.shared.userIdKey = idField.text
        MyPreference.shared.passwordKey = passwordField.text
        
        
        //showAlert("retireve userIDkey from keychain is \(MyPreference.shared.userIdKey)")
        
        do {
            let realm = try Realm()
            try realm.write{
                let account = Account()
                account.name = idField.text!
                account.password = passwordField.text!
                realm.add(account)
            }         
        } catch let error {
            showAlert("Realm error: desc= \(error.localizedDescription)")
        }
        
        
        let controller = ContentsViewController.fromStoryboard()
        self.swapRootViewController(to: controller)
        
        
    }
    
   
       // do {
       //            let realm = try Realm()
       //            let oldObjects = realm.objects(Content.self)
       //            try realm.write {
       //                // 1. delete all existing objects in advance
       //                realm.delete(oldObjects)
       //
       //                // 2. create
       //                for _ in 0 ..< 10 {
       //                    let sample = Content.create()
       //                    realm.create(Content.self, value: [sample.id, sample.name, sample.address, sample.genderId])
       //                }
       //
       //                // 3. select
       //                contents = []
       //                realm.objects(Content.self).forEach { data in
       //                    contents.append(data)
       //                }
       //                tableView.reloadData()
       //            }
       //        } catch let error {
       //            showAlert("Realm error: desc= \(error.localizedDescription)")
       //        }
       //}

    private func showAlert(_ message: String){
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}



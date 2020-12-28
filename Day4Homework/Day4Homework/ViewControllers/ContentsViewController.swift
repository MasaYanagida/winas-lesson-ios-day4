//
//  ContentsViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit
import RealmSwift
import SwiftyJSON
import ObjectMapper

// MARK: ContentsViewController

class ContentsViewController: UIViewController {
    
    @IBOutlet fileprivate dynamic weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var contents = [Content]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCache()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadFromServer()
        }
        
    }
    
    @IBAction private func reloadButtonTouchUpInside(_ sender: UIButton) {
    }
    @IBAction private func accountButtonTouchUpInside(_ sender: UIButton) {
        let myPreference = MyPreference.shared
        let alertController = UIAlertController(title: "アカウント情報を取得", message: "保管先を選択してください", preferredStyle: .actionSheet)
        let userDefaultAction = UIAlertAction(title: "UserDefaults", style: .default) {_ in
            let userId = myPreference.userIdDefaults
            let password = myPreference.passwordDefaults
            self.showAlert("UserDefaultsに保存したIDは\(userId)、パスワードは\(password)です")
        }
        let keyChainAction = UIAlertAction(title: "Keychain", style: .default) {_ in
            let userId = myPreference.userIdKeychain
            let password = myPreference.passwordKeychain
            self.showAlert("Keychainに保存したIDは\(userId)、パスワードは\(password)です")
        }
        let realmAction = UIAlertAction(title: "Realm", style: .default) {_ in
            let account = self.realm.objects(Account.self).last
            self.showAlert("Realmに保存したIDは\(account?.id ?? "")、パスワードは\(account?.password ?? "")です")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(userDefaultAction)
        alertController.addAction(keyChainAction)
        alertController.addAction(realmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func loadFromCache() {
        do {
            contents = []
            let realm = try Realm()
            try realm.write
            {
                realm.objects(Content.self).forEach { data in
                    contents.append(data)
                }
            }
            tableView.reloadData()
        } catch _ {
        }
    }

    private func loadFromServer() {
        Service.content.getList(
            completion: { [weak self] items in
                guard let `self` = self else { return }
                
                do {
                    let realm = try Realm()
                    let oldObjects = realm.objects(Content.self)
                    try realm.write {
                        realm.delete(oldObjects)
                        items.forEach { content in
                            realm.create(Content.self, value: [content.id, content.name, content.address, content.genderId])
                        }
 
                    self.contents = items
                    self.tableView.reloadData()
                    }
                } catch _ {
                }
            },
            failure: { _, _ in
            }
        )
    }
    
    private func showAlert(_ message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
}

// MARK: - StoryboardInstantiable

extension ContentsViewController: StoryboardInstantiable {
    static var storyboardName: String {
        return String(describing: self)
    }
}

extension ContentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contents[indexPath.row]
        let cell = UITableViewCell()
        cell.selectionStyle = .gray
        cell.textLabel?.text = content.name
        return cell
    }

}

extension ContentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let content = contents[indexPath.row]
        let controller = UIAlertController.init(title: "", message: "\(content.name)です", preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

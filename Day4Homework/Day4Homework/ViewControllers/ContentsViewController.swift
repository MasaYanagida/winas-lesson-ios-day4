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
            // TODO
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var contents = [Content]()
    let realm = try! Realm()
    var id = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults()
        realmSetting()
        keyChainSetting()
        loadFromCache()
        loadFromServer()
    }
    
    @IBAction private func reloadButtonTouchUpInside(_ sender: UIButton) {
        // TODO : reload `contents` from server
        loadFromServer()
    }
    @IBAction private func accountButtonTouchUpInside(_ sender: UIButton) {
        // TODO : show ID&Password from options
        let userDefaultID = UserDefaults.standard.string(forKey: "id")
        let userDefaultPassword = UserDefaults.standard.string(forKey: "password")
        let realmData = realm.objects(Account.self).last
        let keyChainData = MyPreference.shared
        let alertController = UIAlertController(title: "アカウント情報を取得", message: "保管先を選択してください", preferredStyle: .actionSheet)
        let userDefaultAction = UIAlertAction(title: "UserDefaults", style: .default) {_ in
            self.showAlert("UserDefaultsに保存したIDは\(userDefaultID ?? "")、パスワードは\(userDefaultPassword ?? "")です")
        }
        let keyChainAction = UIAlertAction(title: "Keychain", style: .default) {_ in
            self.showAlert("Keychainに保存したIDは\(keyChainData.userIdKey ?? "")、パスワードは\(keyChainData.userPasswordKey ?? "")です")
        }
        let realmAction = UIAlertAction(title: "Realm", style: .default) {_ in
            self.showAlert("Realmに保存したIDは\(realmData?.id ?? "")、パスワードは\(realmData?.password ?? "")です")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(userDefaultAction)
        alertController.addAction(keyChainAction)
        alertController.addAction(realmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ContentsViewController {
    
    private func userDefaults() {
        UserDefaults.standard.setValue(id, forKey: "id")
        UserDefaults.standard.setValue(password, forKey: "password")
    }
    
    private func realmSetting() {
        let account = Account()
        account.id = id
        account.password = password
        try! realm.write {
            realm.add(account)
        }
    }
    
    private func keyChainSetting() {
        MyPreference.shared.userIdKey = id
        MyPreference.shared.userPasswordKey = password
    }
    private func showAlert(_ message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    private func loadFromCache() {
        do {
            contents = []
            let realm = try Realm()
            try realm.write {
                // select
                realm.objects(Content.self).forEach { data in
                    contents.append(data)
                }
            }
            tableView.reloadData()
        } catch let error {
            showAlert("loadFromCache error: desc= \(error.localizedDescription)")
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
                        // 1. delete all existing objects in advance
                        realm.delete(oldObjects)
                        // 2. create
                        items.forEach { content in
                            realm.create(Content.self, value: [content.id, content.name, content.address, content.genderId])
                        }
                        self.contents = items
                        debugPrint("papapa \(self.contents)")
                        self.tableView.reloadData()
                    }
                    self.showAlert("LoadFromServer Complete!!")
                } catch let error {
                    self.showAlert("Realm error: desc= \(error.localizedDescription)")
                }
            },
            failure: { _, _ in
                // TODO : error handling
            })
    }
}

extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let content = contents[indexPath.row]
        let controller = UIAlertController.init(title: "選択したセル", message: content.description, preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - StoryboardInstantiable

extension ContentsViewController: StoryboardInstantiable {
    static var storyboardName: String {
        return String(describing: self)
    }
}

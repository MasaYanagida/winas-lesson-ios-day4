//
//  ContentsViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit
import RealmSwift

// MARK: ContentsViewController

class ContentsViewController: UIViewController {
    
    @IBOutlet fileprivate dynamic weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var contents = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCache()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
            self?.loadFromServer()
        })
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
        Service.content.getList(completion: { [weak self] items in
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
                    // 3. select
                    self.contents = []
                    realm.objects(Content.self).forEach { data in
                        self.contents.append(data)
                    }
                    self.tableView.reloadData()
                }
                self.showAlert("LoadFromServer Complete!!")
            } catch let error {
                self.showAlert("Realm error: desc= \(error.localizedDescription)")
            }
        },
        failure: nil)
    }
    
    @IBAction private func reloadButtonTouchUpInside(_ sender: UIButton) {
        // reload `contents` from server
        loadFromServer()
    }
    
    @IBAction private func accountButtonTouchUpInside(_ sender: UIButton) {
        // show ID&Password from options
        let controller = UIAlertController(title: "アカウント情報の取得", message: "保管先を選択してください", preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "UserDefaults", style: .default, handler: { action in
            self.dismiss(animated: true, completion: { [weak self] in
                self?.showAlert("UserDefaultsに保存したIDは\(MyPreference.shared.userIdPref)、パスワードは\(MyPreference.shared.passwordPref)です")
            })
        }))
        controller.addAction(UIAlertAction(title: "Keychain", style: .default, handler: { action in
            self.dismiss(animated: true, completion: { [weak self] in
                self?.showAlert("Keychainに保存したIDは\(MyPreference.shared.userId)、パスワードは\(MyPreference.shared.password)です")
            })
        }))
        controller.addAction(UIAlertAction(title: "Realm", style: .default, handler: { action in
            self.dismiss(animated: true, completion: { [weak self] in
                do {
                    let realm = try Realm()
                    var account: Account? = nil
                    realm.objects(Account.self).forEach { data in
                        account = data
                    }
                    if let account = account {
                        self?.showAlert("Realmに保存したIDは\(account.id)、パスワードは\(account.password)です")
                    } else {
                        self?.showAlert("Realmからのアカウント取得に失敗しました")
                    }
                } catch let error {
                    self?.showAlert("Realmからのアカウント取得に失敗しました")
                }
            })
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    private func showAlert(_ message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

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

// MARK: - UITableViewDelegate

extension ContentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

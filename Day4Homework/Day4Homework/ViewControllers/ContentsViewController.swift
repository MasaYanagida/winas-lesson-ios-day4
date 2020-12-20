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
            // TODO
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
        }
    }
    public var contents = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCache()
        loadFromServer()
    }
    
    @IBAction private func reloadButtonTouchUpInside(_ sender: UIButton) {
        // TODO : reload `contents` from server
        loadFromServer()
    }
    @IBAction private func accountButtonTouchUpInside(_ sender: UIButton) {
        // TODO : show ID&Password from options
        
        // 1 . UIAlertControllerクラスのインスタンス生成
        let alertController = UIAlertController(title: nil, message: "選択してください", preferredStyle: .actionSheet)
        // 2. アラート表示内容
        let userDefaultAction : UIAlertAction = UIAlertAction(title: "UserDefaults", style: .default, handler: { [self]
            (action: UIAlertAction!) -> Void in
            showAlert("userid : \(MyPreference.shared.userId!)\n password : \(MyPreference.shared.password!)")
        })
        let keyChainAction : UIAlertAction = UIAlertAction(title: "KeyChain", style: .default, handler: {
            [self](action : UIAlertAction!) -> Void in
            showAlert("userid : \(MyPreference.shared.userIdKey!) \n password : \(MyPreference.shared.passwordKey!)")
        })

        alertController.addAction(userDefaultAction)
        alertController.addAction(keyChainAction)

        
        
        do {
            let realm = try Realm()
            let realmAction : UIAlertAction = UIAlertAction(title: "Realm", style: .default, handler: {
                [self](action : UIAlertAction!) -> Void in
                let account = Account()
                let userRealm = realm.objects(Account.self).forEach { (userRealm) in
                    showAlert("userid : \(userRealm.name) \n password : \(userRealm.password)")
                }
             })
            alertController.addAction(realmAction)
        } catch let error {
                showAlert("Realm error: desc= \(error.localizedDescription)")
        }
        
        
        present(alertController, animated: true, completion: nil)
//            presentViewController(alert, animated: true, completion: nil)


    }
    
    private func loadFromCache(){
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
        } catch let error {
            showAlert("loadFromCache error: desc= \(error.localizedDescription)")
        }
    }
    
    private func loadFromServer(){
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
                        // 3. select
//                        self.contents = []
//                        realm.objects(Content.self).forEach { data in
//                            self.contents.append(data)
//                        }
                        self.contents = items
                        self.tableView.reloadData()
                    }
                    self.showAlert("LoadFromServer Complete!!")
                } catch let error {
                    self.showAlert("Realm error: desc= \(error.localizedDescription)")
                }
            },
            failure: { _, _ in
                // TODO : error handling
            }
        )
    }
    
    private func showAlert(_ message: String){
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

// MARK: UITableViewDataSource

extension ContentsViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
        cell.selectionStyle = .gray
        cell.content = contents[indexPath.row]
        //print(contents[indexPath.row])
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
        let controller = UIAlertController.init(title: "選択したセル", message: "選択した名前は\(content.name)です", preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

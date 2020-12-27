//
//  ContentsViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import RealmSwift

// MARK: ContentsViewController

class ContentsViewController: UIViewController {
    
    // Alert Action Type
    enum AlertActionType {
        case userDefaults
        case keychain
        case realmDB
    }
    
    @IBOutlet fileprivate dynamic weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var contents: Results<Content> = Content.fetchContent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realodData(isFromServer: false) { [weak self] in
            guard let `self` = self else { return }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBActions
    @IBAction private func reloadButtonTouchUpInside(_ sender: UIButton) {
        realodData(isFromServer: true) { [weak self] in
            guard let `self` = self else { return }
            self.tableView.reloadData()
        }
    }
    
    @IBAction private func accountButtonTouchUpInside(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Account Information", message: "Please select location", preferredStyle: .actionSheet)
        
        let defaultAction = setAction(for: .userDefaults)
        let keychainAction = setAction(for: .keychain)
        let realmAction = setAction(for: .realmDB)
        
        alertController.addAction(defaultAction)
        alertController.addAction(keychainAction)
        alertController.addAction(realmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func setAction(for actionType: AlertActionType) -> UIAlertAction {
        
        var actionTitle: String = ""
        var userId: String = ""
        var password: String = ""
        
        switch actionType {
            case .userDefaults:
                actionTitle = "Defaults"
                userId = MyPreference.shared.userIdInDefaults
                password = MyPreference.shared.passwordInDefaults
            case .keychain:
                actionTitle = "Keychain"
                userId = MyPreference.shared.userIdInKeychain
                password = MyPreference.shared.passwordInKeychain
            case .realmDB:
                actionTitle = "Realm"
                if let accountInfo = Account.fetchAccountInfo().first {
                    userId = accountInfo.userId
                    password = accountInfo.password
                }
        }
        
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] action in
            guard let `self` = self else { return }
            self.dismiss(animated: true) { [weak self] in
                guard let `self` = self else { return }
                self.showAlert("Username: \(userId)\nPassword: \(password)")
            }
        }
        return action
    }
    
    fileprivate func showAlert(_ message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    
    fileprivate func realodData(isFromServer: Bool = false, completation: @escaping () -> Void) {
        if MyPreference.shared.isFirstLaunch {
            if let path = Bundle.main.path(forResource: "master-list", ofType: "json") {
                do {
                    let fileContent = try String(contentsOfFile: path)
                    let parsedJson = JSON(parseJSON: fileContent)
                    guard let mappedObject = Mapper<Content>().mapArray(JSONObject: parsedJson.arrayObject) else { return }
                    // Cache data
                    Content.store(content: mappedObject)
                    MyPreference.shared.isFirstLaunch = false
                    completation()
                } catch let error {
                    print("parse error: \(error.localizedDescription)")
                }
            } else {
                print("Invalid filename/path.")
            }
            
        } else if isFromServer {
            Service.content.getList(completion: { data in
                Content.store(content: data)
                completation()
            }, failure: nil)
        } else {
            completation()
        }
    }
}

// MARK: - Tableview data source
extension ContentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        cell.selectionStyle = .gray
        cell.textLabel?.text = content.name
        cell.detailTextLabel?.text = content.address
        return cell
    }
    
}

// MARK: - Tableview data source
extension ContentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - StoryboardInstantiable

extension ContentsViewController: StoryboardInstantiable {
    static var storyboardName: String {
        return String(describing: self)
    }
}

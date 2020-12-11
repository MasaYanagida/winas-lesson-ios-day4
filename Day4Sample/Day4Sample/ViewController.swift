//
//  ViewController.swift
//  Day4Sample
//
//  Created by 柳田昌弘 on 2020/12/07.
//

import UIKit
import RealmSwift
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController {
    
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
    
    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        // reload
        loadFromServer()
        
//        showAlert("isFirstLaunch: \(MyPreference.shared.isFirstLaunch)")
//        if MyPreference.shared.isFirstLaunch {
//            MyPreference.shared.isFirstLaunch = false
//        }
        
//        if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") {
//            let plist = NSDictionary(contentsOfFile: filePath)
//            showAlert("Custom ID is: \(plist?["CustomStringIdentifier"] as? String ?? "nil!!")")
//        }
        
//        MyPreference.shared.userId = randomValue(["winas1", "winas2", "winas3", "winas4"])
//        showAlert("userId from Keychain: \(MyPreference.shared.userId)")
        
//        do {
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
        
//        if let filePath = Bundle.main.path(forResource: "sample-text", ofType: "txt"),
//           let fileContents = try? String(contentsOfFile: filePath) {
//            showAlert("LocalFile contents= \(fileContents)")
//        } else {
//            showAlert("Local File load error")
//        }
        
//        _ = SampleNetwork.request(
//            target: .getStatic,
//            success: { content, _ in
//                guard let safeContent = content else { return }
//                // run in main => UI thread
//                DispatchQueue.main.async { [weak self] in
//                    self?.showAlert(safeContent)
//                }
//            },
//            error: { /*statusCode*/_ in
//                // do nothing
//            },
//            failure: { /*error*/_ in
//                // do nothing
//            })
        
        // ローカルファイル ＋ Single
//        if let filePath = Bundle.main.path(forResource: "sample-single", ofType: "json"),
//           let fileContents = try? String(contentsOfFile: filePath) {
//            do {
//                let json = try JSON(parseJSON: fileContents)
//                if let data = Mapper<Content>().map(JSONObject: json.dictionaryObject) {
//                    showAlert("🎉LocalFile single data is \(data.description)")
//                } else {
//                    showAlert("⚠️LocalFile mapping error")
//                }
//            } catch {
//                showAlert("⚠️Local File read error")
//            }
//        } else {
//            showAlert("⚠️Local File load error")
//        }
        
        // ローカルファイル ＋ List
//        if let filePath = Bundle.main.path(forResource: "sample-list", ofType: "json"),
//           let fileContents = try? String(contentsOfFile: filePath) {
//            do {
//                let json = try JSON(parseJSON: fileContents)
//                if let dataArray = Mapper<Content>().mapArray(JSONObject: json.arrayObject) {
//                    contents = dataArray
//                    tableView.reloadData()
//                } else {
//                    showAlert("⚠️LocalFile mapping error")
//                }
//            } catch {
//                showAlert("⚠️Local File read error")
//            }
//        } else {
//            showAlert("⚠️Local File load error")
//        }
        
        // サーバ通信 ＋ Single
//        _ = SampleNetwork.request(
//            target: .getSingle,
//            success: { json, _ in
//                guard let safeJson = json else { return }
//                // run in main => UI thread
//                DispatchQueue.main.async { [weak self] in
//                    if let data = Mapper<Content>().map(JSONObject: safeJson.dictionaryObject) {
//                        self?.showAlert("🎉ServerAPI single data is \(data.description)")
//                    } else {
//                        self?.showAlert("⚠️ServerAPI mapping error")
//                    }
//                }
//            },
//            error: { /*statusCode*/_ in
//                // do nothing
//            },
//            failure: { /*error*/_ in
//                // do nothing
//            }
//        )
        
        // サーバ通信 ＋ List
//        _ = SampleNetwork.request(
//            target: .getList,
//            success: { json, _ in
//                guard let safeJson = json else { return }
//                // run in main => UI thread
//                DispatchQueue.main.async { [weak self] in
//                    if let dataArray = Mapper<Content>().mapArray(JSONObject: safeJson.arrayObject) {
//                        self?.contents = dataArray
//                        self?.tableView.reloadData()
//                    } else {
//                        self?.showAlert("⚠️ServerAPI mapping error")
//                    }
//                }
//            },
//            error: { /*statusCode*/_ in
//                // do nothing - why?
//            },
//            failure: { /*error*/_ in
//                // do nothing - why?
//            }
//        )
        
//        Service.content.getList(
//            completion: { [weak self] contents in
//                guard let `self` = self else { return }
//                self.contents = contents
//                self.tableView.reloadData()
//            },
//            failure: nil)
        
        
    }
    
    private func showAlert(_ message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
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

extension ViewController: UITableViewDelegate {
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

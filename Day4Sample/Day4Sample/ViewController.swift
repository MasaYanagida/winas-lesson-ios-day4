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
    }
    
    @IBAction private func buttonTouchUpInside(_ sender: UIButton) {
        
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

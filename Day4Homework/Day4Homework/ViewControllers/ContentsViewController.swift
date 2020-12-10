//
//  ContentsViewController.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit

// MARK: ContentsViewController

class ContentsViewController: UIViewController {
    
    @IBOutlet fileprivate dynamic weak var tableView: UITableView! {
        didSet {
            // TODO
        }
    }
    private var contents = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func reloadButtonTouchUpInside(_ sender: UIButton) {
        // TODO : reload `contents` from server
    }
    @IBAction private func accountButtonTouchUpInside(_ sender: UIButton) {
        // TODO : show ID&Password from options
    }
}

// MARK: - StoryboardInstantiable

extension ContentsViewController: StoryboardInstantiable {
    static var storyboardName: String {
        return String(describing: self)
    }
}

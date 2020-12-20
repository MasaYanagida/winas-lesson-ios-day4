//
//  ContentTableViewCell.swift
//  Day4Homework
//
//  Created by 杉浦祐一 on 2020/12/20.
//

import UIKit

class ContentTableViewCell: UITableViewCell{
    var content: Content? {
        didSet{
            guard let content = self.content else {
                return
            }
            nameLabel.text = content.name
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
   
}

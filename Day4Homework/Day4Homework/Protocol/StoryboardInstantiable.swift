//
//  StoryboardInstantiable.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit

protocol StoryboardInstantiable {
    static var storyboardName: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    static func fromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as? Self
        if controller == nil {
            assert(false, "Could not find storyboard")
        }
        return controller!
    }
}

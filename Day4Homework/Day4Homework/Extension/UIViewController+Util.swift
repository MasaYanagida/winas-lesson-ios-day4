//
//  UIViewController+Util.swift
//  Day4Homework
//
//  Created by 柳田昌弘 on 2020/12/10.
//

import UIKit

extension UIViewController {
    func swapRootViewController(to controller: UIViewController) {
        if let window = self.view.window,
            let rootViewController = window.rootViewController {
            controller.view.frame = rootViewController.view.frame
            controller.view.layoutIfNeeded()
            UIView.transition(with: window, duration: 0.24, options: .transitionCrossDissolve, animations: {
                window.rootViewController = controller
            }, completion: { completed in
                // maybe do something here
            })
        } else {
            self.view.window?.rootViewController = controller
        }
    }
}

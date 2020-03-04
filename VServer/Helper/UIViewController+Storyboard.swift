//
//  UIViewController+Storyboard.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    static func fromStoryboard<T: UIViewController>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)

        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
            preconditionFailure("Invalid screen name or storyboard")
        }
        return viewController
    }
}

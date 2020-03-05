//
//  ViewHelper.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//
import UIKit

// This is a placeholder code till I integrate coordinator pattern code to screens
extension UIViewController {
    static func serverViewController() -> UIViewController {
        let network = Networking()
        let viewModel = ServerViewModel(network: network)
        let viewController: ServerViewController = ServerViewController.fromStoryboard("Server")
        viewController.viewModel = viewModel

        return UINavigationController(rootViewController: viewController)
    }

    static func successViewController() -> UIViewController {
        let viewModel = SuccessViewModel()
        let viewController: SuccessViewController = SuccessViewController.fromStoryboard("Success")
        viewController.viewModel = viewModel

        return UINavigationController(rootViewController: viewController)
    }
}

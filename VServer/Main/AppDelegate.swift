//
//  AppDelegate.swift
//  VServer
//
//  Created by Uday Pandey on 03/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewModel = ServerViewModel()
        let viewController: ServerViewController = ServerViewController.fromStoryboard("Server")
        viewController.viewModel = viewModel

        let navVC = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navVC
        window?.makeKeyAndVisible()

        return true
    }
}

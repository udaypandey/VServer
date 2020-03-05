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
    var coordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)

        window = mainWindow
        coordinator = Coordinator(context: mainWindow)
        coordinator?.start()

        return true
    }
}

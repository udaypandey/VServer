//
//  CoorindatorType.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation

// Cooridinator pattern to manage navigation
protocol TSBOBCoordinatorType {
    associatedtype Event
    associatedtype State

    func start()
}

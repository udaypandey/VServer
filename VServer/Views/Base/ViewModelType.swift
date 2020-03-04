//
//  ViewModelType.swift
//  VServer
//
//  Created by Uday Pandey on 03/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation

protocol ViewModeType {
    // Incoming events from view controller
    associatedtype Inputs

    // Events to view controller
    associatedtype Outputs

    // Defines the events towards coordinator
    associatedtype Flows

    // Defines the events towards coordinator
    associatedtype Texts
}

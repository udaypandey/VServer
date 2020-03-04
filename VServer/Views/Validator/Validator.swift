//
//  Validator.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation
import Network

enum Validator {}

extension Validator {
    static func isValid(serverAddress: String) -> Bool {
        // Testing for only IPV4 address only here instead of
        // generic valid url
        let trimmedText = serverAddress.trimmingCharacters(in: .whitespaces)

        guard !trimmedText.isEmpty, IPv4Address(trimmedText) != nil else {
            return false
        }

        return true
    }
}

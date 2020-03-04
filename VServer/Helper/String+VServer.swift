//
//  String+VServer.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation

extension String {
    public var localized: String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: "Localizable")
    }
}

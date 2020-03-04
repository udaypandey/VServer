//
//  XCUIExtension+VServer.swift
//  VServerUITests
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import XCTest

extension XCUIElement {
    func clearText() {
        guard elementType == .textField ||
            elementType == .textView ||
            elementType == .secureTextField else { return }

        guard let stringValue = self.value as? String else {
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

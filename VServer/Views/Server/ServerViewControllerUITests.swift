//
//  ServerViewControllerUITests.swift
//  VServerUITests
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import XCTest

class ServerViewControllerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        // Right now it runs by manually loading the right screen
        app = XCUIApplication()
        app.launch()
    }

    func testServerViewControllerElementsExists() {
        XCTContext.runActivity(named: "Validate elements exist") { _  in
            let welcomeText = app.staticTexts["accessibility.id.welcomeText"].firstMatch
            XCTAssertTrue(welcomeText.exists)

            let okButton = app.buttons["accessibility.id.ok"].firstMatch
            XCTAssertTrue(okButton.exists)

            let textField = app.textFields["accessibility.id.serverAddressTextField"].firstMatch
            XCTAssertTrue(textField.exists)
        }
    }

    func testServerViewControllerInputs() {
        let okButton = app.buttons["accessibility.id.ok"].firstMatch
        XCTAssertTrue(okButton.exists)

        let textField = app.textFields["accessibility.id.serverAddressTextField"].firstMatch
        XCTAssertTrue(textField.exists)

        XCTContext.runActivity(named: "Validate inputs") { _ in
            XCTAssertFalse(okButton.isEnabled)

            textField.tap()

            textField.typeText("192.")
            XCTAssertFalse(okButton.isEnabled)

            textField.clearText()
            XCTAssertFalse(okButton.isEnabled)

            textField.typeText("192.168.0.1")
            XCTAssertTrue(okButton.isEnabled)
        }
    }
}

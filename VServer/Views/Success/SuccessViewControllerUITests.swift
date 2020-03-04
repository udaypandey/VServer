//
//  SuccessViewControllerUITests.swift
//  VServerTests
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import XCTest

class SuccessViewControllerUITests: XCTestCase {
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
        }
    }
}

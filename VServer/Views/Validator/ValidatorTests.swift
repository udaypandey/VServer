//
//  ValidatorTests.swift
//  VServerTests
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import XCTest
@testable import VServer

class ValidatorTests: XCTestCase {
    func testIsServerAddressInvalid() {
        XCTAssertFalse(Validator.isValid(serverAddress: ""))
        XCTAssertFalse(Validator.isValid(serverAddress: " "))
        XCTAssertFalse(Validator.isValid(serverAddress: "  "))
        XCTAssertFalse(Validator.isValid(serverAddress: "   "))

        XCTAssertFalse(Validator.isValid(serverAddress: " fooo "))
        XCTAssertFalse(Validator.isValid(serverAddress: "  foo.bar  "))

        XCTAssertFalse(Validator.isValid(serverAddress: " 192. "))
        XCTAssertFalse(Validator.isValid(serverAddress: " 192.168. "))
        XCTAssertFalse(Validator.isValid(serverAddress: " 192.160.0. "))
    }

    func testIsServerAddressValid() {
        XCTAssertTrue(Validator.isValid(serverAddress: "    192.160.0.1   "))

        XCTAssertTrue(Validator.isValid(serverAddress: "    192.160.1.10   "))
        XCTAssertTrue(Validator.isValid(serverAddress: "    192.160.1.11   "))
    }
}

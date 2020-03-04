//
//  SuccessViewModelTests.swift
//  VServerTests
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import XCTest
import RxBlocking
import RxCocoa
import RxSwift

@testable import VServer

class SuccessViewModelTests: XCTestCase {
    func testSuccessStaticText() {
        let viewModel = SuccessViewModel()

        let welcomeText = viewModel.texts.welcomeText
            .asObservable()

        XCTAssertEqual("vserver.success.text.welcome".localized,
                       try welcomeText.toBlocking(timeout: 1.0).first())
    }
}

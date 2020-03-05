//
//  LoginViewModelTests.swift
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

class LoginViewModelTests: XCTestCase {
    func testLoginStaticText() {
        let network = Networking()
        let viewModel = LoginViewModel(network: network, serverAddress: "192.168.0.10")

        let welcomeText = viewModel.texts.welcomeText
            .asObservable()
        let userNamePlaceholderText = viewModel.texts.userNamePlaceholderText
            .asObservable()
        let passwordPlaceholderText = viewModel.texts.passwordPlaceholderText
            .asObservable()

        let okText = viewModel.texts.okText
            .asObservable()

        XCTAssertEqual("vserver.login.text.welcome".localized,
                       try welcomeText.toBlocking(timeout: 1.0).first())
        XCTAssertEqual("vserver.login.text.userNamePlaceholder".localized,
                       try userNamePlaceholderText.toBlocking(timeout: 1.0).first())
        XCTAssertEqual("vserver.login.text.passwordPlaceholder".localized,
                       try passwordPlaceholderText.toBlocking(timeout: 1.0).first())
        XCTAssertEqual("vserver.common.button.ok".localized,
                       try okText.toBlocking(timeout: 1.0).first())
    }

    func testLoginInput() {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

        let network = Networking()
        let viewModel = LoginViewModel(network: network, serverAddress: "192.168.0.10")

        let isEnabled = viewModel.outputs.isEnabled
            .asObservable()
            .subscribeOn(scheduler)

        // Startup values
        XCTAssertEqual(false, try isEnabled.toBlocking(timeout: 1.0).first())

        viewModel.inputs.userName.onNext(" ")
        XCTAssertEqual(false, try isEnabled.toBlocking(timeout: 1.0).first())

        viewModel.inputs.password.onNext(" ")
        XCTAssertEqual(false, try isEnabled.toBlocking(timeout: 1.0).first())

        viewModel.inputs.userName.onNext(" b ")
        XCTAssertEqual(false, try isEnabled.toBlocking(timeout: 1.0).first())

        viewModel.inputs.password.onNext(" foo ")
        XCTAssertEqual(true, try isEnabled.toBlocking(timeout: 1.0).first())
    }

    func testLoginAddressAuthenticationFlow() {
        let disposeBag = DisposeBag()

        let network = Networking()
        let viewModel = LoginViewModel(network: network, serverAddress: "192.168.0.11")

        let isEnabled = viewModel.outputs.isEnabled
            .asObservable()

        // Startup values
        XCTAssertEqual(false, try isEnabled.toBlocking(timeout: 1.0).first())

        viewModel.inputs.userName.onNext("vaion")
        viewModel.inputs.password.onNext("password")
        XCTAssertEqual(true, try isEnabled.toBlocking(timeout: 1.0).first())

        let didFinishLogin = viewModel.flows.didFinishLogin
            .asObservable()

        let testObserver = BehaviorSubject<Coordinator.Event?>(value: nil)

        didFinishLogin
            .bind(to: testObserver)
            .disposed(by: disposeBag)

        viewModel.inputs.okTapped.onNext(())

        let expectation = XCTestExpectation(description: "Delay for PublishSubject")
        _ = XCTWaiter.wait(for: [expectation], timeout: 5)

        XCTAssertEqual(Coordinator.Event.didLoginWithAuthentication,
                       try testObserver.toBlocking(timeout: 1.0).first())
    }
}

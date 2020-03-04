//
//  ServerViewModelTests.swift
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

class ServerViewModelTests: XCTestCase {
    func testServerStaticText() {
        let viewModel = ServerViewModel()

        let welcomeText = viewModel.texts.welcomeText
            .asObservable()
        let placeholderText = viewModel.texts.placeholderText
            .asObservable()
        let okText = viewModel.texts.okText
            .asObservable()

        XCTAssertEqual("vserver.server.text.welcome".localized,
                       try welcomeText.toBlocking(timeout: 1.0).first())
        XCTAssertEqual("vserver.server.text.placeholder".localized,
                       try placeholderText.toBlocking(timeout: 1.0).first())
        XCTAssertEqual("vserver.common.button.ok".localized,
                       try okText.toBlocking(timeout: 1.0).first())
    }

    func testServerAddressInput() {
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

        let viewModel = ServerViewModel()
        let isValidServerAddress = viewModel.outputs.isValidServerAddress
            .asObservable()
            .subscribeOn(scheduler)

        // Startup values
        XCTAssertEqual(false, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.serverAddress.onNext("192.")
        XCTAssertEqual(false, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.serverAddress.onNext("192.168.")
        XCTAssertEqual(false, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.serverAddress.onNext("")
        XCTAssertEqual(false, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.serverAddress.onNext("192.168.0.1")
        XCTAssertEqual(true, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.serverAddress.onNext("")
        XCTAssertEqual(false, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.serverAddress.onNext("192.168.0.1")
        XCTAssertEqual(true, try isValidServerAddress.toBlocking(timeout: 1.0).first())
    }

    func testServerAddressFlow() {
        let disposeBag = DisposeBag()

        let viewModel = ServerViewModel()
        let isValidServerAddress = viewModel.outputs.isValidServerAddress
            .asObservable()

        let didSelectServer = viewModel.flows.didSelectServer
            .asObservable()

        let testObserver = BehaviorSubject<ServerViewModel.Event?>(value: nil)

        didSelectServer
            .bind(to: testObserver)
            .disposed(by: disposeBag)

        // Startup values
        XCTAssertEqual(false, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        // Valid email
        viewModel.inputs.serverAddress.onNext("192.168.0.1")
        XCTAssertEqual(true, try isValidServerAddress.toBlocking(timeout: 1.0).first())

        viewModel.inputs.okTapped.onNext(())

        XCTAssertEqual(ServerViewModel.Event.didSelectServer("192.168.0.1"),
                       try testObserver.toBlocking(timeout: 1.0).first())
    }
}

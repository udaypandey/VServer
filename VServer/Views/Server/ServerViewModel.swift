//
//  ServerViewModel.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct ServerViewModel: ViewModeType {
    let inputs: Inputs
    let outputs: Outputs

    let flows: Flows
    let texts: Texts

    private let network: Networking

    init(network: Networking) {
        self.network = network

        let serverAddress = BehaviorSubject<String>(value: "")
        let okTapped = PublishSubject<Void>()

        inputs = Inputs(serverAddress: serverAddress.asObserver(),
                        okTapped: okTapped.asObserver())

        let welcomeText = Driver.just("vserver.server.text.welcome".localized)
        let placeholderText = Driver.just("vserver.server.text.placeholder".localized)
        let okText = Driver.just("vserver.common.button.ok".localized)
        texts = Texts(welcomeText: welcomeText,
                      placeholderText: placeholderText,
                      okText: okText)

        let networkCall = okTapped
            .withLatestFrom(serverAddress)
            .flatMap { serverAddress in
                network.rx.connectToServer(ipAddress: serverAddress)
            }
            .share(replay: 1, scope: .whileConnected)

        let networkResponse = networkCall
            .map { response -> Coordinator.Event in
                if response.success && response.code == 200 {
                    return .didLoginWithoutAuthentication
                } else if !response.success && response.code == 401 {
                    return try .didFailLoginWithoutAuthentication(serverAddress.value())
                } else {
                    return .invalid
                }
            }

        let isValidServerAddress = serverAddress
            .map { Validator.isValid(serverAddress: $0) }
            .asDriver(onErrorJustReturn: false)

        let errorMessage = "vserver.common.error".localized
        let showError = networkResponse.filter { $0 == .invalid }
            .map { _ in errorMessage }
            .asDriver(onErrorJustReturn: "")

        outputs = Outputs(isValidServerAddress: isValidServerAddress, showError: showError)

        let didFinishServer = networkResponse
            .filter { $0 != .invalid }
            .asDriver(onErrorJustReturn: .invalid)

        flows = Flows(didFinishServer: didFinishServer)
    }
}

extension ServerViewModel {
    struct Inputs {
        let serverAddress: AnyObserver<String>
        let okTapped: AnyObserver<Void>
    }

    struct Outputs {
        let isValidServerAddress: Driver<Bool>
        let showError: Driver<String>
    }

    struct Texts {
        let welcomeText: Driver<String>
        let placeholderText: Driver<String>
        let okText: Driver<String>
    }

    struct Flows {
        let didFinishServer: Driver<Coordinator.Event>
    }
}

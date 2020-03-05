//
//  LoginViewModel.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct LoginViewModel: ViewModeType {
    let inputs: Inputs
    let outputs: Outputs

    let flows: Flows
    let texts: Texts

    private let network: Networking
    private let serverAddress: String

    init(network: Networking, serverAddress: String) {
        self.network = network
        self.serverAddress = serverAddress

        let userName = BehaviorSubject<String>(value: "")
        let password = BehaviorSubject<String>(value: "")
        let okTapped = PublishSubject<Void>()

        inputs = Inputs(userName: userName.asObserver(),
                        password: password.asObserver(),
                        okTapped: okTapped.asObserver())

        let welcomeText = Driver.just("vserver.login.text.welcome".localized)
        let userNamePlaceholderText = Driver.just("vserver.login.text.userNamePlaceholder".localized)
        let passwordPlaceholderText = Driver.just("vserver.login.text.passwordPlaceholder".localized)
        let okText = Driver.just("vserver.common.button.ok".localized)
        texts = Texts(welcomeText: welcomeText,
                      userNamePlaceholderText: userNamePlaceholderText,
                      passwordPlaceholderText: passwordPlaceholderText,
                      okText: okText)

        let networkCall = okTapped
            .withLatestFrom(userName)
            .map { _ in
                Credentials(username: try userName.value(), password: try password.value())
            }
            .flatMap { credentials in
                network.rx.connectToServer(ipAddress: serverAddress, credentials: credentials)
            }
            .share(replay: 1, scope: .whileConnected)

        let networkResponse = networkCall
            .map { response -> Coordinator.Event in
                if response.success && response.code == 200 {
                    return .didLoginWithAuthentication
                } else {
                    return .invalid
                }
            }

        let isUserNameValid = userName
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { !$0.isEmpty }

        let isPasswordValid = password
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { !$0.isEmpty }

        let isEnabled = Observable.zip(isUserNameValid, isPasswordValid)
            .map { $0.0 && $0.1 }
            .asDriver(onErrorJustReturn: false)

        let errorMessage = "vserver.common.error".localized
        let showError = networkResponse.filter { $0 == .invalid }
            .map { _ in errorMessage }
            .asDriver(onErrorJustReturn: "")

        outputs = Outputs(isEnabled: isEnabled, showError: showError)

        let didFinishLogin = networkResponse
            .filter { $0 != .invalid }
            .asDriver(onErrorJustReturn: .invalid)

        flows = Flows(didFinishLogin: didFinishLogin)
    }
}

extension LoginViewModel {
    struct Inputs {
        let userName: AnyObserver<String>
        let password: AnyObserver<String>
        let okTapped: AnyObserver<Void>
    }

    struct Outputs {
        let isEnabled: Driver<Bool>
        let showError: Driver<String>
    }

    struct Texts {
        let welcomeText: Driver<String>
        let userNamePlaceholderText: Driver<String>
        let passwordPlaceholderText: Driver<String>
        let okText: Driver<String>
    }

    struct Flows {
        let didFinishLogin: Driver<Coordinator.Event>
    }
}

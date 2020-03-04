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

    init() {
        let serverAddress = BehaviorSubject<String>(value: "")
        let okTapped = PublishSubject<Void>()

        inputs = Inputs(serverAddress: serverAddress.asObserver(),
                        okTapped: okTapped.asObserver())

        let isValidServerAddress = serverAddress
            .map { Validator.isValid(serverAddress: $0) }
            .asDriver(onErrorJustReturn: false)
        outputs = Outputs(isValidServerAddress: isValidServerAddress)

        let welcomeText = Driver.just("vserver.server.text.welcome".localized)
        let placeholderText = Driver.just("vserver.server.text.placeholder".localized)
        let okText = Driver.just("vserver.common.button.ok".localized)
        texts = Texts(welcomeText: welcomeText,
                      placeholderText: placeholderText,
                      okText: okText)

        let didSelectServer = okTapped
            .withLatestFrom(serverAddress)
            .map { Event.didSelectServer($0) }
            .asDriver(onErrorJustReturn: .didSelectServer(""))
        flows = Flows(didSelectServer: didSelectServer)
    }
}

extension ServerViewModel {
    struct Inputs {
        let serverAddress: AnyObserver<String>
        let okTapped: AnyObserver<Void>
    }

    struct Outputs {
        let isValidServerAddress: Driver<Bool>
    }

    struct Texts {
        let welcomeText: Driver<String>
        let placeholderText: Driver<String>
        let okText: Driver<String>
    }

    struct Flows {
        let didSelectServer: Driver<Event>
    }

    enum Event: Equatable {
        case didSelectServer(_ addresss: String)
    }
}

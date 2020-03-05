//
//  Coordinator.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Coordinator {
    enum Event: Equatable {
        case initial

        case willStartLoginWithoutAuthentication
        case didLoginWithoutAuthentication
        case didFailLoginWithoutAuthentication(_ address: String)

        case willLoginWithAuthentication(_ address: String)
        case didLoginWithAuthentication

        case success

        case invalid
    }
}

final class Coordinator {
    private let context: UIWindow
    private var rootViewController: UINavigationController!
    private let network = Networking()
    private let disposeBag = DisposeBag()

    init(context: UIWindow) {
        self.context = context
    }

    func start() {
        loop(event: .initial)
    }

    // I have used a basic push based navigation for demonstration purposes.
    // A real coordinator may have navigation options to replace the screens instead
    // of allowing the back button to navigate. It also allowed me to not code for
    // Cancel button in Login screen for demo and I just back button to go back.
    func loop(event: Event) {
        let newEvent = fsm(event: event)

        switch newEvent {
        case .willStartLoginWithoutAuthentication:
            let childViewController = serverViewController()
            rootViewController = UINavigationController(rootViewController: childViewController)
            context.rootViewController = rootViewController
            context.makeKeyAndVisible()

        case .willLoginWithAuthentication(let serverAddress):
            let childViewController = loginViewController(serverAddress: serverAddress)
            rootViewController.pushViewController(childViewController, animated: true)

        case .success:
            let childViewController = successViewController()
            rootViewController.pushViewController(childViewController, animated: true)

        default:
            preconditionFailure("Invalid flow event")
        }
    }
}

extension Coordinator {
    func serverViewController() -> ServerViewController {
        let viewModel = ServerViewModel(network: network)
        let viewController: ServerViewController = ServerViewController.fromStoryboard("Server")
        viewController.viewModel = viewModel

        viewModel.flows.didFinishServer
            .drive(self.rx.fsm)
            .disposed(by: disposeBag)

        return viewController
    }

    func successViewController() -> SuccessViewController {
        let viewModel = SuccessViewModel()
        let viewController: SuccessViewController = SuccessViewController.fromStoryboard("Success")
        viewController.viewModel = viewModel

        return viewController
    }

    func loginViewController(serverAddress: String) -> LoginViewController {
        let viewModel = LoginViewModel(network: network, serverAddress: serverAddress)
        let viewController: LoginViewController = SuccessViewController.fromStoryboard("Login")
        viewController.viewModel = viewModel

        viewModel.flows.didFinishLogin
            .drive(self.rx.fsm)
            .disposed(by: disposeBag)

        return viewController
    }
}

extension Coordinator {
    // FSM for coordinator. Ideally FSM are based on state and
    // event and that allows to absorb invalid events in
    // the states we were not expecting them.

    // For the simplest case, a basic pure function will suffice.
    // For the more involved coordinators, we can choose to
    // move FSM into an object of its own. In this particular
    // case I am keeping it simple but this particular one
    // may evolve.
    func fsm(event: Event) -> Event {
        switch event {
        case .initial:
            return .willStartLoginWithoutAuthentication

        case .didLoginWithoutAuthentication, .didLoginWithAuthentication:
            return .success

        case .didFailLoginWithoutAuthentication(let serverAddress):
            return .willLoginWithAuthentication(serverAddress)

        default:
            return .invalid
        }
    }
}

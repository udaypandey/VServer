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
    enum Event {
        case initial
        case chooseServer
        case invalid
    }

    enum State {
        case initial
        case finish
    }
}

final class Coordinator {
    private let context: UINavigationController

    init(context: UINavigationController) {
        self.context = context
    }

    func start() {
    }
}

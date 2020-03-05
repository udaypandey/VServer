//
//  Coordinator+Rx.swift
//  VServer
//
//  Created by Uday Pandey on 05/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Coordinator: ReactiveCompatible {}
extension Reactive where Base: Coordinator {
    var fsm: Binder<Coordinator.Event> {
        return Binder(self.base) { coordinator, event in
            coordinator.loop(event: event)
        }
    }
}

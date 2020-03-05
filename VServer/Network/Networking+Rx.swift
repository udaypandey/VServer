//
//  Networking+Rx.swift
//  VServer
//
//  Created by Uday Pandey on 05/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Networking: ReactiveCompatible {}

extension Reactive where Base: NetworkingProtocol {
    func connectToServer(ipAddress: String, credentials: Credentials? = nil) -> Single<NetworkingResponse> {
        return Single<NetworkingResponse>.create { single in
            let disposable = Disposables.create()

            self.base.connectToServer(ipAddress: ipAddress, credentials: credentials) { response in
                single(.success(response))
            }

            return disposable
        }
    }
}

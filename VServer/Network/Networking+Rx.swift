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

enum APIError: Error {
    case http(Int, String)

    case unknown
}

extension Networking: ReactiveCompatible {}

extension Reactive where Base: NetworkingProtocol {
    func connectToServer(ipAddress: String, credentials: Credentials? = nil) -> Single<Bool> {
        return Single<Bool>.create { single in
            let disposable = Disposables.create()

            self.base.connectToServer(ipAddress: ipAddress, credentials: credentials) { response in
                if response.success && response.code == 200 {
                    single(.success(true))
                } else {
                    single(.error(APIError.http(response.code, response.message)))
                }
            }

            return disposable
        }
    }
}

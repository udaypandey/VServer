//
//  UITextField+Rx.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    /// Bindable sink for `placeholder` property.
    public var placeholderText: Binder<String?> {
        return Binder(self.base) { textField, text in
            textField.placeholder = text
        }
    }
}

#endif

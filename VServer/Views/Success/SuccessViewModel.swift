//
//  SuccessViewModel.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct SuccessViewModel: ViewModeType {
    let inputs: Inputs
    let outputs: Outputs

    let flows: Flows
    let texts: Texts

    init() {
        inputs = Inputs()
        outputs = Outputs()

        let welcomeText = Driver.just("vserver.success.text.welcome".localized)
        texts = Texts(welcomeText: welcomeText)

        flows = Flows()
    }
}

extension SuccessViewModel {
    struct Inputs {
    }

    struct Outputs {
    }

    struct Texts {
        let welcomeText: Driver<String>
    }

    struct Flows {
    }
}

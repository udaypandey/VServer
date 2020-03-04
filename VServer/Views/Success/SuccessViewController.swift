//
//  SuccessViewController.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SuccessViewController: UIViewController {
    @IBOutlet weak var welcomeText: UILabel!

    private let disposeBag = DisposeBag()
    var viewModel: SuccessViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupAccesibilityIdentifiers()
    }

    private func setupBindings() {
        // Incoming
        viewModel.texts.welcomeText
            .drive(welcomeText.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupAccesibilityIdentifiers() {
        welcomeText.accessibilityIdentifier = Accessibility.welcomeText.rawValue
    }
}

extension SuccessViewController {
    private enum Accessibility: String {
        case welcomeText              = "accessibility.id.welcomeText"
    }
}

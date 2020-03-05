//
//  ServerViewController.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ServerViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var serverAddressTextField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!

    private let disposeBag = DisposeBag()
    var viewModel: ServerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
        setupAccesibilityIdentifiers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverAddressTextField.becomeFirstResponder()
    }

    private func setupViews() {
        okButton.layer.cornerRadius = 10
    }

    private func setupBindings() {
        // Incoming
        viewModel.texts.welcomeText
            .drive(welcomeText.rx.text)
            .disposed(by: disposeBag)

        viewModel.texts.placeholderText
            .drive(serverAddressTextField.rx.placeholderText)
            .disposed(by: disposeBag)

        viewModel.texts.okText
            .drive(okButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.outputs.isValidServerAddress
            .drive(okButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // Outgoing
        serverAddressTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.serverAddress)
            .disposed(by: disposeBag)

        okButton.rx.tap
            .bind(to: viewModel.inputs.okTapped)
            .disposed(by: disposeBag)

        viewModel.outputs.showError
            .drive(onNext: { errorMessage in
                let alert = UIAlertController(title: errorMessage, message: "Host not found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupAccesibilityIdentifiers() {
        welcomeText.accessibilityIdentifier = Accessibility.welcomeText.rawValue
        serverAddressTextField.accessibilityIdentifier = Accessibility.serverAddressTextField.rawValue
        okButton.accessibilityIdentifier = Accessibility.okButton.rawValue
    }
}

extension ServerViewController {
    private enum Accessibility: String {
        case welcomeText              = "accessibility.id.welcomeText"
        case serverAddressTextField   = "accessibility.id.serverAddressTextField"
        case okButton                 = "accessibility.id.ok"
    }
}

//
//  LoginViewController.swift
//  VServer
//
//  Created by Uday Pandey on 04/03/2020.
//  Copyright © 2020 Thirstysea Ltd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class LoginViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!

    private let disposeBag = DisposeBag()
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
        setupAccesibilityIdentifiers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.becomeFirstResponder()
    }

    private func setupViews() {
        okButton.layer.cornerRadius = 10
    }

    private func setupBindings() {
        // Incoming
        viewModel.texts.welcomeText
            .drive(welcomeText.rx.text)
            .disposed(by: disposeBag)

        viewModel.texts.userNamePlaceholderText
            .drive(userNameTextField.rx.placeholderText)
            .disposed(by: disposeBag)

        viewModel.texts.passwordPlaceholderText
            .drive(passwordTextField.rx.placeholderText)
            .disposed(by: disposeBag)

        viewModel.texts.okText
            .drive(okButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.outputs.isEnabled
            .drive(okButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // Outgoing
        userNameTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.userName)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.password)
            .disposed(by: disposeBag)

        okButton.rx.tap
            .bind(to: viewModel.inputs.okTapped)
            .disposed(by: disposeBag)

        viewModel.outputs.showError
            .drive(onNext: { errorMessage in
                let alert = UIAlertController(title: errorMessage, message: "Wrong credentials", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupAccesibilityIdentifiers() {
        welcomeText.accessibilityIdentifier = Accessibility.welcomeText.rawValue
        userNameTextField.accessibilityIdentifier = Accessibility.userNameTextField.rawValue
        passwordTextField.accessibilityIdentifier = Accessibility.passwordTextField.rawValue
        okButton.accessibilityIdentifier = Accessibility.okButton.rawValue
    }
}

extension LoginViewController {
    private enum Accessibility: String {
        case welcomeText              = "accessibility.id.welcomeText"
        case userNameTextField        = "accessibility.id.userNameTextField"
        case passwordTextField        = "accessibility.id.passwordTextField"
        case okButton                 = "accessibility.id.ok"
    }
}

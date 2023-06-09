//
//  AuthorizationScreenViewModel.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

final class AuthorizationViewModel {
    private(set) lazy var confirmButton = makeConfirmButton()
    private(set) lazy var textField = makeTextField()

    private let authorizationService: AuthorizationServiceProtocol

    init(authorizationService: AuthorizationServiceProtocol) {
        self.authorizationService = authorizationService
    }

    convenience init() {
        self.init(authorizationService: AuthorizationService())
    }
}

// MARK: - Behaviour

private extension AuthorizationViewModel {
    func updateAuthorizationToken() {
        authorizationService.updateAuthorizationToken(textField.text)
    }
}

// MARK: - UI Components

private extension AuthorizationViewModel {
    func makeTextField() -> TextField.Model {
        TextField.Model(placeholder: "Authorization token...")
    }

    func makeConfirmButton() -> Button.Model {
        Button.Model(
            title: "Confirm",
            titleColor: .blue
        ) { [weak self] in
            self?.updateAuthorizationToken()
        }
    }
}

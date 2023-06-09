//
//  AuthorizationService.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol AuthorizationServiceProtocol: AnyObject {
    @discardableResult
    func updateAuthorizationToken(_ token: String) -> Result<Void>
    func getAuthorizationToken() -> Result<String?>
    func subscribeAuthorizationChanged(_ closure: @escaping (Bool) -> Void)
}

final class AuthorizationService: AuthorizationServiceProtocol {
    private enum Constants {
        static let authTokenKey = "AuthorizationToken"
        static let authorized = "Authorized"
    }
    private let keychain: KeychainProtocol
    private let notificationCenter: NotificationCenter

    init(
        keychain: KeychainProtocol,
        notificationCenter: NotificationCenter
    ) {
        self.keychain = keychain
        self.notificationCenter = notificationCenter
    }

    convenience init() {
        self.init(
            keychain: Keychain(),
            notificationCenter: .default
        )
    }

    @discardableResult
    func updateAuthorizationToken(_ token: String) -> Result<Void> {
        guard let data = token.data(using: .utf8) else {
            return .failure(Error.invalidData)
        }

        let result = keychain.write(
            key: Constants.authTokenKey,
            data: data
        )

        if result.value != nil {
            notificationCenter.post(
                name: .authorizationChanged,
                object: nil,
                userInfo: [Constants.authorized: !token.isEmpty]
            )
        }

        return result
    }

    func getAuthorizationToken() -> Result<String?> {
        keychain.read(key: Constants.authTokenKey).map { data in
            guard let data else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }

    func subscribeAuthorizationChanged(_ closure: @escaping (Bool) -> Void) {
        notificationCenter.addObserver(forName: .authorizationChanged, object: nil, queue: .main) { notification in
            guard let authorized = notification.userInfo?[Constants.authorized] as? Bool else {
                return assertionFailure()
            }
            closure(authorized)
        }
    }
}

// MARK: - Error

private extension AuthorizationService {
    enum Error: Swift.Error {
        case invalidData
    }
}

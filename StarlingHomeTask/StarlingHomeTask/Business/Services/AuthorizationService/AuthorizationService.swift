//
//  AuthorizationService.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol AuthorizationServiceProtocol: AnyObject {
    func updateAuthorizationToken(_ token: String) -> Result<Void>
    func getAuthorizationToken() -> Result<String?>
}

final class AuthorizationService: AuthorizationServiceProtocol {
    private enum Constants {
        static let authTokenKey = "AuthorizationToken"
    }
    private let keychain: KeychainProtocol

    init(keychain: KeychainProtocol) {
        self.keychain = keychain
    }

    convenience init() {
        self.init(keychain: Keychain())
    }

    func updateAuthorizationToken(_ token: String) -> Result<Void> {
        guard let data = token.data(using: .utf8) else {
            return .failure(Error.invalidData)
        }

        return keychain.write(
            key: Constants.authTokenKey,
            data: data
        )
    }

    func getAuthorizationToken() -> Result<String?> {
        keychain.read(key: Constants.authTokenKey).map { data in
            guard let data else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }
}

// MARK: - Error

private extension AuthorizationService {
    enum Error: Swift.Error {
        case invalidData
    }
}

//
//  AuthorizationServiceMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class AuthorizationServiceMock: AuthorizationServiceProtocol {
    private(set) var updateAuthorizationTokenToken = [String]()
    var updateAuthorizationTokenResult: Result<Void>!
    func updateAuthorizationToken(_ token: String) -> Result<Void> {
        updateAuthorizationTokenToken.append(token)
        return updateAuthorizationTokenResult
    }


    private(set) var getAuthorizationTokenCount = 0
    var getAuthorizationTokenResult: Result<String?>!
    func getAuthorizationToken() -> Result<String?> {
        getAuthorizationTokenCount += 1
        return getAuthorizationTokenResult
    }

    var subscribeAuthorizationChangedClosures = [(Bool) -> Void]()
    func subscribeAuthorizationChanged(_ closure: @escaping (Bool) -> Void) {
        subscribeAuthorizationChangedClosures.append(closure)
    }
}

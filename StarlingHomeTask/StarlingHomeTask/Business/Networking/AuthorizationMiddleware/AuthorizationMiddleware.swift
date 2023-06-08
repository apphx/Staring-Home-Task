//
//  AuthorizationMiddleware.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol AuthorizationMiddlewareProtocol: AnyObject {
    func authorizedRequest(from request: URLRequest) -> URLRequest
    func validate(response: HTTPURLResponse) throws
    func subscribeUnauthorizedRequestIdentified(_ closure: @escaping () -> Void)
}

final class AuthorizationMiddleware: AuthorizationMiddlewareProtocol {
    private let service: AuthorizationServiceProtocol
    private let notificationCenter: NotificationCenter

    init(
        service: AuthorizationServiceProtocol,
        notificationCenter: NotificationCenter
    ) {
        self.service = service
        self.notificationCenter = notificationCenter
    }

    convenience init() {
        self.init(
            service: AuthorizationService(),
            notificationCenter: .default
        )
    }

    func authorizedRequest(from request: URLRequest) -> URLRequest {
        let token = service.getAuthorizationToken().value?.flatMap { $0 }
        guard let token else { return request }
        var req = request
        req.addValue("Bearer \(token)", forHTTPHeaderField: Constants.HttpHeader.authorization)
        return req
    }

    func validate(response: HTTPURLResponse) throws {
        if response.statusCode == Constants.HttpStatusCode.unauthorized {
            notificationCenter.post(name: .unauthorizedRequest, object: nil)
            throw Error.unauthorized
        }
    }

    func subscribeUnauthorizedRequestIdentified(_ closure: @escaping () -> Void) {
        notificationCenter.addObserver(forName: .unauthorizedRequest, object: nil, queue: nil) { _ in
            closure()
        }
    }
}

// MARK: - Constants

extension AuthorizationMiddleware {
    private enum Constants {
        enum HttpHeader {
            static let authorization = "Authorization"
        }
        enum HttpStatusCode {
            static let unauthorized = 403
        }
    }
}

// MARK: - Error

extension AuthorizationMiddleware {
    enum Error: Swift.Error {
        case unauthorized
    }
}

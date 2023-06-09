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
}

final class AuthorizationMiddleware: AuthorizationMiddlewareProtocol {
    private let service: AuthorizationServiceProtocol

    init(
        service: AuthorizationServiceProtocol
     
    ) {
        self.service = service
    }

    convenience init() {
        self.init(
            service: AuthorizationService()
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
            service.updateAuthorizationToken("")
            throw Error.unauthorized
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

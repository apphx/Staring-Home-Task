//
//  NetworkingClient.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol NetworkingClientProtocol: AnyObject {
    @discardableResult
    func execute<T>(
        request: URLRequest,
        completion: @escaping (Result<T>) -> Void
    ) -> Cancellable where T: Decodable
}

final class NetworkingClient: NetworkingClientProtocol {
    private let urlSession: URLSession
    private let authorizationMiddleware: AuthorizationMiddlewareProtocol

    // For injection and testing purposes; different strategies for testing this class can be employed
    // eg. defining a custom URLSessionProtocol with a mock; for simplicity sake this will be taken as is
    init(
        urlSession: URLSession,
        authorizationMiddleware: AuthorizationMiddlewareProtocol
    ) {
        self.urlSession = urlSession
        self.authorizationMiddleware = authorizationMiddleware
    }

    convenience init() {
        self.init(
            urlSession: .shared,
            authorizationMiddleware: AuthorizationMiddleware()
        )
    }

    @discardableResult
    func execute<T>(
        request: URLRequest,
        completion: @escaping (Result<T>) -> Void
    ) -> Cancellable where T: Decodable {
        let authorizedRequest = authorizationMiddleware.authorizedRequest(from: request)
        let task = urlSession.dataTask(with: authorizedRequest) { [authorizationMiddleware] data, response, error in
            do {
                if let error = error { throw error }
                guard let httpResponse = response as? HTTPURLResponse, let data else {
                    throw ApiError.genericError
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw ApiError.httpFailure(code: httpResponse.statusCode)
                }
                try authorizationMiddleware.validate(response: httpResponse)
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
}

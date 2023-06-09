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
                try authorizationMiddleware.validate(response: httpResponse)
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw ApiError.httpFailure(code: httpResponse.statusCode)
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom({ decoder in
                    let string = try decoder.singleValueContainer().decode(String.self)
                    guard let date = Self.dateFormatter.date(from: string) else {
                        throw ApiError.iso8601DateDecodingFailure
                    }
                    return date
                })
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        return task
    }
}

// MARK: - Decoding

private extension NetworkingClient {
    private static let dateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()
}

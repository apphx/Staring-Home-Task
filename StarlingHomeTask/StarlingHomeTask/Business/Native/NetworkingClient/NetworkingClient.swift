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

    // For injection and testing purposes; different strategies for testing this class can be employed
    // eg. defining a custom URLSessionProtocol with a mock; for simplicity sake this will be taken as is
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    convenience init() {
        self.init(urlSession: .shared)
    }

    @discardableResult
    func execute<T>(
        request: URLRequest,
        completion: @escaping (Result<T>) -> Void
    ) -> Cancellable where T: Decodable {
        let task = urlSession.dataTask(with: request) { data, response, error in
            do {
                if let error = error { throw error }
                guard let httpResponse = response as? HTTPURLResponse, let data else {
                    throw ApiError.genericError
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw ApiError.httpFailure(code: httpResponse.statusCode)
                }
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

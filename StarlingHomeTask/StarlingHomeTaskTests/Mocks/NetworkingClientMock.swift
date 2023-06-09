//
//  NetworkingClientMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class NetworkingClientMock<T: Decodable>: NetworkingClientProtocol {
    private(set) var requests = [URLRequest]()
    private(set) var executeCount = 0
    var response: StarlingHomeTask.Result<T>?
    lazy var cancellable: Cancellable = CancellableMock()

    func execute<T>(
        request: URLRequest,
        completionQueue: DispatchQueue,
        completion: @escaping (StarlingHomeTask.Result<T>) -> Void
    ) -> Cancellable where T: Decodable {
        requests.append(request)
        executeCount += 1

        switch response {
        case let .some(.success(value as T)):
            completion(.success(value))
        case let .some(.failure(error)):
            completion(.failure(error))
        default:
            break
        }
        return cancellable
    }
}

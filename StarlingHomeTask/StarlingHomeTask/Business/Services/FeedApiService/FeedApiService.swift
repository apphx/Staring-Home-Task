//
//  FeedApiService.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

protocol FeedApiServiceProtocol: AnyObject {
    func getSettledFeedItems(
        accountId: String,
        fromDate: Date,
        toDate: Date,
        completion: @escaping (Result<[FeedItem]>) -> Void
    )
}

final class FeedApiService: FeedApiServiceProtocol {
    private let network: NetworkingClientProtocol

    init(
        network: NetworkingClientProtocol
    ) {
        self.network = network
    }

    convenience init() {
        self.init(network: NetworkingClient())
    }

    func getSettledFeedItems(
        accountId: String,
        fromDate: Date,
        toDate: Date,
        completion: @escaping (Result<[FeedItem]>) -> Void
    ) {
        let request = URLRequest.makeWith(
            path: "/feed/account/\(accountId)/settled-transactions-between",
            httpMethod: .get(
                queryParameters: [
                    ("minTransactionTimestamp", Self.dateFormatter.string(from: fromDate)),
                    ("maxTransactionTimestamp", Self.dateFormatter.string(from: toDate))
                ]
            )
        )
        network.execute(request: request) { (result: Result<FeedResponse>) in
            completion(result.map { $0.feedItems })
        }
    }
}

private extension FeedApiService {
    private static let dateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()
}

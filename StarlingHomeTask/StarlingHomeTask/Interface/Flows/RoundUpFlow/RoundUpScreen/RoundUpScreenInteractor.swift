//
//  RoundUpScreenInteractor.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

protocol RoundUpScreenInteractorProtocol: AnyObject {
    func fetchSettledOutoingTransactionsSinceLastWeek(
        referenceDate: Date,
        accountId: String,
        completion: @escaping (Result<[FeedItem]>) -> Void
    ) 
}

final class RoundUpScreenInteractor: RoundUpScreenInteractorProtocol {
    private let feedApiService: FeedApiServiceProtocol

    init(feedApiService: FeedApiServiceProtocol) {
        self.feedApiService = feedApiService
    }

    convenience init() {
        self.init(feedApiService: FeedApiService())
    }

    func fetchSettledOutoingTransactionsSinceLastWeek(
        referenceDate: Date,
        accountId: String,
        completion: @escaping (Result<[FeedItem]>) -> Void
    ) {
        let midnightDate = Calendar.current.startOfDay(for: referenceDate)
        let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: midnightDate)!

        feedApiService.getSettledFeedItems(
            accountId: accountId,
            fromDate: fromDate,
            toDate: referenceDate
        ) { result in
            completion(result.map { $0.outgoingItems() })
        }
    }
}

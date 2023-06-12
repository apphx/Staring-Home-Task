//
//  FeedApiServiceMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 12/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class FeedApiServiceMock: FeedApiServiceProtocol {
    private(set) var getSettledFeedItemsCalled = false
    private(set) var getSettledFeedItemsParams: (accountId: String, fromDate: Date, toDate: Date, completion: (Result<[FeedItem]>) -> Void)?

    func getSettledFeedItems(accountId: String, fromDate: Date, toDate: Date, completion: @escaping (Result<[FeedItem]>) -> Void) {
        getSettledFeedItemsCalled = true
        getSettledFeedItemsParams = (accountId: accountId, fromDate: fromDate, toDate: toDate, completion: completion)
    }
}

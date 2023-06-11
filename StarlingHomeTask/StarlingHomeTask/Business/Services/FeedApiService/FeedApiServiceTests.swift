//
//  FeedApiServiceTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class FeedApiServiceTests: XCTestCase {
    private(set) var network: NetworkingClientMock<FeedResponse>!
    private(set) var sut: FeedApiService!

    override func setUp() {
        network = .init()
        sut = .init(network: network)
    }

    override func tearDown() {
        network = nil
        sut = nil
    }

    func testGetSettledFeedItems_whenApiServiceReturnsSuccess_itReturnsFeedItemsFromResponse() {
        let accountId = UUID().uuidString
        let fromDate = Date(timeIntervalSince1970: 100_000)
        let toDate = Date(timeIntervalSince1970: 200_000)

        network.response = .success(.init(feedItems: [.sample()]))
        var result: Result<[FeedItem]>?

        sut.getSettledFeedItems(
            accountId: accountId,
            fromDate: fromDate,
            toDate: toDate
        ) { result = $0 }

        let expectedRequest = URLRequest.makeWith(
            path: "/feed/account/\(accountId)/settled-transactions-between",
            httpMethod: .get(
                queryParameters: [
                    ("minTransactionTimestamp", "1970-01-02T03:46:40.000Z"),
                    ("maxTransactionTimestamp", "1970-01-03T07:33:20.000Z")
                ]
            )
        )

        XCTAssertEqual(result, .success([.sample()]))
        XCTAssertEqual(network.requests, [expectedRequest])
    }

    func XtestGetSettledFeedItems_whenApiServiceReturnsFailure_itPropagatesFailure() {
        // TODO
    }
}

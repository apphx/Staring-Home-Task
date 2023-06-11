//
//  FeedItem+Sample.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask
import Foundation

extension FeedItem {
    static func sample(
        amount: Money = .eur(),
        feedItemUid: String = "feedItemUid",
        reference: String = "reference",
        transactionTime: Date = Date(timeIntervalSince1970: 100_000),
        direction: Direction = .out
    ) -> FeedItem {
        FeedItem(
            amount: amount,
            feedItemUid: feedItemUid,
            reference: reference,
            transactionTime: transactionTime,
            direction: direction
        )
    }
}

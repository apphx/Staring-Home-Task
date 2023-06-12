//
//  RoundUpScreenInteractorMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 12/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class RoundUpScreenInteractorProtocolMock: RoundUpScreenInteractorProtocol {
    private(set) var fetchSettledOutoingTransactionsSinceLastWeekCalled = false
    private(set) var fetchSettledOutoingTransactionsSinceLastWeekReferenceDate: Date?
    private(set) var fetchSettledOutoingTransactionsSinceLastWeekAccountId: String?
    var fetchSettledOutoingTransactionsSinceLastWeekResult: Result<[FeedItem]>!
    func fetchSettledOutoingTransactionsSinceLastWeek(
        referenceDate: Date,
        accountId: String,
        completion: @escaping (Result<[FeedItem]>) -> Void
    ) {
        fetchSettledOutoingTransactionsSinceLastWeekCalled = true
        fetchSettledOutoingTransactionsSinceLastWeekReferenceDate = referenceDate
        fetchSettledOutoingTransactionsSinceLastWeekAccountId = accountId
        completion(fetchSettledOutoingTransactionsSinceLastWeekResult)
    }

    private(set) var roundUpIdempotencyKeys = [String]()
    var roundUpResult: Result<Void>!
    func roundUp(
        idempotencyKey: String,
        accountId: String,
        money: Money,
        completion: @escaping (Result<Void>) -> Void
    ) {
        roundUpIdempotencyKeys.append(idempotencyKey)
        completion(roundUpResult)
    }
}

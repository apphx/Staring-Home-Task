//
//  RoundUpScreenInteractorTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class RoundUpScreenInteractorTests: XCTestCase {
    private var feedApiService: FeedApiServiceMock!
    private var savingsGoalsApiService: SavingsGoalsApiServiceMock!
    private var sut: RoundUpScreenInteractor!

    override func setUp() {
        feedApiService = FeedApiServiceMock()
        savingsGoalsApiService = SavingsGoalsApiServiceMock()
        sut = RoundUpScreenInteractor(feedApiService: feedApiService, savingsGoalsApiService: savingsGoalsApiService)
    }

    override func tearDown() {
        feedApiService = nil
        savingsGoalsApiService = nil
        sut = nil
    }

    func testFetchSettledOutgoing_whenServiceFetchSucceeds_itReturnsOnlyOutgoingItems() {
        let referenceDate = Date()
        let accountId = UUID().uuidString
        let feedItems: [FeedItem] = [.sample(), .sample(), .sample()]

        var result: Result<[FeedItem]>?
        sut.fetchSettledOutoingTransactionsSinceLastWeek(referenceDate: referenceDate, accountId: accountId) { res in
            result = res
        }
        feedApiService.getSettledFeedItemsParams?.completion(.success(feedItems))


        XCTAssertEqual(result, .success(feedItems))
    }

    func testFetchSettledOutgoing_whenServiceFetchFails_itPropagatesFailure() {
        let referenceDate = Date()
        let accountId = UUID().uuidString

        var result: Result<[FeedItem]>?
        sut.fetchSettledOutoingTransactionsSinceLastWeek(referenceDate: referenceDate, accountId: accountId) { res in
            result = res
        }
        feedApiService.getSettledFeedItemsParams?.completion(.failure(TestError.test))

        XCTAssertEqual(result, .failure(TestError.test))
    }

    func testRoundUp_whenApiRequestsSucceedAndHasAtLeastOneSavingsGoal_itAddsGivenAmountOfMoneyToFirstSavingsGoal() {
        let idempotencyKey = UUID().uuidString
        let accountId = UUID().uuidString
        let money = Money.eur()
        let savingsGoal = SavingsGoal.sample()
        var result: Result<Void>?
        sut.roundUp(idempotencyKey: idempotencyKey, accountId: accountId, money: money) { res in
            result = res
        }
        savingsGoalsApiService.getSavingsGoalsParams?.completion(.success([savingsGoal]))
        savingsGoalsApiService.addMoneyParams?.completion(.success(.init(transferUid: UUID().uuidString, success: true)))

        XCTAssertTrue(savingsGoalsApiService.addMoneyCalled)
        XCTAssertEqual(savingsGoalsApiService.addMoneyParams?.idempotencyKey, idempotencyKey)
        XCTAssertEqual(savingsGoalsApiService.addMoneyParams?.money, money)
        XCTAssertEqual(savingsGoalsApiService.addMoneyParams?.accountId, accountId)
        XCTAssertEqual(savingsGoalsApiService.addMoneyParams?.savingsGoalId, savingsGoal.savingsGoalUid)
        XCTAssertEqual(result, .success)
    }

    func testRoundUp_whenApiRequestsSucceedAndHasAtLeastOneSavingsGoalButAddMoneyFails_itPropagatesError() {
        var result: Result<Void>?
        sut.roundUp(idempotencyKey: UUID().uuidString, accountId: UUID().uuidString, money: .eur()) { res in
            result = res
        }
        savingsGoalsApiService.getSavingsGoalsParams?.completion(.success([.sample()]))
        savingsGoalsApiService.addMoneyParams?.completion(.failure(TestError.test))

        XCTAssertEqual(result, .failure(TestError.test))
    }

    func testRoundUp_whenApiRequestsSucceedAndHasNoSavingsGoals_itFailsWithCustomError() {
        var result: Result<Void>?
        sut.roundUp(idempotencyKey: UUID().uuidString, accountId: UUID().uuidString, money: .eur()) { res in
            result = res
        }
        savingsGoalsApiService.getSavingsGoalsParams?.completion(.success([]))

        XCTAssertEqual(result, .failure(RoundUpScreenInteractor.Error.noSavingsGoalsAvailable))
    }

    func testRoundUp_whenGetSavingsGoalsFails_itPropagatesFailure() {
        let accountId = UUID().uuidString

        var result: Result<Void>?
        sut.roundUp(idempotencyKey: UUID().uuidString, accountId: accountId, money: .eur()) { res in
            result = res
        }
        savingsGoalsApiService.getSavingsGoalsParams?.completion(.failure(TestError.test))

        XCTAssertEqual(result, .failure(TestError.test))
    }
}

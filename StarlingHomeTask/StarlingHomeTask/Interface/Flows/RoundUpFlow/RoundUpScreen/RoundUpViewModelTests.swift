//
//  RoundUpViewModelTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class RoundUpViewModelTests: XCTestCase {
    var account: Account!
    var screenInteractor: RoundUpScreenInteractorProtocolMock!
    var onCompletionCalled: Bool!
    var sut: RoundUpViewModel!

    override func setUp() {
        account = .sample()
        screenInteractor = RoundUpScreenInteractorProtocolMock()
        onCompletionCalled = false
        sut = RoundUpViewModel(
            account: account,
            screenInteractor: screenInteractor,
            onCompletion: { self.onCompletionCalled = true }
        )
    }

    override func tearDown() {
        account = nil
        screenInteractor = nil
        onCompletionCalled = nil
        sut = nil
    }

    func testViewDidLoad_itFetchesSettledOutgoingTransactionsFromScreenInteractor() {
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekResult = .success([])

        sut.viewDidLoad()

        XCTAssertTrue(screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekCalled)
        XCTAssertEqual(screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekAccountId, account.accountUid)
    }

    func testDataSource_whenFetchSucceedsAndHasAtLeastOneTransaction_itShowsContentState() {
        let feedItems = [
            FeedItem.sample(direction: .out),
            FeedItem.sample(direction: .out),
            FeedItem.sample(direction: .receive)
        ]
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekResult = .success(feedItems)

        sut.viewDidLoad()

        XCTAssertEqual(sut.numberOfRows(in: 0), 2)
        let expectedCells = feedItems.outgoingItems().map { feedItem in
            Cell.Model(
                title: .init(text: "\(feedItem.amount.localizedDescription(direction: feedItem.direction)) -> Round up: \(feedItem.amount.roundUpMoney().localizedDescription())"),
                subtitle: .init(text: feedItem.reference, textColor: .lightGray)
            )
        }
        let sutCells = (0...1).map { sut.model(at: .init(row: $0, section: 0)) }
        XCTAssertEqual(sutCells, expectedCells)
    }

    func testDataSource_whenFetchSucceedsAndHasNoTransaction_itShowsEmptyState() {
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekResult = .success([])

        sut.viewDidLoad()

        XCTAssertEqual(sut.numberOfRows(in: 0), 1)
        XCTAssertEqual(sut.model(at: IndexPath(row: 0, section: 0)).title.text, "Looks like there are no valid transactions 🤷")
    }

    func testDataSource_whenFetchFails_itShowsErrorState() {
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekResult = .failure(TestError.test)

        sut.viewDidLoad()

        XCTAssertEqual(sut.numberOfRows(in: 0), 0) // No cells should be present but ideally we'd have error state
    }

    func testRoundUpButton_whenRoundUpCallSucceeds_itPropagatesCompletion() {
        screenInteractor.roundUpResult = .success(())
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekResult = .success([.sample()])

        sut.viewDidLoad()
        sut.roundUpButton.onTap()

        XCTAssertTrue(onCompletionCalled)
    }

    func testRoundUpButton_whenPressedMultipleTimesWOHavingTransactionsChange_itPassesSameIdempotencyKey() {
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeekResult = .success([.sample()])
        screenInteractor.roundUpResult = .success(())

        sut.viewDidLoad()
        sut.roundUpButton.onTap()
        sut.roundUpButton.onTap()
        sut.roundUpButton.onTap()

        XCTAssertEqual(screenInteractor.roundUpIdempotencyKeys.count, 3)
        XCTAssertTrue(screenInteractor.roundUpIdempotencyKeys.allSatisfy { $0 == screenInteractor.roundUpIdempotencyKeys[0]})
    }
}

//
//  SavingsGoalsApiServiceTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class SavingsGoalsApiServiceTests: XCTestCase {
    private(set) var sut: SavingsGoalsApiService!

    override func tearDown() {
        sut = nil
    }

    func testGetSavingsGoals_whenApiServiceReturnsSuccess_itReturnsSavingsGoalsFromResponse() {
        let network = NetworkingClientMock<SpacesResponse>()
        sut = .init(network: network)
        let accountId = UUID().uuidString
        network.response = .success(.init(savingsGoals: [.sample()]))

        var result: Result<[SavingsGoal]>?
        sut.getSavingsGoals(accountId: accountId) { result = $0 }

        XCTAssertEqual(result, .success([.sample()]))
        XCTAssertEqual(network.requests, [.makeWith(path: "/account/\(accountId)/spaces")])
    }

    func XtestGetSavingsGoals_whenApiServiceReturnsFailure_itPropagatesFailure() {
        // TODO
    }

    func testAddMoney_whenApiServiceReturnsSuccess_itReturnsSuccessFromResponse() {
        let network = NetworkingClientMock<AddMoneyResponse>()
        sut = .init(network: network)
        let idempotencyKey = UUID().uuidString
        let money = Money.eur()
        let accountId = UUID().uuidString
        let savingsGoalId = UUID().uuidString

        let response = AddMoneyResponse(transferUid: UUID().uuidString, success: .random())
        network.response = .success(response)

        var result: Result<AddMoneyResponse>?
        sut.addMoney(
            idempotencyKey: idempotencyKey,
            money: money,
            accountId: accountId,
            savingsGoalId: savingsGoalId
        ) { result = $0 }

        let expectedRequest = URLRequest.makeWith(
            path: "/account/\(accountId)/savings-goals/\(savingsGoalId)/add-money/\(idempotencyKey)",
            httpMethod: .put(body: AddMoneyBody(amount: money))
        )

        XCTAssertEqual(result, .success(response))
        XCTAssertEqual(network.requests, [expectedRequest])
    }

    func XtestAddMoney_whenApiServiceReturnsFailure_itPropagatesFailure() {
        // TODO
    }
}

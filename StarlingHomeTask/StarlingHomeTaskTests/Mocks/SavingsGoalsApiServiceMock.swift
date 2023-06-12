//
//  SavingsGoalsApiServiceMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 12/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class SavingsGoalsApiServiceMock: SavingsGoalsApiServiceProtocol {
    private(set) var getSavingsGoalsCalled = false
    private(set) var getSavingsGoalsParams: (accountId: String, completion: (Result<[SavingsGoal]>) -> Void)?
    func getSavingsGoals(accountId: String, completion: @escaping (Result<[SavingsGoal]>) -> Void) {
        getSavingsGoalsCalled = true
        getSavingsGoalsParams = (accountId: accountId, completion: completion)
    }

    private(set) var addMoneyCalled = false
    private(set) var addMoneyParams: (idempotencyKey: String, money: Money, accountId: String, savingsGoalId: String, completion: (Result<AddMoneyResponse>) -> Void)?
    func addMoney(idempotencyKey: String, money: Money, accountId: String, savingsGoalId: String, completion: @escaping (Result<AddMoneyResponse>) -> Void) {
        addMoneyCalled = true
        addMoneyParams = (idempotencyKey: idempotencyKey, money: money, accountId: accountId, savingsGoalId: savingsGoalId, completion: completion)
    }
}

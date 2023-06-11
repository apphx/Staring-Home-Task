//
//  SavingsGoalsApiService.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

protocol SavingsGoalsApiServiceProtocol: AnyObject {
    func getSavingsGoals(
        accountId: String,
        completion: @escaping (Result<[SavingsGoal]>) -> Void
    )

    func addMoney(
        idempotencyKey: String,
        money: Money,
        accountId: String,
        savingsGoalId: String,
        completion: @escaping (Result<AddMoneyResponse>) -> Void
    )
}

final class SavingsGoalsApiService: SavingsGoalsApiServiceProtocol {
    private let network: NetworkingClientProtocol

    init(
        network: NetworkingClientProtocol
    ) {
        self.network = network
    }

    convenience init() {
        self.init(network: NetworkingClient())
    }

    func getSavingsGoals(
        accountId: String,
        completion: @escaping (Result<[SavingsGoal]>) -> Void
    ) {
        let request = URLRequest.makeWith(path: "/account/\(accountId)/spaces")
        network.execute(request: request) { (result: Result<SpacesResponse>) in
            completion(result.map { $0.savingsGoals} )
        }
    }

    func addMoney(
        idempotencyKey: String,
        money: Money,
        accountId: String,
        savingsGoalId: String,
        completion: @escaping (Result<AddMoneyResponse>) -> Void)
    {
        let request = URLRequest.makeWith(
            path: "/account/\(accountId)/savings-goals/\(savingsGoalId)/add-money/\(idempotencyKey)",
            httpMethod: .put(body: AddMoneyBody(amount: money))
        )
        network.execute(request: request, completion: completion)
    }
}

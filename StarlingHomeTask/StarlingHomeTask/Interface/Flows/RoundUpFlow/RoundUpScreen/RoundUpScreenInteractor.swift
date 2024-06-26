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

    func roundUp(
        idempotencyKey: String,
        accountId: String,
        money: Money,
        completion: @escaping (Result<Void>) -> Void
    )
}

final class RoundUpScreenInteractor: RoundUpScreenInteractorProtocol {
    private enum Constants {
        static let pastDateIntervalInDays = -7
    }
    private let feedApiService: FeedApiServiceProtocol
    private let savingsGoalsApiService: SavingsGoalsApiServiceProtocol

    init(
        feedApiService: FeedApiServiceProtocol,
        savingsGoalsApiService: SavingsGoalsApiServiceProtocol
    ) {
        self.feedApiService = feedApiService
        self.savingsGoalsApiService = savingsGoalsApiService
    }

    convenience init() {
        self.init(
            feedApiService: FeedApiService(),
            savingsGoalsApiService: SavingsGoalsApiService()
        )
    }

    func fetchSettledOutoingTransactionsSinceLastWeek(
        referenceDate: Date,
        accountId: String,
        completion: @escaping (Result<[FeedItem]>) -> Void
    ) {
        let midnightDate = Calendar.current.startOfDay(for: referenceDate)
        let fromDate = Calendar.current.date(byAdding: .day, value: Constants.pastDateIntervalInDays, to: midnightDate)!

        feedApiService.getSettledFeedItems(
            accountId: accountId,
            fromDate: fromDate,
            toDate: referenceDate
        ) { result in
            completion(result.map { $0.outgoingItems() })
        }
    }

    func roundUp(
        idempotencyKey: String,
        accountId: String,
        money: Money,
        completion: @escaping (Result<Void>) -> Void
    ) {
        func addMoney(in savingsGoal: SavingsGoal) {
            savingsGoalsApiService.addMoney(
                idempotencyKey: idempotencyKey,
                money: money,
                accountId: accountId,
                savingsGoalId: savingsGoal.savingsGoalUid
            ) { result in
                completion(result.map { _ in })
            }
        }

        savingsGoalsApiService.getSavingsGoals(accountId: accountId) { result in
            switch result {
            case let .success(savingsGoals):
                guard let savingsGoal = savingsGoals.first else {
                    return completion(.failure(Error.noSavingsGoalsAvailable))
                }
                addMoney(in: savingsGoal)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Error

extension RoundUpScreenInteractor {
    enum Error: Swift.Error {
        case noSavingsGoalsAvailable
    }
}

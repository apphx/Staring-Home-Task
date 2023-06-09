//
//  Account+Sample.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import Foundation

extension Account {
    static func sample(
        accountUid: String = "id",
        accountType: Account.AccountType = .primary,
        defaultCategory: String = "category",
        currency: String = "currency",
        createdAt: Date = .distantPast,
        name: String = "account name"
    ) -> Self {
        Account(
            accountUid: accountUid,
            accountType: accountType,
            defaultCategory: defaultCategory,
            currency: currency,
            createdAt: createdAt,
            name: name
        )
    }
}

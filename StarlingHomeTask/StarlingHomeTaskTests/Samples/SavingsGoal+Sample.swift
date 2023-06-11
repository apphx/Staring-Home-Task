//
//  SavingsGoal+Sample.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask

extension SavingsGoal {
    static func sample(
        savingsGoalUid: String = "id",
        name: String = "name",
        totalSaved: Money = .eur()
    ) -> SavingsGoal {
        SavingsGoal(
            savingsGoalUid: savingsGoalUid,
            name: name,
            totalSaved: totalSaved
        )
    }
}

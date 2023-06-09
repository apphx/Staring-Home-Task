//
//  SavingsGoal.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

struct SavingsGoal: Decodable {
    let savingsGoalUid: String
    let name: String
    let totalSaved: Money
}

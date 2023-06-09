//
//  FlowLauncherMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import Foundation
import UIKit

final class FlowLauncherMock: FlowLauncherProtocol {
    private(set) var runHomeFlowCount = 0
    func runHomeFlow(navigationController: UINavigationController) {
        runHomeFlowCount += 1
    }

    private(set) var runRoundUpFlowCount = 0
    private(set) var runRoundUpFlowAccounts = [StarlingHomeTask.Account]()
    func runRoundUpFlow(navigationController: UINavigationController, account: StarlingHomeTask.Account) {
        runRoundUpFlowCount += 1
        runRoundUpFlowAccounts.append(account)
    }
}

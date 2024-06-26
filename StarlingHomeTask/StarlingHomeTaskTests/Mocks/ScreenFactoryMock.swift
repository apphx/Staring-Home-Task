//
//  ScreenFactoryMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import Foundation
import UIKit

final class ScreenFactoryMock: ScreenFactoryProtocol {
    private(set) var makeHomeScreenOnActionClosures = [(HomeViewModel.Action) -> Void]()
    var makeHomeScreenController: UIViewController!
    func makeHomeScreen(onAction: @escaping (HomeViewModel.Action) -> Void) -> UIViewController {
        makeHomeScreenOnActionClosures.append(onAction)
        return makeHomeScreenController
    }

    private(set) var makeRoundUpScreenOnCompletionClosures = [() -> Void]()
    private(set) var makeRoundUpScreenAccounts = [Account]()
    var makeRoundUpScreenController: UIViewController!
    func makeRoundUpScreen(
        account: Account,
        onCompletion: @escaping () -> Void
    ) -> UIViewController {
        makeRoundUpScreenAccounts.append(account)
        makeRoundUpScreenOnCompletionClosures.append(onCompletion)
        return makeRoundUpScreenController
    }
}

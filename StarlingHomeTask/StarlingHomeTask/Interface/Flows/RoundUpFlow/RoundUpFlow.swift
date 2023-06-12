//
//  RoundUpFlow.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class RoundUpFlow {
    private weak var navigationController: UINavigationController?
    private let screenFactory: ScreenFactoryProtocol

    init(
        navigationController: UINavigationController,
        screenFactory: ScreenFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
    }

    func start(account: Account) {
        let controller = screenFactory.makeRoundUpScreen(account: account) { [weak navigationController] in
            navigationController?.popViewController(animated: true)
            print("rounded up 🚀 show success status")
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

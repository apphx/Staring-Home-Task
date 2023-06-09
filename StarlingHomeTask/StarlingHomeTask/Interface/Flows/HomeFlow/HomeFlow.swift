//
//  HomeFlow.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class HomeFlow {
    private weak var navigationController: UINavigationController?
    private let screenFactory: ScreenFactoryProtocol
    private let flowLauncher: FlowLauncherProtocol

    init(
        navigationController: UINavigationController,
        screenFactory: ScreenFactoryProtocol,
        flowLauncher: FlowLauncherProtocol
    ) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
        self.flowLauncher = flowLauncher
    }

    func start() {
        let controller = screenFactory.makeHomeScreen { [flowLauncher, navigationController] action in
            guard let navigationController else { return }
            switch action {
            case let .didTapAccount(account):
                flowLauncher.runRoundUpFlow(
                    navigationController: navigationController,
                    account: account
                )
            }
        }
        navigationController?.setViewControllers([controller], animated: false)
    }
}

//
//  FlowLauncher.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

protocol FlowLauncherProtocol: AnyObject {
    func runHomeFlow(navigationController: UINavigationController)
    func runRoundUpFlow(
        navigationController: UINavigationController,
        account: Account
    )
}

final class FlowLauncher: FlowLauncherProtocol {
    func runHomeFlow(navigationController: UINavigationController) {
        HomeFlow(
            navigationController: navigationController,
            screenFactory: ScreenFactory(),
            flowLauncher: FlowLauncher()
        ).start()
    }

    func runRoundUpFlow(
        navigationController: UINavigationController,
        account: Account
    ) {
    }
}

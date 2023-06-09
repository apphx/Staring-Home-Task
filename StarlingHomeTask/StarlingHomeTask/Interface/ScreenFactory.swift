//
//  ScreenFactory.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

protocol ScreenFactoryProtocol: AnyObject {
    func makeHomeScreen(onAction: @escaping (HomeViewModel.Action) -> Void)  -> UIViewController
}

final class ScreenFactory: ScreenFactoryProtocol {
    func makeHomeScreen(onAction: @escaping (HomeViewModel.Action) -> Void) -> UIViewController {
        let viewModel = HomeViewModel(
            accountsService: AccountsApiService(),
            authorizationService: AuthorizationService(),
            onAction: onAction
        )
        return HomeViewController(viewModel: viewModel)
    }
}

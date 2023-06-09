//
//  SceneDelegate.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var authorizationService: AuthorizationServiceProtocol!

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = UINavigationController(rootViewController: HomeViewController(viewModel: .init()))
        self.window?.makeKeyAndVisible()

        // one option for this navigation logic to be tested is via UI tests
        authorizationService = AuthorizationService()
        authorizationService.subscribeAuthorizationChanged { [weak self] authorized in
            let rootNav = self?.window?.rootViewController as? UINavigationController

            if authorized {
                if rootNav?.presentedViewController is AuthorizationViewController {
                    rootNav?.presentedViewController?.dismiss(animated: true)
                }
            } else {
                if rootNav?.presentedViewController is AuthorizationViewController { return }
                rootNav?.popToRootViewController(animated: false)

                let authController = AuthorizationViewController(viewModel: .init())
                authController.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController?.present(authController, animated: true)
            }
        }
    }
}

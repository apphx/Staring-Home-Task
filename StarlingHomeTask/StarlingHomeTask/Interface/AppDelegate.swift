//
//  AppDelegate.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var authorizationService: AuthorizationServiceProtocol!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
    -> Bool {
        if #available(iOS 13, *) {
            
        } else {
            self.window = UIWindow()
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
        return true
    }
}


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
            let rootNav = UINavigationController()
            self.window?.rootViewController = rootNav
            self.window?.makeKeyAndVisible()
            FlowLauncher().runHomeFlow(navigationController: rootNav)

            // one option for this navigation logic to be tested is via UI tests
            authorizationService = AuthorizationService()
            authorizationService.subscribeAuthorizationChanged { [weak self] authorized in
                if authorized {
                    if rootNav.presentedViewController is AuthorizationViewController {
                        rootNav.presentedViewController?.dismiss(animated: true)
                    }
                } else {
                    if rootNav.presentedViewController is AuthorizationViewController { return }
                    rootNav.popToRootViewController(animated: false)

                    let authController = AuthorizationViewController(viewModel: .init())
                    authController.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController?.present(authController, animated: true)
                }
            }
        }
        return true
    }
}


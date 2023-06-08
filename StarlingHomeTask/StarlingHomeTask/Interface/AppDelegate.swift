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
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
    -> Bool {
        if #available(iOS 13, *) {
            
        } else {
            self.window = UIWindow()
            self.window?.rootViewController = UIViewController()
            self.window?.makeKeyAndVisible()
        }
        return true
    }
}


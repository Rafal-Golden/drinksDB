//
//  AppDelegate.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        window?.rootViewController = navigationController
        
        // It is possible to change inital screens and use storyboard. But this code have to be prepared with coordinators and presenters for all of them
        
        return true
    }
}


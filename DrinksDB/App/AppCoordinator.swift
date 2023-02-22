//
//  AppCoordinator.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21/02/2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject
{
    func start()
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void)
}

extension Coordinator
{
    func navigate(to destination: Destination)
    {
        navigate(to: destination, animated: true) { }
    }
}

class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
 
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchCoordinator = DrinksSearchListCoordinator(navigationController: navigationController)
        navigationController.viewControllers = [searchCoordinator.build()]        
    }
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
        switch destination {
            // when can navigate to search drink if we change app screens structure
            case .searchDrink:
                let coordinator = DrinksSearchListCoordinator(navigationController: navigationController)
                coordinator.start()
                
            default: break
        }
    }
    
}

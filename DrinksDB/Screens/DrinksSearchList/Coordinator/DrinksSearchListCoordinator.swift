//
//  DrinksSearchListCoordinator.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21-2-2023.
//

import UIKit

class DrinksSearchListCoordinator: Coordinator
{
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func build() -> UIViewController {
        let vc = UIStoryboard(name: "DrinksSearchList", bundle: nil).instantiateInitialViewController() as! DrinksSearchListViewController
        let presenter = DrinksSearchListPresenter(ui: vc, coordinator: self)
        vc.presenter = presenter
        return vc
    }
    
    //MARK: - coordinator protocol
    
    func start() {
        let vc = build()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
        switch destination {
            case .drinkDetails(let id):
                DrinkDetailsCoordinator(navigationController: navigationController, drinkId: id).start()
                
            default: break
        }
    }
}

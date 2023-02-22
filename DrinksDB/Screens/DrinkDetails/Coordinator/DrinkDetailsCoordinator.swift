//
//  DrinkDetailsCoordinator.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 22-2-2023.
//

import UIKit

class DrinkDetailsCoordinator: Coordinator
{
    let navigationController: UINavigationController
    let drinkId: String
    
    init(navigationController: UINavigationController, drinkId: String) {
        self.navigationController = navigationController
        self.drinkId = drinkId
    }
    
    func build() -> UIViewController {
        let vc = UIStoryboard(name: "DrinkDetails", bundle: nil).instantiateInitialViewController() as! DrinkDetailsViewController
        let presenter = DrinkDetailsPresenter(ui: vc, coordinator: self, drinkId: drinkId)
        vc.presenter = presenter
        return vc
    }
    
    //MARK: - coordinator protocol
    
    func start() {
        let vc = build()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
        switch destination {
            case .back:
                navigationController.popViewController(animated: true)
            
            default: break
        }
    }
}

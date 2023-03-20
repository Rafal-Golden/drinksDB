//
//  DrinksSearchListPresenter+Init.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 02/03/2023.
//

import Foundation


extension DrinksSearchListPresenter {
    
    convenience init(ui: DrinksSearchListInterfaceIn, coordinator: Coordinator) {
        let drinksRepository = AppMainModule.injectDrinksRepository()
        self.init(ui: ui, coordinator: coordinator, drinksRepository: drinksRepository)
    }
}

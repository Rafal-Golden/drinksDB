//
//  DrinksSearchListPresenter.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21-2-2023.
//

import Foundation

class DrinksSearchListPresenter: DrinksSearchListInterfaceOut
{
    var drinksModel: DrinksModel
    
    weak var ui: DrinksSearchListInterfaceIn!
    var coordinator: Coordinator!
    
    private var drinksRepository: DrinksRepositoryProtocol
    private var allIngredients: [String] = []

    init(ui: DrinksSearchListInterfaceIn, coordinator: Coordinator,
         drinksRepository: DrinksRepositoryProtocol) {
        self.ui = ui
        self.coordinator = coordinator
        
        self.drinksModel = DrinksModel(items: [])
        self.drinksRepository = drinksRepository
    }
    
    // MARK: DrinksSearchListInterfaceOut
    
    func didLoad() {
        drinksRepository.getIngredientsList(completion: { [weak self] result in
            self?.allIngredients = (try? result.get()) ?? []
        })
    }
    
    func didSelectedCell(drinkId: String) {
        ui.setTitle("Drinks list")
        coordinator.navigate(to: .drinkDetails(id: drinkId))
    }
    
    func filterBy(ingradient: String) {
        self.ui.setHint(ingredients: availableIngradients(phrase: ingradient))
        
        self.ui.startLoading()
        
        self.drinksRepository.filterDrinksByIngradient(name: ingradient, completion: { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                case .success(let drinks):
                    self.refreshFiltered(drinksModel: DrinksModel(drinks: drinks))
                    
                case .failure(_):
                    self.refreshFiltered(drinksModel: .empty, phrase: ingradient)
            }
        })
    }
    
    private func refreshFiltered(drinksModel: DrinksModel, phrase: String="") {
        self.drinksModel = drinksModel
        self.ui.setTitle("Found \(drinksModel.items.count) drinks")
        self.ui.refreshList()
        
        if drinksModel.items.isEmpty {
            let message = "Sorry, we could not find results for phrase [\(phrase)]"
            self.ui.showFailureInfo(message: message)
        }
    }
    
    private func availableIngradients(phrase: String) -> String {
        let results = allIngredients.filter({ $0.contains(phrase) })
        return "Ingradients: "+results.joined(separator: ", ")
    }
}

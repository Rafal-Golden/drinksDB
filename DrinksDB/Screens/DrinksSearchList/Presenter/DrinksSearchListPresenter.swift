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
    private var searchByIngredient: Bool = false

    init(ui: DrinksSearchListInterfaceIn, coordinator: Coordinator,
         drinksRepository: DrinksRepositoryProtocol) {
        self.ui = ui
        self.coordinator = coordinator
        
        self.drinksModel = DrinksModel(items: [])
        self.drinksRepository = drinksRepository
    }
    
    // MARK: DrinksSearchListInterfaceOut
    
    @MainActor
    private func getRandomButtonInfo() {
        ui.setRandomButton(title: nil)
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let drinkDetails = try await drinksRepository.getRandomDrinkDetails()
                self.ui.setRandomButton(title: drinkDetails.name)
            } catch {
                print(">>> error \(error)")
            }
        }
    }
    
    @MainActor func didLoad() {
        drinksRepository.getIngredientsList(completion: { [weak self] result in
            self?.allIngredients = (try? result.get()) ?? []
        })

        getRandomButtonInfo()
        
        let searchViewModel = SearchViewModel(ingredientType: false)
        self.ui.setSearchTypeUI(searchViewModel)
    }
    
    func didSelectedCell(drinkId: String) {
        let title = NSLocalizedString("Drinks list", comment: "")
        ui.setTitle(title)
        coordinator.navigate(to: .drinkDetails(id: drinkId))
    }
    
    func searchBy(phrase: String) {
        let completion: (Result<Drinks, NSError>) -> Void = {  [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let drinks):
                    self.refreshFiltered(drinksModel: DrinksModel(drinks: drinks))
                    
                case .failure(_):
                    self.refreshFiltered(drinksModel: .empty, phrase: phrase)
            }
        }
        
        self.ui.setHint(ingredients: availableIngredients(phrase: phrase))
        
        self.ui.startLoading()
        
        if searchByIngredient {
            drinksRepository.filterDrinksByIngredient(name: phrase, completion: completion)
        } else {
            drinksRepository.searchDrinksBy(phrase: phrase, completion: completion)
        }
    }
    
    func didSelectedSearchTypeBy(ingredient: Bool, phrase: String) {
        searchByIngredient = ingredient
        searchBy(phrase: phrase)
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
    
    private func availableIngredients(phrase: String) -> String {
        let results = allIngredients.filter({ $0.contains(phrase) })
        return "Ingredients: "+results.joined(separator: ", ")
    }
}

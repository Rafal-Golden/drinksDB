//
//  DrinkDetailsPresenter.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 22-2-2023.
//

import Foundation

class DrinkDetailsPresenter: DrinkDetailsInterfaceOut
{
    weak var ui: DrinkDetailsInterfaceIn!
    var coordinator: Coordinator!
    
    private let drinkId: String
    private var drinksRepository: DrinksRepositoryProtocol?
    
    //private var imageDownloader: DrinkImageDownloader?
    
    init(ui: DrinkDetailsInterfaceIn, coordinator: Coordinator, drinkId: String) {
        self.ui = ui
        self.coordinator = coordinator
        self.drinkId = drinkId
        
        self.drinksRepository = AppMainModule.injectDrinksRepository()
    }
    
    // MARK: DrinkDetailsInterfaceOut
    
    func didLoad() {
        self.drinksRepository?.fetchDrinkDetails(id: drinkId, completion: { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success(let drinkDetails):
                    self.refreshDetails(drinkDetails: drinkDetails)
                    break
                case .failure(let error):
                    self.ui.showErrorAlert(message: error.localizedDescription)
                    break
            }
        })
    }
    
    func goBackAction() {
        coordinator.navigate(to: .back)
    }
    
    private func refreshDetails(drinkDetails: DrinkDetails) {
        let imageDownloader = DrinkImageDownloader(imageUrl: drinkDetails.imageUrl)
        imageDownloader.download(completed: { [weak self] image in
            if let self, let image {
                self.ui.refreshDrink(image: image)
            }
        })
        
        let model = DrinkDetailsModel(id: drinkDetails.id, name: drinkDetails.name, description: drinkDetails.instructions, ingradients: drinkDetails.ingredients, measures: drinkDetails.measures)
        
        self.ui.refreshDetails(model: model)
    }
}

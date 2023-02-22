//
//  DrinksRepository.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import Foundation

public protocol DrinksRepositoryProtocol {
    
    func filterDrinksByIngradient(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void)
    func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void)
    func getIngredientsList(completion: @escaping (Result<[String], NSError>) -> Void)
}

public final class DrinksRepository: DrinksRepositoryProtocol {
    
    private let service: DrinksServiceProtocol
    
    init(service: DrinksServiceProtocol) {
        self.service = service
    }
    
    public func filterDrinksByIngradient(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
        service.fetchDrinksUsingFilter(name: name, completion: completion)
    }
    
    public func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void) {
        service.fetchDrinkDetails(id: id, completion: completion)
    }
    
    public func getIngredientsList(completion: @escaping (Result<[String], NSError>) -> Void) {
        service.fetchIngradientsList { result in
            switch result {
                case .success(let ingredients):
                    let ingredientsList = ingredients.items.map({ $0.name })
                    completion(.success(ingredientsList))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

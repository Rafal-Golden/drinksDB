//
//  DrinksRepository.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import Foundation

public protocol DrinksRepositoryProtocol {
    
    func filterDrinksByIngredient(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void)
    func searchDrinksBy(phrase: String, completion: @escaping (Result<Drinks, NSError>) -> Void)
    func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void)
    func getIngredientsList(completion: @escaping (Result<[String], NSError>) -> Void)
    
    func getRandomDrinkDetails() async throws -> DrinkDetails
}

public final class DrinksRepository: DrinksRepositoryProtocol {
    
    private let service: DrinksServiceProtocol
    private let asyncService: AsyncDrinkServiceProtocol?
    
    init(service: DrinksServiceProtocol, asyncService: AsyncDrinkServiceProtocol?=nil) {
        self.service = service
        self.asyncService = asyncService
    }
    
    public func filterDrinksByIngredient(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
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
    
    public func getRandomDrinkDetails() async throws -> DrinkDetails {
        guard let asyncService else {
            throw NSError.appError(code: 11, description: "Async service not available!")
        }
        return try await asyncService.fetchRandomDrink()
    }
    
    public func searchDrinksBy(phrase: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
        service.fetchDrinksUsingSearch(name: phrase, completion: completion)
    }
}

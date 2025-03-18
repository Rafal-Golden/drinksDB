//
//  DrinksServiceMock.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 01/03/2023.
//

import Foundation

// MARK: - Mocks -

class DrinksServiceMock: DrinksServiceProtocol {
    
    var result: Result<Drinks, NSError> = .failure(CoreTests.NSErrors.unknown)
    var fetchDrinksUsingFilterCompleted = false
    
    func fetchDrinksUsingFilter(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
        fetchDrinksUsingFilterCompleted = true
        completion(result)
    }
    
    var resultDrinkDetails: Result<DrinkDetails, NSError> = .failure(CoreTests.NSErrors.unknown)
    var fetchDrinkDetailsCompleted = false
    
    func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void) {
        fetchDrinkDetailsCompleted = true
        completion(resultDrinkDetails)
    }
    
    var resultIngredients: Result<DrinkIngredients, NSError> = .failure(CoreTests.NSErrors.unknown)
    var fetchIngradientsListCompleted = false
    
    func fetchIngradientsList(completion: @escaping (Result<DrinkIngredients, NSError>) -> Void) {
        fetchIngradientsListCompleted = true
        completion(resultIngredients)
    }
    
    func fetchDrinksUsingSearch(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
        
    }
}

//
//  DrinksService.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import Foundation

public protocol DrinksServiceProtocol {
    
    func fetchDrinksUsingFilter(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void)
    func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void)
    func fetchIngradientsList(completion: @escaping (Result<DrinkIngredients, NSError>) -> Void)
    func fetchDrinksUsingSearch(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void)
}

public final class DrinksService: DrinksServiceProtocol {
    
    private let apiRequestService = APIRequestService()
    
    private var filterDrinksTask: URLSessionDataTask?
    
    public func fetchDrinksUsingFilter(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/filter.php"
        let queryItems = [
            URLQueryItem(name: "i", value: name)
        ]
        let request = apiRequestService.request(method: "GET", path: path, queryItems: queryItems)
        
        filterDrinksTask?.cancel()
        filterDrinksTask = apiRequestService.runJson(request: request, completion: completion)
    }
    
    public func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void) {
        fetchDrinkDetailsContainer(id: id) { result in
            switch result {
                case .success(let drinkDetailsContainer):
                    if drinkDetailsContainer.drinks.count > 0 {
                        completion(.success(drinkDetailsContainer.drinks[0]))
                    } else {
                        completion(.success(DrinkDetails.blank))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    private func fetchDrinkDetailsContainer(id: String, completion: @escaping (Result<DrinkDetailsContainer, NSError>) -> Void) {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php"
        let queryItems = [
            URLQueryItem(name: "i", value: id)
        ]
        let request = apiRequestService.request(method: "GET", path: path, queryItems: queryItems)
        
        _ = apiRequestService.runJson(request: request, completion: completion)
    }
    
    public func fetchIngradientsList(completion: @escaping (Result<DrinkIngredients, NSError>) -> Void) {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/list.php"
        let queryItems = [
            URLQueryItem(name: "i", value: "list")
        ]
        let request = apiRequestService.request(method: "GET", path: path, queryItems: queryItems)
        
        _ = apiRequestService.runJson(request: request, completion: completion)
    }
    
    public func fetchDrinksUsingSearch(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
        let path = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
        let queryItems = [
            URLQueryItem(name: "s", value: name)
        ]
        let request = apiRequestService.request(method: "GET", path: path, queryItems: queryItems)
        
        filterDrinksTask?.cancel()
        filterDrinksTask = apiRequestService.runJson(request: request, completion: completion)
    }
}

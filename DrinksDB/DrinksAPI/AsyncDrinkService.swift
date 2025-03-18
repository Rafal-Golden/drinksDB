//
//  AsyncDrinkService.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 28/02/2025.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// extend URLSession, to implement our protocol
extension URLSession: URLSessionProtocol {}

protocol AsyncDrinkServiceProtocol {
    func fetchRandomDrink() async throws -> DrinkDetails
}

final class AsyncDrinkService: AsyncDrinkServiceProtocol {
    
    let urlSession: URLSessionProtocol
    let baseURL: URL
    
    init(urlSession: URLSessionProtocol, baseURL: URL? = nil) {
        self.urlSession = urlSession
        self.baseURL = baseURL ?? URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")!
    }
    
    func fetchRandomDrink() async throws -> DrinkDetails {
        let urlPath = baseURL.appendingPathComponent("random.php")
        
        do {
            let (data, response) = try await urlSession.data(from: urlPath)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NSError.appError(code: 5, description: "Response error!")
            }
            
            let decoder = JSONDecoder()
            let drinkDetailsContainer = try decoder.decode(DrinkDetailsContainer.self, from: data)
            
            guard let drinkDetails = drinkDetailsContainer.drinks.first else {
                throw NSError.appError(code: 6, description: "Empty Response error!")
            }
            
            return drinkDetails
        }
        catch let error as NSError {
            if let decodeErr = error as? DecodingError {
                throw NSError.appError(code: 7, description: "JSON decoding error! \(decodeErr)")
            } else if error.code != 5 {
                throw NSError.appError(code: 4, description: "Service connection error! \(error)")
            }
            throw error
        }
    }
}

extension AsyncDrinkService {
    convenience init() {
        self.init(urlSession: URLSession.shared)
    }
}

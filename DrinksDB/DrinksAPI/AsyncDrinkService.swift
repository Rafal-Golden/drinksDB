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
        
        let data = try await fetchData(from: urlPath)
        let decoder = JSONDecoder()
        let drinkDetailsContainer = try decoder.decode(DrinkDetailsContainer.self, from: data)
        
        guard let drinkDetails = drinkDetailsContainer.drinks.first else {
            throw NSError.appError(code: 6, description: "Empty Response error!")
        }
        
        return drinkDetails
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await urlSession.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NSError.appError(code: 5, description: "Invalid response!")
            }
            return data
        } catch {
            throw handleError(error)
        }
    }
    
    private func handleError(_ error: Error) -> NSError {
        if let decodingError = error as? DecodingError {
            return NSError.appError(code: 7, description: "JSON decoding error: \(decodingError)")
        } else if (error as NSError).code != 5 {
            return NSError.appError(code: 4, description: "Service connection error: \(error)")
        }
        return error as NSError
    }
}

extension AsyncDrinkService {
    convenience init() {
        self.init(urlSession: URLSession.shared)
    }
}

//
//  Drinks.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import Foundation

public struct DrinkItem: Codable, Equatable {
    var name: String
    var imageUrl: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case imageUrl = "strDrinkThumb"
    }
}

public struct Drinks: Codable, Equatable {
    var items: [DrinkItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "drinks"
    }
}

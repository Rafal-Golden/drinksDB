//
//  Ingradients.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 22/02/2023.
//

import Foundation

public struct DrinkIngredient: Codable, Equatable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strIngredient1"
    }
}

public struct DrinkIngredients: Codable, Equatable {
    var items: [DrinkIngredient]
    
    enum CodingKeys: String, CodingKey {
        case items = "drinks"
    }
}

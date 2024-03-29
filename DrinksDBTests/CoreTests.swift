//
//  CoreTests.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 02/03/2023.
//

import Foundation

@testable import DrinksDB


struct CoreTests {
    struct NSErrors {
        static let unknown = NSError(domain: "Unknown domain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown description"])
        static let generalError = NSError(domain: "UnitTest.Error", code: 111, userInfo: [NSLocalizedDescriptionKey: "General Error used for unit testing"])
    }
    
    struct MyDrinks {
        struct Ingredients {
            static let milk = DrinkIngredients(items: [DrinkIngredient(name: "Milk")])
            static let water = DrinkIngredients(items: [DrinkIngredient(name: "Water"), DrinkIngredient(name: "WaterMelon")])
        }
        
        static let waterMelonDrinkItem = DrinkItem(name: "Water Melon Coctail", imageUrl: "-", id: "1")
        
        static let withWater = Drinks(items: [DrinkItem(name: "Water Melon Coctail", imageUrl: "-", id: "1"), DrinkItem(name: "Chocolate Drink", imageUrl: "-", id: "2")])
    }
}

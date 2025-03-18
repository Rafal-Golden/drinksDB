//
//  CoreTests.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 02/03/2023.
//

import XCTest

@testable import DrinksDB


struct CoreTests {
    struct NSErrors {
        static let unknown = NSError.testError(code: 999, description: "Unknown description")
        static let generalError = NSError.testError(code: 111, description: "General Error used for unit testing")
    }
    
    struct HTTPURLResponses {
        static let status500 = HTTPURLResponse(url: URL(string: "https://unit.tests.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        static let statusOK = HTTPURLResponse(url: URL(string: "https://unit.tests.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    }
    
    struct MyDrinks {
        struct Ingredients {
            static let milk = DrinkIngredients(items: [DrinkIngredient(name: "Milk")])
            static let water = DrinkIngredients(items: [DrinkIngredient(name: "Water"), DrinkIngredient(name: "WaterMelon")])
        }
        
        static let waterMelonDrinkItem = DrinkItem(name: "Water Melon Coctail", imageUrl: "-", id: "1")
        
        static let withWater = Drinks(items: [DrinkItem(name: "Water Melon Coctail", imageUrl: "-", id: "1"), DrinkItem(name: "Chocolate Drink", imageUrl: "-", id: "2")])
        
        struct Details {
            static let chocoDrink: DrinkDetails = MyDrinks.Container.chocoDrink.drinks[0]
        }
        
        struct Container {
            static let chocoDrink: DrinkDetailsContainer = decodeObject(fileName: "obj_drink_details_choco")
        }
    }
}

extension NSError {
    static func testError(code: Int, description: String) -> NSError {
        return NSError(domain: "UnitTest.Error", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}

extension CoreTests {
    
    class DummyClass {}
    
    static func decodeObject<T: Decodable>(fileName: String) -> T {
        do {
            let data = try dataFromFile(fileName)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            XCTFail("❌ JSON decoding error for file \(fileName).json: \(error)")
            fatalError("⛔️ Critical error: Failed to decode \(fileName).json. Details: \(error)")
        }
    }

    static func dataFromFile(_ fileName: String) throws -> Data {
        let bundle = Bundle(for: DummyClass.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw NSError.testError(code: 404, description: "File \(fileName).json not found")
        }
        return try Data(contentsOf: url)
    }
}

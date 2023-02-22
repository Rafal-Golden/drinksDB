//
//  DrinkDetails.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 22/02/2023.
//

import Foundation

public struct DrinkDetails: Codable, Equatable {
    
    static let blank = DrinkDetails(name: "", imageUrl: "", id: "", instructions: "")
    
    var name: String
    var imageUrl: String
    var id: String
    var instructions: String
    var category: String?
    var tags: String?
    var alcoholic: String?
    var glass: String?
    
    private var strIngredient1: String?
    private var strIngredient2: String?
    private var strIngredient3: String?
    private var strIngredient4: String?
    private var strIngredient5: String?
    private var strIngredient6: String?
    private var strIngredient7: String?
    private var strIngredient8: String?
    private var strIngredient9: String?
    private var strIngredient10: String?
    private var strIngredient11: String?
    private var strIngredient12: String?
    private var strIngredient13: String?
    private var strIngredient14: String?
    private var strIngredient15: String?
    
    private var strMeasure1: String?
    private var strMeasure2: String?
    private var strMeasure3: String?
    private var strMeasure4: String?
    private var strMeasure5: String?
    private var strMeasure6: String?
    private var strMeasure7: String?
    private var strMeasure8: String?
    private var strMeasure9: String?
    private var strMeasure10: String?
    private var strMeasure11: String?
    private var strMeasure12: String?
    private var strMeasure13: String?
    private var strMeasure14: String?
    private var strMeasure15: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case imageUrl = "strDrinkThumb"
        case instructions = "strInstructions"
        
        case category = "strCategory"
        case tags = "strTags"
        case alcoholic = "strAlcoholic"
        case glass = "strGlass"
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
    }
    
    var ingredients: [String] {
        let properties = Mirror(reflecting: self).children
        var allIngredients: [String] = []
        
        for property in properties where property.label?.contains("strIngredient") == true {
            if let ingredient = property.value as? String {
                allIngredients.append(ingredient)
            }
        }
        return allIngredients
    }
    
    var measures: [String] {
        let properties = Mirror(reflecting: self).children
        var allMeasures: [String] = []
        
        for property in properties where property.label?.contains("strMeasure") == true {
            if let measure = property.value as? String {
                allMeasures.append(measure)
            }
        }
        
        return allMeasures
    }
}

public struct DrinkDetailsContainer: Codable, Equatable {
    var drinks: [DrinkDetails]
}

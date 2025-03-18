//
//  DrinksModel.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21/02/2023.
//

import UIKit

struct DrinkItemCellModel {
    var id: String
    var title: String
    var imageUrl: String
}

public class DrinksModel: NSObject {
    
    var items: [DrinkItemCellModel]
    
    init(items: [DrinkItemCellModel]) {
        self.items = items
    }
    
    init(drinks: Drinks) {
        self.items = drinks.items.map {
            DrinkItemCellModel(id: $0.id, title: $0.name, imageUrl: $0.imageUrl)
        }
    }
    
    static let empty = DrinksModel(items: [])
}

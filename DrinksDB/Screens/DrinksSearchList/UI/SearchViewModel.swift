//
//  SearchViewModel.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 17/03/2025.
//

import Foundation

struct SearchViewModel {
    let placeholder: String
    let searchTitle: String
    let ingredientTitle: String
    let ingredientType: Bool
}

extension SearchViewModel {
    init(ingredientType: Bool) {
        let placeholder: String
        if ingredientType {
            placeholder = NSLocalizedString("Type drink ingredient name", comment: "")
        } else {
            placeholder = NSLocalizedString("Type drink name", comment: "")
        }
        
        let searchTitle = NSLocalizedString("Search", comment: "")
        let ingredientTitle = NSLocalizedString("Ingredient", comment: "")
        
        self.init(placeholder: placeholder, searchTitle: searchTitle, ingredientTitle: ingredientTitle, ingredientType: ingredientType)
    }
}

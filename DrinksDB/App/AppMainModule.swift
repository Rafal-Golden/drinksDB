//
//  AppMainModule.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21/02/2023.
//

import Foundation

class AppMainModule {
    
    class func injectDrinksRepository() -> DrinksRepositoryProtocol {
        let service = DrinksService()
        return DrinksRepository(service: service)
    }
}

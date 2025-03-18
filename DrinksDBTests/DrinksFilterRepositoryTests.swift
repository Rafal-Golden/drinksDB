//
//  DrinksRepositoryTests.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import XCTest

@testable import DrinksDB

import Foundation // NSError

final class DrinksRepositoryTests: XCTestCase {
    
    var sut: DrinksRepository!
    
    private var dummyError: NSError!
    private var dummyDrinks: Drinks!
    private var dummyDrinkDetails: DrinkDetails!
    private var dummyDrinkIngradients: DrinkIngredients!
    private var serviceMock: DrinksServiceMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        dummyError = CoreTests.NSErrors.generalError
        dummyDrinks = Drinks(items: [])
        dummyDrinkDetails = DrinkDetails.blank
        dummyDrinkIngradients = CoreTests.MyDrinks.Ingredients.milk
        
        serviceMock = DrinksServiceMock()
        
        sut = DrinksRepository(service: serviceMock)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        
        dummyError = nil
        dummyDrinks = nil
        serviceMock = nil
    }
    
    // MARK: - Tests -

    func testFilterByIngradient_failed_returnError() throws {
        // Given
        serviceMock.result = .failure(dummyError)
        let ingradientName = "Lemon"
        var filterDrinksCompleted = false
        
        // When
        sut.filterDrinksByIngredient(name: ingradientName) { result in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    filterDrinksCompleted = true
                    XCTAssertEqual(error, self.dummyError)
            }
        }
        
        // Expected result
        XCTAssertTrue(filterDrinksCompleted)
        XCTAssertTrue(serviceMock.fetchDrinksUsingFilterCompleted)
    }
    
    func testFilterByIngradient_succeeded_returnDrink() throws {
        // Given
        serviceMock.result = .success(dummyDrinks)
        let ingradientName = "Lemon"
        var filterDrinksCompleted = false
        
        // When
        sut.filterDrinksByIngredient(name: ingradientName) { result in
            switch result {
                case .success(let filteredDrinks):
                    filterDrinksCompleted = true
                    XCTAssertEqual(filteredDrinks, self.dummyDrinks)
                case .failure(_):
                    break
            }
        }
        
        // Expected result
        XCTAssertTrue(filterDrinksCompleted)
        XCTAssertTrue(serviceMock.fetchDrinksUsingFilterCompleted)
    }
    
    func testFetchDrinkDetails_failed_returnError() throws {
        // Given
        serviceMock.resultDrinkDetails = .failure(dummyError)
        let id = "drink123"
        var fetchDetailsCompleted = false
        
        // When
        sut.fetchDrinkDetails(id: id) { result in
            switch result {
                case .success(_):
                    break
                    
                case .failure(let error):
                    fetchDetailsCompleted = true
                    XCTAssertEqual(error, self.dummyError)
            }
        }
        
        // Expected result
        XCTAssertTrue(fetchDetailsCompleted)
        XCTAssertTrue(serviceMock.fetchDrinkDetailsCompleted)
    }
    
    func testFetchDrinkDetails_succeeded_returnDetails() throws {
        // Given
        serviceMock.resultDrinkDetails = .success(dummyDrinkDetails)
        let id = "drink123"
        var fetchDetailsCompleted = false
        
        // When
        sut.fetchDrinkDetails(id: id) { result in
            switch result {
                case .success(let drinkDetails):
                    fetchDetailsCompleted = true
                    XCTAssertEqual(drinkDetails, self.dummyDrinkDetails)
                    
                case .failure(_):
                    break
            }
        }
        
        // Expected result
        XCTAssertTrue(fetchDetailsCompleted)
        XCTAssertTrue(serviceMock.fetchDrinkDetailsCompleted)
    }
    
    func testGetIngredients_failed_returnError() throws {
        // Given
        serviceMock.resultIngredients = .failure(dummyError)
        var getIngedientsCompleted = false
        
        // When
        sut.getIngredientsList(completion: { result in
            switch result {
                case .failure(let error):
                    getIngedientsCompleted = true
                    XCTAssertEqual(error, self.dummyError)
                    
                case .success(_):
                    break
            }
        })
        
        // Expected result
        XCTAssertTrue(getIngedientsCompleted)
        XCTAssertTrue(serviceMock.fetchIngradientsListCompleted)
    }
    
    func testGetIngredients_succeeded_returnIngredientsList() throws {
        // Given
        serviceMock.resultIngredients = .success(dummyDrinkIngradients)
        let expectedList = dummyDrinkIngradients.items.map({ $0.name })
        var getIngedientsCompleted = false
        
        // When
        sut.getIngredientsList(completion: { result in
            switch result {
                case .success(let ingredients):
                    getIngedientsCompleted = true
                    XCTAssertEqual(ingredients, expectedList)
                    
                case .failure(_):
                    break
            }
        })
        
        // Expected result
        XCTAssertTrue(getIngedientsCompleted)
        XCTAssertTrue(serviceMock.fetchIngradientsListCompleted)
    }
}

//
//  DrinksRepositoryTests.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 20/02/2023.
//

import XCTest

@testable import DrinksDB

import Foundation // NSError

struct CoreTests {
    struct NSErrors {
        static let unknown = NSError(domain: "Unknown domain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown description"])
        static let generalError = NSError(domain: "UnitTest.Error", code: 111, userInfo: [NSLocalizedDescriptionKey: "General Error used for unit testing"])
    }
    
    static let drinkIngredientsMilk = DrinkIngredients(items: [DrinkIngredient(name: "Milk")])
}

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
        dummyDrinkIngradients = CoreTests.drinkIngredientsMilk
        
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
    
    // MARK: - Mocks -
    
    class DrinksServiceMock: DrinksServiceProtocol {
        
        var result: Result<Drinks, NSError> = .failure(CoreTests.NSErrors.unknown)
        var fetchDrinksUsingFilterCompleted = false
        
        func fetchDrinksUsingFilter(name: String, completion: @escaping (Result<Drinks, NSError>) -> Void) {
            fetchDrinksUsingFilterCompleted = true
            completion(result)
        }
        
        var resultDrinkDetails: Result<DrinkDetails, NSError> = .failure(CoreTests.NSErrors.unknown)
        var fetchDrinkDetailsCompleted = false
        
        func fetchDrinkDetails(id: String, completion: @escaping (Result<DrinkDetails, NSError>) -> Void) {
            fetchDrinkDetailsCompleted = true
            completion(resultDrinkDetails)
        }
        
        var resultIngredients: Result<DrinkIngredients, NSError> = .failure(CoreTests.NSErrors.unknown)
        var fetchIngradientsListCompleted = false
        
        func fetchIngradientsList(completion: @escaping (Result<DrinkIngredients, NSError>) -> Void) {
            fetchIngradientsListCompleted = true
            completion(resultIngredients)
        }
    }
    
    // MARK: - Tests -

    func testFilterByIngradient_failed_returnError() throws {
        // Given
        serviceMock.result = .failure(dummyError)
        let ingradientName = "Lemon"
        var filterDrinksCompleted = false
        
        // When
        sut.filterDrinksByIngradient(name: ingradientName) { result in
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
        sut.filterDrinksByIngradient(name: ingradientName) { result in
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

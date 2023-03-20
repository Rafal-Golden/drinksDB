//
//  DrinksSearchListPresenterTests.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 28/02/2023.
//

import XCTest

@testable import DrinksDB

final class DrinksSearchListPresenterTests: XCTestCase {
    
    var sut: DrinksSearchListPresenter!
    
    private var dummyError: NSError!
    
    private var drinksSearchListUIMock: DrinksSearchListInterfaceInMock!
    private var coordinatorMock: CoordinatorMock!
    private var drinksServiceMock: DrinksServiceMock!
    private var drinksRepositoryMock: DrinksRepositoryProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        dummyError = CoreTests.NSErrors.generalError
        
        drinksSearchListUIMock = DrinksSearchListInterfaceInMock()
        coordinatorMock = CoordinatorMock()
        
        drinksServiceMock = DrinksServiceMock()
        drinksRepositoryMock = DrinksRepository(service: drinksServiceMock)
        
        sut = DrinksSearchListPresenter(ui: drinksSearchListUIMock, coordinator: coordinatorMock,
                                        drinksRepository: drinksRepositoryMock)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
        
        dummyError = nil
        coordinatorMock = nil
        drinksSearchListUIMock = nil
        
        drinksServiceMock = nil
        drinksRepositoryMock = nil
    }
    
    // MARK: - MOCKS -
    
    class CoordinatorMock: Coordinator {
        
        func start() {
            
        }
        
        var navigatedIntoDetails = false
        var navigatedIntoDestination: Destination = .back
        
        func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void) {
            if case .drinkDetails(_) = destination  {
                navigatedIntoDetails = true
            }
            navigatedIntoDestination = destination
        }
    }
    
    class DrinksSearchListInterfaceInMock: DrinksSearchListInterfaceIn {
        
        var startLoadingCalled = false
        var refreshListCalled = false
        var showFailureInfoCalled = false
        
        func startLoading() {
            startLoadingCalled = true
        }
        
        func refreshList() {
            refreshListCalled = true
        }
        
        func showFailureInfo(message: String) {
            showFailureInfoCalled = true
        }
        
        func setTitle(_ title: String) {
            
        }
        
        var hintIngredients: String = ""
        
        func setHint(ingredients: String) {
            hintIngredients = ingredients
            print(">>> setHint ingradients [\(ingredients)]")
        }
    }
    

    func testSearchWater_success_returnsSomething() throws {
        // Given
        let dummyIngradientsWater = CoreTests.MyDrinks.Ingredients.water
        drinksServiceMock.resultIngredients = .success(dummyIngradientsWater)
        drinksServiceMock.result = .success(CoreTests.MyDrinks.withWater)
        
        // When
        sut.didLoad()
        sut.filterBy(ingradient: "Water")
        
        // Expected result
        XCTAssertTrue(sut.drinksModel.items.count > 0)
        XCTAssertTrue(drinksSearchListUIMock.hintIngredients.count > 0)
        
        XCTAssertTrue(drinksSearchListUIMock.startLoadingCalled)
        XCTAssertTrue(drinksSearchListUIMock.refreshListCalled)
    }
    
    func testSearchWater_failed_returnsNothing() throws {
        // Given
        drinksServiceMock.resultIngredients = .failure(dummyError)
        
        // When
        sut.didLoad()
        sut.filterBy(ingradient: "Water")
        
        // Expected result
        XCTAssertTrue(sut.drinksModel.items.count == 0)
        XCTAssertTrue(drinksSearchListUIMock.hintIngredients.count > 0)
        
        XCTAssertTrue(drinksSearchListUIMock.startLoadingCalled)
        XCTAssertTrue(drinksSearchListUIMock.refreshListCalled)
        XCTAssertTrue(drinksSearchListUIMock.showFailureInfoCalled)
    }
    
    func testDidSelectCell_opens_drinkDetails() throws {
        // Given
        let selectedDrinkItem = CoreTests.MyDrinks.waterMelonDrinkItem
        
        // When
        sut.didSelectedCell(drinkId: selectedDrinkItem.id)
        
        // Expected result
        XCTAssertTrue(coordinatorMock.navigatedIntoDetails)
        if case .drinkDetails(let id) = coordinatorMock.navigatedIntoDestination {
            XCTAssertEqual(selectedDrinkItem.id, id)
        }
    }
}

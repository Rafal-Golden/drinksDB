//
//  RandomDrinkServiceTests.swift
//  DrinksDBTests
//
//  Created by Rafal Korzynski on 28/02/2025.
//

import XCTest

final class AsyncDrinkServiceTests: XCTestCase {
    
    var sut: AsyncDrinkService!
    var urlSessionMock: URLSessionMock!

    override func setUp() {
        super.setUp()
        
        urlSessionMock = URLSessionMock()
        sut = AsyncDrinkService(urlSession: urlSessionMock)
    }

    override func tearDown() {
        sut = nil
        urlSessionMock = nil
        super.tearDown()
    }
    
    func testBaseUrl_IsValid() {
        XCTAssertFalse(sut.baseURL.absoluteString.isEmpty)
        XCTAssertTrue(sut.baseURL.absoluteString.contains("/api/json/v1/1/"))
        XCTAssertEqual(sut.baseURL.absoluteString.last, "/")
        XCTAssertEqual(sut.baseURL.scheme, "https")
    }

    func testFetchRandomDrink_ServiceFails_ReturnsError() async throws {
        urlSessionMock.returnError = CoreTests.NSErrors.generalError
        let expectedError = NSError.appError(code: 4, description: "Service not available")
        do {
            _ = try await sut.fetchRandomDrink()
            XCTFail("Expected failure, but function succeeded!")
        }
        catch let error as NSError {
            XCTAssertEqual(error.domain, expectedError.domain)
            XCTAssertEqual(error.code, expectedError.code)
        }
    }
    
    func testFetchRandomDrink_ResponseFails_ReturnsError() async throws {
        urlSessionMock.returnError = nil
        urlSessionMock.returnResponse = CoreTests.HTTPURLResponses.status500
        
        let expectedError = NSError.appError(code: 5, description: "Response error!")
        do {
            _ = try await sut.fetchRandomDrink()
            XCTFail("Expected failure, but function succeeded!")
        }
        catch let error as NSError {
            XCTAssertEqual(error.domain, expectedError.domain)
            XCTAssertEqual(error.code, expectedError.code)
        }
    }
    
    func testFetchRandomDrink_Success_ReturnsDrinkDetails() async throws {
        urlSessionMock.returnResponse = CoreTests.HTTPURLResponses.statusOK
        let expectedDrinkDetails = CoreTests.MyDrinks.details.chocoDrink
        urlSessionMock.setData(type: expectedDrinkDetails)
        
        do {
            let fetchedDrinkDetails = try await sut.fetchRandomDrink()
            
            XCTAssertEqual(fetchedDrinkDetails, expectedDrinkDetails)
        }
        catch {
            XCTFail("Expected success, but function failed with error \(error)")
        }
    }
}


class URLSessionMock: URLSessionProtocol {
    var returnData: Data?
    var returnResponse: URLResponse?
    var returnError: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = returnError { throw error }
        
        return (returnData ?? Data(), returnResponse ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
    
    func setData<T: Encodable>(type: T) {
        let encoder = JSONEncoder()
        returnData = try? encoder.encode(type)
    }
}

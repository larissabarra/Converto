//
//  FrankfurterCurrencyServiceTests.swift
//  ConvertoTests
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation
import XCTest

@testable import Converto

class FrankfurterCurrencyServiceTests: XCTestCase {
    
    var service: FrankfurterCurrencyService!
    var apiServiceMock: APIServiceMock!
    
    override func setUp() {
        super.setUp()
        
        apiServiceMock = APIServiceMock()
        service = FrankfurterCurrencyService(apiService: apiServiceMock)
    }
    
    override func tearDown() {
        super.tearDown()
        
        apiServiceMock = nil
        service = nil
    }
    
    func testFetchCurrenciesCallsRightParameters() {
        apiServiceMock.expectedResult = [
            Currency(code: "USD", name: "United States Dollar"),
            Currency(code: "EUR", name: "Euro"),
            Currency(code: "JPY", name: "Japanese Yen")
        ]
        
        var resultCurrencies: [Currency]?
        var resultError: Error?
        
        service.fetchCurrencies { result in
            switch result {
                case .success(let currencies):
                    resultCurrencies = currencies
                case .failure(let error):
                    resultError = error
            }
        }
        
        let expectation = XCTestExpectation(description: "Fetch currencies succeed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(resultError)
            XCTAssertEqual(self.apiServiceMock.url, URL(string: "\(self.service.basePath)/currencies"))
            XCTAssertTrue(self.apiServiceMock.dataType is [String: String].Type)
            XCTAssertTrue(self.apiServiceMock.responseType is [Currency].Type)
            XCTAssertEqual(resultCurrencies?.count, 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchExchangeRatesCallsRightParameters() {
        let yen = Currency(code: "JPY", name: "Japanese Yen")
        
        apiServiceMock.expectedResult = LatestExchangeRates(amount: 1, base: yen.code, date: "", rates: ["USD": 1, "EUR": 2])
        
        var resultRates: LatestExchangeRates?
        var resultError: Error?
        
        service.fetchLatestExchangeRates(for: yen) { result in
            switch result {
                case .success(let rates):
                    resultRates = rates
                case .failure(let error):
                    resultError = error
            }
        }
        
        let expectation = XCTestExpectation(description: "Fetch exchange rates succeed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(resultError)
            XCTAssertEqual(self.apiServiceMock.url, URL(string: "\(self.service.basePath)/latest?amount=1.0&from=JPY"))
            XCTAssertTrue(self.apiServiceMock.dataType is LatestExchangeRates.Type)
            XCTAssertTrue(self.apiServiceMock.responseType is LatestExchangeRates.Type)
            XCTAssertEqual(resultRates?.rates.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

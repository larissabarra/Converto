//
//  AppViewModelTests.swift
//  ConvertoTests
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation
import XCTest

@testable import Converto

class AppViewModelTests: XCTestCase {
    
    var viewModel: ConvertoApp.ViewModel!
    var mockAPIService: CurrencyServiceMock!
    
    override func setUp() {
        super.setUp()
        mockAPIService = CurrencyServiceMock()
        viewModel = ConvertoApp.ViewModel(currencyService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchCurrenciesSuccess() {
        mockAPIService.currencies = [
            Currency(code: "USD", name: "United States Dollar"),
            Currency(code: "EUR", name: "Euro"),
            Currency(code: "JPY", name: "Japanese Yen")
        ]
        
        let expectation = XCTestExpectation(description: "Fetch currencies should succeed")
        
        viewModel.fetchCurrencies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.currencies.count, 3)
            XCTAssertEqual(self.viewModel.viewState, .loaded)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCurrenciesFailure() {
        mockAPIService.error = URLError(.unknown)
        
        let expectation = XCTestExpectation(description: "Fetch currencies should fail")
        
        viewModel.fetchCurrencies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.currencies.count, 0)
            XCTAssertEqual(self.viewModel.viewState, .error(message: URLError(.unknown).localizedDescription))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

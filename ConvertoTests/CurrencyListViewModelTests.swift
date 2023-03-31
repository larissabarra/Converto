//
//  CurrencyListViewModelTests.swift
//  ConvertoTests
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation
import XCTest

@testable import Converto

class CurrencyListViewModelTests: XCTestCase {
    
    var currencyListViewModel: CurrencyList.ViewModel!
    var mockAPIService: CurrencyServiceMock!
    
    override func setUp() {
        super.setUp()
        mockAPIService = CurrencyServiceMock()
        currencyListViewModel = CurrencyList.ViewModel(currencyService: mockAPIService)
    }
    
    override func tearDown() {
        currencyListViewModel = nil
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
        
        currencyListViewModel.fetchCurrencies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.currencyListViewModel.currencies.count, 3)
            XCTAssertEqual(self.currencyListViewModel.viewState, .loaded)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCurrenciesFailure() {
        mockAPIService.error = URLError(.unknown)
        
        let expectation = XCTestExpectation(description: "Fetch currencies should fail")
        
        currencyListViewModel.fetchCurrencies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.currencyListViewModel.currencies.count, 0)
            XCTAssertEqual(self.currencyListViewModel.viewState, .error(message: URLError(.unknown).localizedDescription))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchLatestExchange() {
        let gbp = Currency(code: "GBP", name: "British Pound")
        let eur = Currency(code: "EUR", name: "Euro")
        mockAPIService.currencies = [gbp, eur]
        mockAPIService.exchangeRates = LatestExchangeRates(amount: 1,
                                                           base: "BRL",
                                                           date: "2023-03-28",
                                                           rates: ["GBP" : 6, "EUR": 5])
        
        let expectation = XCTestExpectation(description: "Fetch exchange rates should succeed")
        
        currencyListViewModel.fetchCurrencies()
        currencyListViewModel.latestFrom(Currency(code: "BRL", name: "Brazilian Real"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.currencyListViewModel.exchangeRates[gbp], 6)
            XCTAssertEqual(self.currencyListViewModel.exchangeRates[eur], 5)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

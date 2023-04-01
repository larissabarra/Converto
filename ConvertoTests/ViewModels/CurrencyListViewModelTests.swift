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
    
    var viewModel: CurrencyList.ViewModel!
    var mockCurrencyService: CurrencyServiceMock!
    
    override func setUp() {
        super.setUp()
        mockCurrencyService = CurrencyServiceMock()
        viewModel = CurrencyList.ViewModel(currencyService: mockCurrencyService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCurrencyService = nil
        super.tearDown()
    }
    
    func testFetchLatestExchange() {
        let gbp = Currency(code: "GBP", name: "British Pound")
        let eur = Currency(code: "EUR", name: "Euro")
        mockCurrencyService.currencies = [gbp, eur]
        mockCurrencyService.exchangeRates = LatestExchangeRates(amount: 1,
                                                           base: "BRL",
                                                           date: "2023-03-28",
                                                           rates: ["GBP" : 6, "EUR": 5])
        
        let expectation = XCTestExpectation(description: "Fetch exchange rates should succeed")
        
        viewModel.latestFrom(Currency(code: "BRL", name: "Brazilian Real"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.exchangeRates[gbp.code], 6)
            XCTAssertEqual(self.viewModel.exchangeRates[eur.code], 5)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

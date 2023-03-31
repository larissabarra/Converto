//
//  ConversionsTabViewModelTests.swift
//  ConvertoTests
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation
import XCTest

@testable import Converto

class ConversionsTabViewModelTests: XCTestCase {
    
    var viewModel: ConversionsTab.ViewModel!
    var mockAPIService: CurrencyServiceMock!
    
    override func setUp() {
        super.setUp()
        mockAPIService = CurrencyServiceMock()
        viewModel = ConversionsTab.ViewModel(currencyService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchExchangeRates() {
        let gbp = Currency(code: "GBP", name: "British Pound")
        let eur = Currency(code: "EUR", name: "Euro")
        mockAPIService.currencies = [gbp, eur]
        mockAPIService.exchangeRates = LatestExchangeRates(amount: 1,
                                                           base: "GBP",
                                                           date: "2023-03-29",
                                                           rates: ["EUR": 1.14])
        
        let expectation = XCTestExpectation(description: "Fetch exchange rates should succeed")
        
        viewModel.isEditing = true
        viewModel.fromCurrency = gbp
        viewModel.toCurrency = eur
        viewModel.fromAmount = "1"
        viewModel.convert(updated: .fromAmount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.toAmount, "1.14")
            XCTAssertFalse(self.viewModel.isEditing)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

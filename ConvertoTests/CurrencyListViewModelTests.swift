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
    
    @MainActor override func setUp() {
        super.setUp()
        mockAPIService = CurrencyServiceMock()
        currencyListViewModel = CurrencyList.ViewModel(currencyService: mockAPIService)
    }
    
    override func tearDown() {
        currencyListViewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    @MainActor func testFetchCurrenciesSuccess() {
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
    
    @MainActor func testFetchCurrenciesFailure() {
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
}

class CurrencyServiceMock: CurrencyService {
    var currencies: [Converto.Currency]?
    var error: Error?
    
    func fetchCurrencies(completion: @escaping (Result<[Converto.Currency], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let currencies = currencies {
            completion(.success(currencies))
        }
    }
}

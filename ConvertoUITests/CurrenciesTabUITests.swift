//
//  CurrenciesTabUITests.swift
//  ConvertoUITests
//
//  Created by Larissa Barra on 27/03/2023.
//

import XCTest
import OHHTTPStubs

final class CurrenciesTabUITests: BaseUITestCase {
    
    func testCurrenciesTab() {
        let currenciesFixture = loadFixture(named: "Currencies")
        let audRatesFixture = loadFixture(named: "LatestAUD")
        
        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("/currencies") ?? false
        }, withStubResponse: { request in
            return HTTPStubsResponse(data: currenciesFixture, statusCode: 200, headers: nil)
        })
        
        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.absoluteString.contains("/latest?from=AUD") ?? false
        }, withStubResponse: { request in
            return HTTPStubsResponse(data: audRatesFixture, statusCode: 200, headers: nil)
        })
        
        let cells = app.collectionViews["currenciesTab.currencies.list"].cells
        XCTAssert(cells.count > 0, "List is empty")
        
        let aud = cells.firstMatch
        XCTAssertTrue(aud.staticTexts["AUD"].exists)
        XCTAssertTrue(aud.staticTexts["Australian Dollar"].exists)
        
        aud.tap()
        
        let brl = cells.element(boundBy: 2)
        XCTAssertTrue(brl.staticTexts["BRL"].exists)
        XCTAssertTrue(brl.staticTexts["R$3.39"].exists)
    }
}

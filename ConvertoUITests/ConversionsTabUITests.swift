//
//  ConversionsTabUITests.swift
//  ConvertoUITests
//
//  Created by Larissa Barra on 01/04/2023.
//

import Foundation
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift

final class ConversionsTabUITests: BaseUITestCase {
    
    func testConversionsTab() {
        let currenciesFixture = loadFixture(named: "Currencies")
        let conversionFixture = loadFixture(named: "GBPtoEUR")
        
        stub(condition: isPath("/currencies")) { _ in
            return HTTPStubsResponse(data: currenciesFixture, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/latest?amount=10.2&from=GBP&to=EUR")) { _ in
            return HTTPStubsResponse(data: conversionFixture, statusCode: 200, headers: nil)
        }
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let fromPicker = app.buttons["conversionsTab.fromCurrency.picker"]
        fromPicker.tap()
        app.buttons["GBP"].tap()
        XCTAssertEqual(fromPicker.label, "Select currency, GBP")
        
        let fromAmount = app.textFields.element(boundBy: 0)
        fromAmount.tap()
        fromAmount.typeText("10.2")
        
        let toPicker = app.buttons["conversionsTab.toCurrency.picker"]
        toPicker.tap()
        app.buttons["EUR"].tap()
        XCTAssertEqual(toPicker.label, "Select currency, EUR")
        
        let toAmount = app.textFields.element(boundBy: 1)
        XCTAssertEqual(toAmount.value as! String, "11.60")
        
        app.buttons["Clear"].tap()
        XCTAssertEqual(fromPicker.label, "Select currency, -")
        XCTAssertEqual(toPicker.label, "Select currency, -")
        XCTAssertEqual(fromAmount.value as! String, "Amount")
        XCTAssertEqual(toAmount.value as! String, "Amount")
    }
}

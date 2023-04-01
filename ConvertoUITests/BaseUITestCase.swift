//
//  BaseUITestCase.swift
//  ConvertoUITests
//
//  Created by Larissa Barra on 01/04/2023.
//

import Foundation
import XCTest
import OHHTTPStubs

class BaseUITestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        HTTPStubs.removeAllStubs()
    }
    
    func loadFixture(named name: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            fatalError("Missing fixture: \(name)")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load fixture: \(name)")
        }
        return data
    }
}

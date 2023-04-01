//
//  CurrencyListConstants.swift
//  Converto
//
//  Created by Larissa Barra on 28/03/2023.
//

import Foundation
import SwiftUI

extension CurrencyList {
    
    enum LocalisedStrings {
        
        static let currencies = LocalizedStringKey("currenciesTab.list.title")
        static let description = LocalizedStringKey("currenciesTab.description")
        
        static let code = LocalizedStringKey("currenciesTab.list.header.code")
        static let currencyName = LocalizedStringKey("currenciesTab.list.header.name")
        static let rate = LocalizedStringKey("currenciesTab.list.header.rate")
    }
}

//
//  ConversionsTabViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import Foundation
import SwiftUI

extension ConversionsTab {
    
    class ViewModel: ObservableObject {
        
        enum UpdatedField {
            case fromCurrency
            case toCurrency
            case fromAmount
            case toAmount
        }
        
        @Published var fromCurrency: Currency?
        @Published var toCurrency: Currency?
        @Published var fromAmount: String = ""
        @Published var toAmount: String = ""
        
        @Published var isEditing = false
        @Published var fromBackgroundColour = Color(.lightGray).opacity(0.1)
        @Published var toBackgroundColour = Color(.lightGray).opacity(0.1)
        
        private let currencyService: CurrencyService
        
        init(currencyService: CurrencyService = FrankfurterCurrencyService() ) {
            self.currencyService = currencyService
        }
        
        func convert(updated: UpdatedField) {
            guard isEditing,
                  [fromCurrency == nil,
                   toCurrency == nil,
                   fromAmount.isEmpty,
                   toAmount.isEmpty].filter({ $0 }).count <= 1
            else { return }
            
            let fromC: Currency
            let toC: Currency
            let fromA: Double
            var toAndFromSwitched = false
            
            switch updated {
                case .fromCurrency:
                    guard let fromCurrency else { return }
                    if let fromAmount = Double(fromAmount), let toCurrency {
                        fromC = fromCurrency
                        toC = toCurrency
                        fromA = fromAmount
                        toBackgroundColour = Color(.green)
                    } else if let toAmount = Double(toAmount), let toCurrency {
                        fromC = toCurrency
                        toC = fromCurrency
                        fromA = toAmount
                        toAndFromSwitched = true
                        fromBackgroundColour = Color(.green)
                    } else { return }
                    
                case .toCurrency:
                    guard let toCurrency else { return }
                    if let toAmount = Double(toAmount), let fromCurrency {
                        fromC = toCurrency
                        toC = fromCurrency
                        fromA = toAmount
                        toAndFromSwitched = true
                        fromBackgroundColour = Color(.green)
                    } else if let fromAmount = Double(fromAmount), let fromCurrency {
                        fromC = fromCurrency
                        toC = toCurrency
                        fromA = fromAmount
                        toBackgroundColour = Color(.green)
                    } else { return }
                    
                case .fromAmount:
                    guard let fromAmount = Double(fromAmount), let fromCurrency, let toCurrency else { return }
                    fromC = fromCurrency
                    toC = toCurrency
                    fromA = fromAmount
                    toBackgroundColour = Color(.green)
                    
                case .toAmount:
                    guard let toAmount = Double(toAmount), let fromCurrency, let toCurrency else { return }
                    fromC = toCurrency
                    toC = fromCurrency
                    fromA = toAmount
                    fromBackgroundColour = Color(.green)
            }
            
            currencyService.convert(amount: fromA, from: fromC, to: toC) { result in
                switch result {
                    case .success(let exchangeRate):
                        DispatchQueue.main.async {
                            self.isEditing = false
                            switch updated {
                                case .fromCurrency:
                                    if toAndFromSwitched {
                                        self.fromAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                                    } else {
                                        self.toAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                                    }
                                    
                                case .toCurrency:
                                    if toAndFromSwitched {
                                        self.fromAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                                    } else {
                                        self.toAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                                    }
                                    
                                case .fromAmount:
                                    self.toAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                                    
                                case .toAmount:
                                    self.fromAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                            }
                            
                            toAndFromSwitched = false
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}

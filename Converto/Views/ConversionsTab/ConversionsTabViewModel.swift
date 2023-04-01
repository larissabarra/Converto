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
            
            var fromC: Currency = Currency(code: "", name: "")
            var toC: Currency = Currency(code: "", name: "")
            var fromA: Double = 0
            var toAndFromSwitched = false
            
            switch updated {
                case .fromCurrency:
                    guard let fromCurrency else { return }
                    if let fromAmount = Double(fromAmount), let toCurrency {
                        setupFieldsWithFromValues(fromCurrency, toCurrency, fromAmount)
                    } else if let toAmount = Double(toAmount), let toCurrency {
                        setupFieldsWithToValues(fromCurrency, toCurrency, toAmount)
                        toAndFromSwitched = true
                    } else { return }
                    
                case .toCurrency:
                    guard let toCurrency else { return }
                    if let toAmount = Double(toAmount), let fromCurrency {
                        setupFieldsWithToValues(fromCurrency, toCurrency, toAmount)
                        toAndFromSwitched = true
                    } else if let fromAmount = Double(fromAmount), let fromCurrency {
                        setupFieldsWithFromValues(fromCurrency, toCurrency, fromAmount)
                    } else { return }
                    
                case .fromAmount:
                    guard let fromAmount = Double(fromAmount), let fromCurrency, let toCurrency else { return }
                    setupFieldsWithFromValues(fromCurrency, toCurrency, fromAmount)
                    
                case .toAmount:
                    guard let toAmount = Double(toAmount), let fromCurrency, let toCurrency else { return }
                    setupFieldsWithToValues(fromCurrency, toCurrency, toAmount)
            }
            
            func setupFieldsWithFromValues(_ fromCurrency: Currency, _ toCurrency: Currency, _ fromAmount: Double) {
                fromC = fromCurrency
                toC = toCurrency
                fromA = fromAmount
                toBackgroundColour = Color(.green)
            }
            
            func setupFieldsWithToValues(_ fromCurrency: Currency, _ toCurrency: Currency, _ toAmount: Double) {
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
                                case .fromCurrency, .toCurrency:
                                    if toAndFromSwitched {
                                        updateField(&self.fromAmount)
                                    } else {
                                        updateField(&self.toAmount)
                                    }
                                    
                                case .fromAmount:
                                    updateField(&self.toAmount)
                                    
                                case .toAmount:
                                    updateField(&self.fromAmount)
                            }
                            
                            toAndFromSwitched = false
                        }
                        
                        func updateField(_ field: inout String) {
                            field = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}

//
//  ConversionsTabViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import Foundation

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
        
        private let currencyService: CurrencyService
        
        init(currencyService: CurrencyService = FrankfurterCurrencyService() ) {
            self.currencyService = currencyService
        }
        
        func convert(updated: UpdatedField) {
            guard isEditing,
                  let fromCurrency,
                  let toCurrency,
                  !(fromAmount.isEmpty && toAmount.isEmpty) else {
                return
            }
            
            let fromC: Currency
            let toC: Currency
            let fromA: Double
            
            switch updated {
                case .fromCurrency, .fromAmount:
                    guard let fromAmount = Double(fromAmount) else { return }
                    fromC = fromCurrency
                    toC = toCurrency
                    fromA = fromAmount
                    
                case .toCurrency, .toAmount:
                    guard let toAmount = Double(toAmount) else { return }
                    fromC = toCurrency
                    toC = fromCurrency
                    fromA = toAmount
            }
            
            currencyService.convert(amount: fromA, from: fromC, to: toC) { result in
                switch result {
                    case .success(let exchangeRate):
                        DispatchQueue.main.async {
                            self.isEditing = false
                            switch updated {
                                case .fromCurrency, .fromAmount:
                                    self.toAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                                    
                                case .toCurrency, .toAmount:
                                    self.fromAmount = String(format: "%.2f", (exchangeRate.rates.first?.value ?? 0))
                            }
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}

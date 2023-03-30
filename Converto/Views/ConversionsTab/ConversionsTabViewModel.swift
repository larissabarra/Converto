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
        
        @Published private(set) var currencies = [Currency]()
        @Published var fromCurrency: Currency?
        @Published var toCurrency: Currency?
        @Published var fromAmount: String = ""
        @Published var toAmount: String = ""
        
        private let currencyService: CurrencyService
        
        init(currencyService: CurrencyService = FrankfurterCurrencyService() ) {
            self.currencyService = currencyService
        }
        
        func fetchCurrencies() {
            currencyService.fetchCurrencies { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let currencies):
                            self?.currencies = currencies.sorted(by: { $0.code < $1.code })
                            
                        case .failure(let error):
                            print(error)
                    }
                }
            }
        }
        
        func convert(updated: UpdatedField) {
            guard let fromCurrency,
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

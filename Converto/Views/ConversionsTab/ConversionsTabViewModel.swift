//
//  ConversionsTabViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import Foundation

extension ConversionsTab {
    
    class ViewModel: ObservableObject {
        
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
        
        func convert() {
            guard let fromCurrency = fromCurrency,
                  let toCurrency = toCurrency,
                  let fromAmount = Double(fromAmount) else {
                return
            }
            
            currencyService.convert(amount: fromAmount, from: fromCurrency, to: toCurrency) { result in
                switch result {
                    case .success(let exchangeRate):
                        DispatchQueue.main.async {
                            self.toAmount = String(format: "%.2f", fromAmount * (exchangeRate.rates.first?.value ?? 0))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}

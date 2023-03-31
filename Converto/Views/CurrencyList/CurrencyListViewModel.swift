//
//  CurrencyListViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation

extension CurrencyList {
    
    class ViewModel: ObservableObject {
        
        @Published private(set) var exchangeRates = [String: Double]()
        
        private let currencyService: CurrencyService
        
        init(currencyService: CurrencyService = FrankfurterCurrencyService() ) {
            self.currencyService = currencyService
        }
        
        func latestFrom(_ currency: Currency) {
            exchangeRates.removeAll()
            
            currencyService.fetchLatestExchangeRates(for: currency) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let rates):
                            rates.rates.forEach { code, rate in
                                self?.exchangeRates[code] = rate
                            }
                            
                        case .failure(let error):
                            print(error)
                    }
                }
            }
        }
    }
}

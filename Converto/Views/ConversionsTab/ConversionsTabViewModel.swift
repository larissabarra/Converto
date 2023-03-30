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
    }
}

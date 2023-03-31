//
//  AppViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation

extension ConvertoApp {
    
    class ViewModel: ObservableObject {
        
        enum ViewState: Equatable {
            case loading
            case loaded
            case error(message: String)
        }
        
        @Published private(set) var currencies = [Currency]()
        @Published private(set) var viewState: ViewState
        
        private let currencyService: CurrencyService
        
        init(currencyService: CurrencyService = FrankfurterCurrencyService()) {
            self.viewState = .loading
            self.currencyService = currencyService
            
            fetchCurrencies()
        }
        
        func fetchCurrencies() {
            viewState = .loading
            
            currencyService.fetchCurrencies { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let currencies):
                            self.currencies = currencies.sorted(by: { $0.code < $1.code })
                            self.viewState = .loaded
                            
                        case .failure(let error):
                            self.viewState = .error(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

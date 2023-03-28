//
//  CurrencyListViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation

extension CurrencyList {
    
    @MainActor class ViewModel: ObservableObject {
        
        enum ViewState: Equatable {
            case loading
            case loaded
            case error(message: String)
        }
        
        @Published private(set) var currencies = [Currency]()
        @Published private(set) var viewState: ViewState
        
        private let currencyService: CurrencyService
        
        init(currencyService: CurrencyService = FrankfurterCurrencyService() ) {
            self.viewState = .loading
            self.currencyService = currencyService
        }
        
        func fetchCurrencies() {
            viewState = .loading
            
            currencyService.fetchCurrencies { [weak self] result in
                switch result {
                case .success(let currencies):
                    self?.currencies = currencies.sorted(by: { $0.code < $1.code })
                    self?.viewState = .loaded
                    
                case .failure(let error):
                    self?.viewState = .error(message: error.localizedDescription)
                }
            }
        }
    }
}

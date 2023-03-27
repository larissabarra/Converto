//
//  CurrencyListViewModel.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation

@MainActor class CurrencyListViewModel: ObservableObject {
    @Published var currencies = [Currency]()
    private let currencyService: CurrencyService
    
    init(currencyService: CurrencyService = FrankfurterCurrencyService() ) {
        self.currencyService = currencyService
    }
    
    func fetchCurrencies() {
        currencyService.fetchCurrencies { result in
            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    self.currencies = currencies
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//
//  CurrencyServiceMock.swift
//  ConvertoTests
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation

@testable import Converto

class CurrencyServiceMock: CurrencyService {
    
    var currencies: [Converto.Currency]?
    var exchangeRates: Converto.LatestExchangeRates?
    var error: Error?
    
    func fetchCurrencies(completion: @escaping (Result<[Converto.Currency], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let currencies = currencies {
            completion(.success(currencies))
        }
    }
    
    func fetchLatestExchangeRates(for currency: Converto.Currency, completion: @escaping (Result<Converto.LatestExchangeRates, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let rates = exchangeRates {
            completion(.success(rates))
        }
    }
    
    func convert(amount: Double, from: Converto.Currency, to: Converto.Currency, completion: @escaping (Result<Converto.LatestExchangeRates, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let rates = exchangeRates {
            completion(.success(rates))
        }
    }
}

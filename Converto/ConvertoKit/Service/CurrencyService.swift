//
//  CurrencyService.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation

protocol CurrencyService {
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void)
    func fetchLatestExchangeRates(for currency: Currency, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void)
    func convert(amount: Double, from: Currency, to: Currency, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void)
}

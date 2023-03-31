    //
    //  FrankfurterCurrencyService.swift
    //  Converto
    //
    //  Created by Larissa Barra on 30/03/2023.
    //

import Foundation

class FrankfurterCurrencyService: CurrencyService {
    let basePath = "https://api.frankfurter.app"
    
    private let currenciesCache = NSCache<NSURL, StructWrapper<[Currency]>>()
    private let exchangeCache = NSCache<NSURL, StructWrapper<LatestExchangeRates>>()
    private let exchangeCacheDuration = TimeInterval(60 * 60 * 24)
    
    private let apiService: APIService
    
    init(apiService: APIService = URLSessionAPIService()) {
        self.apiService = apiService
    }
    
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let url = URL(string: "\(basePath)/currencies") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        if let currencies = currenciesCache.object(forKey: url as NSURL) {
            completion(.success(currencies.unwrap()))
            return
        }
        
        apiService.performRequest(url: url,
                                  dataType: [String: String].self,
                                  responseType: [Currency].self,
                                  mappingFunction: { data in data.map { Currency(code: $0.key, name: $0.value) }},
                                  cache: currenciesCache,
                                  completion: completion)
    }
    
    func fetchLatestExchangeRates(for currency: Currency, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void) {
        convertCurrency(from: currency, completion: completion)
    }
    
    func convert(amount: Double, from: Currency, to: Currency, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void) {
        convertCurrency(amount: amount, from: from, to: to, completion: completion)
    }
    
    private func convertCurrency(amount: Double = 1, from: Currency, to: Currency? = nil, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void) {
        
        var toCurrency = ""
        if let convertTo = to {
            toCurrency = "&to=\(convertTo.code)"
        }
        
        guard let url = URL(string: "\(basePath)/latest?amount=\(amount)&from=\(from.code)\(toCurrency)") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .gmt
        
        if let exchangeRates = exchangeCache.object(forKey: url as NSURL)?.unwrap(),
           let exchangeDate = dateFormatter.date(from: exchangeRates.date),
           exchangeDate.distance(to: Date()) < exchangeCacheDuration {
            completion(.success(exchangeRates))
            return
        }
        
        apiService.performRequest(url: url,
                                  dataType: LatestExchangeRates.self,
                                  responseType: LatestExchangeRates.self,
                                  mappingFunction: nil,
                                  cache: exchangeCache,
                                  completion: completion)
    }
}


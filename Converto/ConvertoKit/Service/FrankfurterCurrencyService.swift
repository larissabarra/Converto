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
    
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let url = URL(string: "\(basePath)/currencies") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        if let currencies = currenciesCache.object(forKey: url as NSURL) {
            completion(.success(currencies.unwrap()))
            return
        }
        
        performRequest(url: url,
                       dataType: [String: String].self,
                       responseType: [Currency].self,
                       mappingFunction: { data in data.map { Currency(code: $0.key, name: $0.value) }},
                       cache: currenciesCache,
                       completion: completion)
    }
    
    func performRequest<V: Decodable, T>(url: URL, dataType: V.Type, responseType: T.Type, mappingFunction: ((V) -> T)? = nil, cache: NSCache<NSURL, StructWrapper<T>>, completion: @escaping (Result<T, Error>) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(V.self, from: data)
                
                var result: T
                
                if let mappingFunction {
                    result = mappingFunction(decodedData)
                } else if let decoded = decodedData as? T {
                    result = decoded
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data conversion failed"])))
                    return
                }

                cache.setObject(StructWrapper(result), forKey: url as NSURL)

                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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
        
        performRequest(url: url,
                       dataType: LatestExchangeRates.self,
                       responseType: LatestExchangeRates.self,
                       cache: exchangeCache,
                       completion: completion)
    }
}

class StructWrapper<T>: NSObject {
    
    let value: T
    
    init(_ _struct: T) {
        self.value = _struct
    }
    
    func unwrap() -> T {
        value
    }
}

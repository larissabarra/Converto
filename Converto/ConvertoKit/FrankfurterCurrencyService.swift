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
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String: String].self, from: data)
                let currencies = decodedData.map { Currency(code: $0.key, name: $0.value) }
                
                self.currenciesCache.setObject(StructWrapper(currencies), forKey: url as NSURL)
                
                completion(.success(currencies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchLatestExchangeRates(for currency: Currency, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void) {
        guard let url = URL(string: "\(basePath)/latest?from=\(currency.code)") else {
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
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let exchangeRates = try decoder.decode(LatestExchangeRates.self, from: data)
                
                self.exchangeCache.setObject(StructWrapper(exchangeRates), forKey: url as NSURL)
                
                completion(.success(exchangeRates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func convert(amount: Double, from: Currency, to: Currency, completion: @escaping (Result<LatestExchangeRates, Error>) -> Void) {
        guard let url = URL(string: "\(basePath)/latest?amount=\(amount)&from=\(from.code)&to=\(to.code)") else {
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
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let exchangeRates = try decoder.decode(LatestExchangeRates.self, from: data)
                
                self.exchangeCache.setObject(StructWrapper(exchangeRates), forKey: url as NSURL)
                
                completion(.success(exchangeRates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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

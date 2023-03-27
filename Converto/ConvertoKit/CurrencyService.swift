//
//  CurrencyService.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation

protocol CurrencyService {
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void)
}

class FrankfurterCurrencyService: CurrencyService {
    let basePath = "https://api.frankfurter.app"
    
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let url = URL(string: "\(basePath)/currencies") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
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
                completion(.success(currencies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

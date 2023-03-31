//
//  URLSessionAPIService.swift
//  Converto
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation

class URLSessionAPIService: APIService {
    
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
}

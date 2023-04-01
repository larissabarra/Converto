//
//  APIServiceMock.swift
//  ConvertoTests
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation

@testable import Converto

class APIServiceMock: APIService {
    var expectedResult: Any?
    var error: Error?
    
    var didCallPerformRequest = false
    
    var url: URL?
    var dataType: Any?
    var responseType: Any?
    
    func performRequest<V, T>(url: URL, dataType: V.Type, responseType: T.Type, mappingFunction: ((V) -> T)?, cache: NSCache<NSURL, Converto.StructWrapper<T>>, completion: @escaping (Result<T, Error>) -> Void) where V : Decodable {
        
        self.didCallPerformRequest = true
        
        self.url = url
        self.dataType = dataType
        self.responseType = responseType
        
        if let error = error {
            completion(.failure(error))
        } else if let expectedResult = expectedResult as? T {
            completion(.success(expectedResult))
        }
    }
}

//
//  APIService.swift
//  Converto
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation

protocol APIService {
    func performRequest<V: Decodable, T>(url: URL, dataType: V.Type, responseType: T.Type, mappingFunction: ((V) -> T)?, cache: NSCache<NSURL, StructWrapper<T>>, completion: @escaping (Result<T, Error>) -> Void)
}

//
//  CachingService.swift
//  Converto
//
//  Created by Larissa Barra on 01/04/2023.
//

import Foundation

protocol Cache {
    associatedtype Key
    associatedtype Value
    
    func getObject(for key: Key) -> Value?
    func saveObject(key: Key, value: Value)
}

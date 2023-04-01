//
//  NSCacheService.swift
//  Converto
//
//  Created by Larissa Barra on 01/04/2023.
//

import Foundation

class StructCache<K: AnyObject, V>: Cache {
    typealias Key = K
    typealias Value = V
    
    private let cache = NSCache<K, StructWrapper<V>>()
    
    func getObject(for key: K) -> V? {
        if let value = cache.object(forKey: key) {
            return value.unwrap()
        }
        return nil
    }
    
    func saveObject(key: K, value: V) {
        cache.setObject(StructWrapper(value), forKey: key)
    }
}

//
//  CacheUtilities.swift
//  Converto
//
//  Created by Larissa Barra on 31/03/2023.
//

import Foundation

class StructWrapper<T>: NSObject {
    
    let value: T
    
    init(_ _struct: T) {
        self.value = _struct
    }
    
    func unwrap() -> T {
        value
    }
}

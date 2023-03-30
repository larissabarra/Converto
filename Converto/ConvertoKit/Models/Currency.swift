//
//  CurrencyModel.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import Foundation

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
}

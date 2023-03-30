//
//  LatestExchangeRates.swift
//  Converto
//
//  Created by Larissa Barra on 28/03/2023.
//

import Foundation

struct LatestExchangeRates: Decodable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
}

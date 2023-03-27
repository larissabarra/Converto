//
//  ContentView.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyListViewModel()
        
    var body: some View {
        NavigationView {
            List(viewModel.currencies) { currency in
                Text("\(currency.code) - \(currency.name)")
            }
            .navigationTitle("Currencies")
        }
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 

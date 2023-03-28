//
//  ContentView.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import SwiftUI

 struct CurrencyList: View {
    @StateObject private var viewModel = ViewModel()
        
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                
            case .loaded:
                Text(CurrencyList.LocalisedStrings.currencies)
                    .font(.title)
                List(viewModel.currencies) { currency in
                    HStack {
                        Text("\(currency.code)")
                            .frame(minWidth: 50, alignment: .leading)
                        Text("\(currency.name)")
                            .frame(alignment: .leading)
                        Spacer()
                    }
                }.listStyle(.plain)
                
            case .error(let message):
                Text(message)
            }
        }
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyList()
    }
}
 
//
//  ContentView.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import SwiftUI

struct CurrencyList: View {
    @EnvironmentObject var appViewModel: ConvertoApp.ViewModel
    
    @StateObject private var viewModel: ViewModel
    @State private var selectedCurrency: Currency?
    
    init(currencyService: CurrencyService) {
        _viewModel = StateObject(wrappedValue: ViewModel(currencyService: currencyService))
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalisedStrings.currencies)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.top, .leading, .trailing], 16)
                .padding([.bottom], 8)
            
            Text(LocalisedStrings.description)
                .font(.callout)
                .padding([.leading, .trailing], 16)
                .foregroundColor(.gray)
            
            HStack(alignment: .center) {
                Text(LocalisedStrings.code)
                    .frame(minWidth: 50, alignment: .leading)
                
                Text(LocalisedStrings.currencyName)
                    .frame(alignment: .leading)
                
                Spacer()
                
                Text(LocalisedStrings.rate)
            }
            .padding([.top, .leading, .trailing], 16)
            .padding([.bottom], 5)
            
            Color(uiColor: .black).frame(height: 1)
            
            List(appViewModel.currencies) { currency in
                
                HStack(alignment: .center) {
                    Text("\(currency.code)")
                        .frame(minWidth: 50, alignment: .leading)
                        .font(.caption)
                    
                    Text("\(currency.name)")
                        .frame(alignment: .leading)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(exchangeRateText(for: currency))
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCurrency = currency
                    viewModel.latestFrom(currency)
                }
                .listRowBackground(self.selectedCurrency == currency ? Color.green : Color.clear)
                .contentTransition(.opacity)
            }.listStyle(.plain)
        }
    }
     
    private func exchangeRateText(for currency: Currency) -> String {
        guard let selectedCurrency = selectedCurrency else { return "" }
        
        if currency == selectedCurrency {
            return 1.0.formatted(.currency(code: selectedCurrency.code))
        } else {
            return viewModel.exchangeRates[currency.code]?.formatted(.currency(code: currency.code)) ?? "-"
        }
    }
}

//
//  ConversionsTab.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import SwiftUI

struct ConversionsTab: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var selectedCurrency1: Currency?
    @State private var selectedCurrency2: Currency?
    
    @State private var value1: String = "0"
    @State private var value2: String = "0"
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Picker("Currency", selection: $selectedCurrency1) {
                    Text(" - ").tag(nil as Currency?)
                    ForEach(viewModel.currencies) { currency in
                        Text(currency.code).tag(currency as Currency?)
                    }
                }
                
                Spacer()
                
                Picker("Currency", selection: $selectedCurrency2) {
                    Text(" - ").tag(nil as Currency?)
                    ForEach(viewModel.currencies) { currency in
                        Text(currency.code).tag(currency as Currency?)
                    }
                }
            }
            
            HStack {
                TextField("0.0", text: $value1)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                Text("=")
                    .font(.title)
                Spacer()
                
                TextField("0.0", text: $value2)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding(24)
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}

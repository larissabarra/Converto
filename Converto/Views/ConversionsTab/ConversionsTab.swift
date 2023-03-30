//
//  ConversionsTab.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import SwiftUI

struct ConversionsTab: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Picker("From Currency", selection: $viewModel.fromCurrency) {
                    Text("-").tag(nil as Currency?)
                    ForEach(viewModel.currencies) { currency in
                        Text(currency.code).tag(currency as Currency?)
                    }
                }
                
                TextField("Amount", text: $viewModel.fromAmount)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        viewModel.fromAmount = ""
                    }
            }
            
            HStack {
                Picker("To Currency", selection: $viewModel.toCurrency) {
                    Text("-").tag(nil as Currency?)
                    ForEach(viewModel.currencies) { currency in
                        Text(currency.code).tag(currency as Currency?)
                    }
                }
                
                TextField("Amount", text: $viewModel.toAmount)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        viewModel.toAmount = ""
                    }
            }
        }
        .onChange(of: viewModel.fromCurrency) { _ in
            viewModel.convert()
        }
        .onChange(of: viewModel.toCurrency) { _ in
            viewModel.convert()
        }
        .onChange(of: viewModel.fromAmount) { _ in
            viewModel.convert()
        }
        .onChange(of: viewModel.toAmount) { _ in
            viewModel.convert()
        }
        .padding(24)
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}

//
//  ConversionsTab.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import SwiftUI

struct ConversionsTab: View {
    
    private enum Field: Int, CaseIterable {
        case toAmount
        case fromAmount
    }
    
    @StateObject private var viewModel = ViewModel()
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            HStack {
                Picker("From Currency", selection: $viewModel.fromCurrency) {
                    Text("-").tag(nil as Currency?)
                    ForEach(viewModel.currencies) { currency in
                        Text(currency.code).tag(currency as Currency?)
                    }
                }
                .onTapGesture {
                    viewModel.isEditing = true
                    focusedField = nil
                }
                
                Spacer()
                
                Picker("To Currency", selection: $viewModel.toCurrency) {
                    Text("-").tag(nil as Currency?)
                    ForEach(viewModel.currencies) { currency in
                        Text(currency.code).tag(currency as Currency?)
                    }
                }
                .onTapGesture {
                    viewModel.isEditing = true
                    focusedField = nil
                }
            }
            
            HStack {
                TextField("Amount", text: $viewModel.fromAmount)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        viewModel.fromAmount = ""
                        viewModel.isEditing = true
                    }
                    .focused($focusedField, equals: .fromAmount)
                
                Text("=")
                    .font(.title)
                
                TextField("Amount", text: $viewModel.toAmount)
                    .keyboardType(.decimalPad)
                    .onTapGesture {
                        viewModel.toAmount = ""
                        viewModel.isEditing = true
                    }
                    .focused($focusedField, equals: .toAmount)
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .onChange(of: viewModel.fromCurrency) { _ in
            viewModel.convert(updated: .fromCurrency)
        }
        .onChange(of: viewModel.toCurrency) { _ in
            viewModel.convert(updated: .toCurrency)
        }
        .onChange(of: viewModel.fromAmount) { _ in
            viewModel.convert(updated: .fromAmount)
        }
        .onChange(of: viewModel.toAmount) { _ in
            viewModel.convert(updated: .toAmount)
        }
        .padding(24)
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}


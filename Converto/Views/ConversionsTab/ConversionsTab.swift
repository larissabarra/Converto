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
    
    @EnvironmentObject var appViewModel: ConvertoApp.ViewModel
    
    @StateObject private var viewModel = ViewModel()
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            HStack {
                currencyPicker(reference: $viewModel.fromCurrency)
                
                Spacer()
                
                currencyPicker(reference: $viewModel.toCurrency)
            }
            
            HStack {
                amountTextField(reference: $viewModel.fromAmount, focus: .fromAmount)
                
                Text("=")
                    .font(.title)
                
                amountTextField(reference: $viewModel.toAmount, focus: .toAmount)
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
    }
    
    @ViewBuilder
    private func currencyPicker(reference: Binding<Currency?>) -> some View {
        Picker("From Currency", selection: reference) {
            Text("-").tag(nil as Currency?)
            ForEach(appViewModel.currencies) { currency in
                Text(currency.code).tag(currency as Currency?)
            }
        }
        .onTapGesture {
            viewModel.isEditing = true
            focusedField = nil
        }
    }
    
    @ViewBuilder
    private func amountTextField(reference: Binding<String>, focus: Field) -> some View {
        TextField("Amount", text: reference)
            .keyboardType(.decimalPad)
            .onTapGesture {
                reference.wrappedValue = ""
                viewModel.isEditing = true
            }
            .focused($focusedField, equals: focus)
    }
}


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
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalisedStrings.title)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.top, .leading, .trailing], 16)
                .padding([.bottom], 8)
            
            Text(LocalisedStrings.description)
                .font(.callout)
                .padding([.leading, .trailing], 16)
                .foregroundColor(.gray)
            
            HStack {
                VStack(alignment: .center) {
                    currencyPicker(reference: $viewModel.fromCurrency)
                    amountTextField(reference: $viewModel.fromAmount, focus: .fromAmount)
                }
                .background(Color(.lightGray).opacity(0.1))
                .cornerRadius(8)
                
                Text("=")
                    .font(.title)
                    .foregroundColor(.gray)
                
                VStack(alignment: .center) {
                    currencyPicker(reference: $viewModel.toCurrency)
                    amountTextField(reference: $viewModel.toAmount, focus: .toAmount)
                }
                .background(Color(.lightGray).opacity(0.1))
                .cornerRadius(8)
            }
            .padding(24)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(LocalisedStrings.keyboardDone) {
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
    }
    
    @ViewBuilder
    private func currencyPicker(reference: Binding<Currency?>) -> some View {
        Picker(LocalisedStrings.currencyPickerTitle, selection: reference) {
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
        TextField(LocalisedStrings.amountFieldPlaceholder, text: reference)
            .keyboardType(.decimalPad)
            .onTapGesture {
                reference.wrappedValue = ""
                viewModel.isEditing = true
            }
            .focused($focusedField, equals: focus)
            .padding([.leading, .trailing, .bottom], 8)
            .multilineTextAlignment(.center)
            .font(.title2)
    }
}


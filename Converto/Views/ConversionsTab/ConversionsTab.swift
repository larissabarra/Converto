//
//  ConversionsTab.swift
//  Converto
//
//  Created by Larissa Barra on 30/03/2023.
//

import SwiftUI

struct ConversionsTab: View {
    
    @State private var selectedCurrency1: Currency?
    @State private var selectedCurrency2: Currency?
    
    @State private var value1: String = "0"
    @State private var value2: String = "0"
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button {
                    print(value1)
                } label: {
                    Text("currency")
                }
                
                Spacer()
                
                Button {
                    print(value2)
                } label: {
                    Text("currency")
                }
            }
            
            HStack {
                TextField("0.0", text: $value1)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                Image(systemName: "arrow.left.arrow.right")
                Spacer()
                
                TextField("0.0", text: $value2)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding(24)
    }
}

struct ConversionsTab_Previews: PreviewProvider {
    static var previews: some View {
        ConversionsTab()
    }
}

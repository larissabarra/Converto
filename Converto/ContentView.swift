//
//  ContentView.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import SwiftUI

struct ContentView: View {
    var items = [Currency(code: "GBP", name: "British Pound"), Currency(code: "EUR", name: "Euro")]
    
    var body: some View {
        List(items) { item in
            HStack {
                Text("\(item.code)")
                Text("\(item.name)")
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ConvertoApp.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import SwiftUI

@main
struct ConvertoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CurrencyList()
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Currencies")
                    }
                ConversionsTab()
                    .tabItem {
                        Image(systemName: "arrow.left.arrow.right")
                        Text("Exchange Rates")
                    }
            }
        }
    }
}

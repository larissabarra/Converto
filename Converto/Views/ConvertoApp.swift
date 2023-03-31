//
//  ConvertoApp.swift
//  Converto
//
//  Created by Larissa Barra on 27/03/2023.
//

import SwiftUI

@main
struct ConvertoApp: App {
    
    let currencyService: CurrencyService = FrankfurterCurrencyService()
    
    @StateObject private var viewModel = ViewModel()
    
//    init() {
//        _viewModel = StateObject(wrappedValue: ViewModel(currencyService: self.currencyService))
//    }
    
    var body: some Scene {
        WindowGroup {
            switch viewModel.viewState {
                case .loading:
                    ProgressView()
                    
                case .loaded:
                    TabView {
                        CurrencyList(currencyService: currencyService)
                            .tabItem {
                                Image(systemName: "list.dash")
                                Text("Currencies")
                            }
                            .environmentObject(viewModel)
                        ConversionsTab()
                            .tabItem {
                                Image(systemName: "arrow.left.arrow.right")
                                Text("Exchange Rates")
                            }
                            .environmentObject(viewModel)
                    }
                case .error(let message):
                    Text(message)
            }
        }
    }
}

//
//  ContentView.swift
//  swift-demo
//
//  Created by Eunika Wu on 5/17/21.
//  Copyright © 2021 LAIKA. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    /// WebView state
    @StateObject var webviewData = WebViewData()
    /// Bluetooth manager singleton
    @StateObject var bleManager = BLEManager()
    /// Device selection modal controller
    @State var deviceSelectModalOpen = false

    var body: some View {
        NavigationView {
            WebView(
                // url: URLType.publicURL(path: "https://laika.com"), // Example for public url
                url: URLType.localURL(path: "index"),                 // Example for local url
                webviewData: webviewData
            )
            .navigationBarTitle("Swift Demo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Connect") {
                        deviceSelectModalOpen.toggle()
                        bleManager.candidatePeripherals = []
                        bleManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
                    }
                }
            }            
            .sheet(isPresented: $deviceSelectModalOpen) {
                DeviceSelectModal(bleManager: bleManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

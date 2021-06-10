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
    @ObservedObject var bleManager = BLEManager()

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Bluetooth state: \(bleManager.state)")
                Text("Device: \((bleManager.peripheral != nil) ? bleManager.peripheral.name ?? "Unknown" : "Unconnected")")
                List(bleManager.candidatePeripherals) { peripheral in
                    HStack {
                        Text(peripheral.name)
                        Spacer()
                        Text(peripheral.uuid)
                        Spacer()
                        Text(String(peripheral.battery))
                        Spacer()
                        Text(String(peripheral.rssi))
                    }
                }
                WebView(
                    // url: URLType.publicURL(path: "https://laika.com"), // Example for public url
                    url: URLType.localURL(path: "index"),                 // Example for local url
                    webviewData: webviewData
                )
                .navigationBarTitle("Swift Demo", displayMode: .inline)
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

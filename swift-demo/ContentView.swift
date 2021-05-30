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
            VStack {
                Button("Trigger") {
                    webviewData.evaluateJS.send("rpc.setBluetoothStatus('on')")
                    webviewData.evaluateJS.send("rpc.setDeviceConnection('Looking Stone')")
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
        Text("Bluetooth powered: \(bleManager.poweredOn ? "on" : "off")")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

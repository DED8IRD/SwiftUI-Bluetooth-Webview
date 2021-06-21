//
//  ContentView.swift
//  swift-demo
//
//  Created by Eunika Wu on 5/17/21.
//  Copyright © 2021 LAIKA. All rights reserved.
//

import SwiftUI

/// Contains application state data: webview data & bluetooth manager
class ApplicationState: NSObject, ObservableObject {
    /// WebView state
    @Published var webviewData = WebViewData()
    /// Bluetooth manager singleton
    @Published var bleManager = BLEManager()
    /// Modal state
    @Published var deviceSelectModalOpen = false

    override init() {
        super.init()
        /// Set callbacks to BLE manager
        self.bleManager.onBluetoothStateChange = { () -> Void in
            self.webviewData.evaluateJS.send("rpc.setBluetoothStatus('\(self.bleManager.state ?? "Unknown")')")
        }
        self.bleManager.onDeviceConnectionChange = { () -> Void in
            let device = self.bleManager.device != nil
                ? self.bleManager.device!.peripheral.name ?? "Unknown Device"
                : "Not Connected"
            self.webviewData.evaluateJS.send("rpc.setDeviceConnection('\(device)')")
        }
    }
}

struct ContentView: View {
    @ObservedObject var state = ApplicationState()

    var body: some View {
        NavigationView {
            WebView(
                // url: URLType.publicURL(path: "https://laika.com"), // Example for public url
                url: URLType.localURL(path: "index"),                 // Example for local url
                webviewData: state.webviewData,
                onLoad: { () -> Void in
                    state.bleManager.onBluetoothStateChange?()
                    state.bleManager.onDeviceConnectionChange?()
                }
            )
            .navigationBarTitle("Swift Demo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Connect") {
                        state.deviceSelectModalOpen.toggle()
                        state.bleManager.candidatePeripherals = []
                        state.bleManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
                    }
                }
            }
            .sheet(isPresented: $state.deviceSelectModalOpen) {
                DeviceSelectModal(bleManager: state.bleManager)
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

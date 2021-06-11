//
//  DeviceSelect.swift
//  swift-demo
//
//  Bluetooth device select modal.
//
//  Created by Eunika Wu on 6/10/21.
//

import Foundation
import SwiftUI

struct DeviceSelectModal: View {
    @Environment(\.presentationMode) var presentationMode
    /// BLEManager singleton
    @ObservedObject var bleManager: BLEManager

    var body: some View {
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
            .navigationTitle("Pair device")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Exit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

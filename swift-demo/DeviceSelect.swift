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
        NavigationView {
            GeometryReader { metrics in
                VStack {
                    HStack {
                        Text("Name").frame(width: metrics.size.width * 0.2)
                        Text("UUID").frame(width: metrics.size.width * 0.4)
                        Text("Battery").frame(width: metrics.size.width * 0.2)
                        Text("Strength").frame(width: metrics.size.width * 0.2)
                    }
                    .padding(.top, 20)
                    Divider()
                    List(bleManager.candidatePeripherals) { peripheral in
                        Button(action: { bleManager.connectToCandidate(id: peripheral.id) }) {
                            HStack(spacing: 20) {
                                Text(peripheral.name).frame(width: metrics.size.width * 0.2, alignment: .leading)
                                Text(peripheral.uuid).frame(width: metrics.size.width * 0.4, alignment: .leading)
                                Text(String(peripheral.battery)).frame(width: metrics.size.width * 0.2, alignment: .leading)
                                Text(String(peripheral.rssi)).frame(width: metrics.size.width * 0.2, alignment: .leading)
                            }
                        }
                        .disabled(peripheral.uuid == bleManager.peripheral?.identifier.uuidString ?? "No match")
                    }
                }
            }
            .navigationBarTitle("Pair device", displayMode: .inline)
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

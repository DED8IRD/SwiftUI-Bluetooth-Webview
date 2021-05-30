//
//  Bluetooth.swift
//  swift-demo
//
//
//
//  Created by Eunika Wu on 5/27/21.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    /// Central Manager
    var centralManager: CBCentralManager!
    @Published var poweredOn = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
    /// Handle updates to the Bluetooth state
    /// - Parameter central: CentralManager
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        poweredOn = central.state == .poweredOn
    }
}

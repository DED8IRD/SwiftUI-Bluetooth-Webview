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

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /// Central Manager
    var centralManager: CBCentralManager!
    /// Peripheral
    var peripheral: CBPeripheral!
    @Published var poweredOn = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
    /// Handle updates to the Bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        poweredOn = central.state == .poweredOn
    }
    
    
    /// Tells the delegate the central manager discovered a peripheral while scanning for devices
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // We can identify our peripheral by name, uuid, manufacturer id, or other info stored in advertisement data. Here, we want to connect to a Looking Stone device
        if let pname = peripheral.name {
            if pname == "LookingStone" {
                self.centralManager.stopScan()
                self.peripheral = peripheral
                self.peripheral.delegate = self
                self.centralManager.connect(peripheral, options: nil)
            }
        }
    }
    
    /// Tells the central manager a peripheral has connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheral.discoverServices(nil)
    }
}

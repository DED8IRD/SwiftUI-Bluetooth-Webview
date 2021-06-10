//
//  Bluetooth.swift
//  swift-demo
//
//  Bluetooth module to scan and connect to BLE devices.
//  Modified from https://github.com/jaredwolff/swift-bluetooth-particle-rgb
//  and https://gitlab.pt.laika.com/asset-tracking/looking-stone
//
//  Created by Eunika Wu on 5/27/21.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject {

    /// Central Manager
    var centralManager: CBCentralManager!
    /// Peripheral candidates to select from
    @Published var candidatePeripherals = [Peripheral]()
    /// Connected peripheral
    @Published var peripheral: CBPeripheral!
    /// BLE State
    @Published var state: String!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
        state = "Initializing"
    }
}

extension BLEManager: CBCentralManagerDelegate {
    /// Handle updates to the Bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
          case .unknown:
            self.state = "unknown"
          case .resetting:
            self.state = "resetting"
          case .unsupported:
            self.state = "unsupported"
          case .unauthorized:
            self.state = "unauthorized"
          case .poweredOff:
            self.state = "poweredOff"
          case .poweredOn:
            self.state = "poweredOn"
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            self.state = "error"
            fatalError()
        }
        print("central.state is: \(self.state ?? "unknown")")
    }

    /// Tells the delegate the central manager discovered a peripheral while scanning for devices
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // We can identify our peripheral by name, uuid, manufacturer id, or other info stored in advertisement data. Here, we want to connect to a Looking Stone device
        let currentPeripheral = Peripheral(
            id: self.candidatePeripherals.count,
            uuid: peripheral.identifier.uuidString,
            name: advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "Unknown",
            battery: advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Int ?? 100,
            rssi: RSSI.intValue
        )
        self.candidatePeripherals.append(currentPeripheral)

        if currentPeripheral.name == "Looking Stone" {
            self.peripheral = peripheral
            self.peripheral.delegate = self
            self.centralManager.connect(peripheral, options: nil)
            self.centralManager.stopScan()
        }
    }

    /// Tells the central manager a peripheral has connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}

extension BLEManager: CBPeripheralDelegate {
    /// Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print(service)
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    /// Iterate through available characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print(characteristic)
            }
        }
    }
}

/// Peripheral Identifiable
struct Peripheral: Identifiable {
    var id: Int
    let uuid: String
    let name: String
    let battery: Int
    let rssi: Int
}

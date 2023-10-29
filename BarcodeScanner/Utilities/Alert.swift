//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Vadim Archer on 29.10.2023.
//

import SwiftUI


struct AlerItem:Identifiable {
    var id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlerItem(title: "Invalid Device Input",
                                             message: "Something is wrong with the Camera. Unable to capture the input.",
                                             dismissButton: .default(Text("Ok")))
    static let invalidSannedType = AlerItem(title: "Invalid Scan Type",
                                             message: "The value scanned is not valid. This app scans EAN-8 and EAN-13.",
                                             dismissButton: .default(Text("Ok")))
}

//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Vadim Archer on 29.10.2023.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
    
    @Published  var scannedCode: String = ""
    @Published  var alertItem: AlerItem?
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    var foregroundStyleColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
}

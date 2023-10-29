//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Vadim Archer on 28.10.2023.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String
    @Binding var alertItem: AlerItem?
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self
        )
    }
  
    final class Coordinator: NSObject, ScannerVCDelegate {
        private let scannerView:ScannerView
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
        }
        
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScanValue:
                scannerView.alertItem = AlertContext.invalidSannedType
            }
        }
        
        
    }
}



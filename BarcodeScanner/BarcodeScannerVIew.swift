//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Vadim Archer on 23.10.2023.
//

import SwiftUI

struct BarcodeScannerVIew: View {
    
    @State private var scanndedCode: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScannerView(scannedCode: $scanndedCode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    
                
                Spacer().frame(height: 50)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(scanndedCode.isEmpty ? "Not yet scanned" : scanndedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(scanndedCode.isEmpty ? .red : .green)
                    .padding()
            }
            .navigationTitle("🤳🏽Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScannerVIew()
}

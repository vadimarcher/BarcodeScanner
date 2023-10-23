//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Vadim Archer on 23.10.2023.
//

import AVFoundation
import UIKit

enum CameraError:String {
    case invalidDeviceInput     = "Something is wrong with the Camera. Unable to capture the input."
    case invalidScanValue       = "The value scanned is not valid. This app scans EAN-8 and EAN-13."
}

protocol ScannerVCDelegate: AnyObject {

    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController  {
    
     let captureSession = AVCaptureSession()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSeesion()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSeesion() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else  {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch  {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean13, .ean8]
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
            
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
}


extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate  {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else  {
            scannerDelegate?.didSurface(error: .invalidScanValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScanValue)
            return
        }
        guard let barCode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScanValue)
            return
        }
       
        scannerDelegate?.didFind(barcode: barCode)
    }
}

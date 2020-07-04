//
//  CapturePhotoViewModel.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import SwiftUI
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject {
    
    var imageModel = ImageModel()
    // Layer for preview
    var previewLayer: AVCaptureVideoPreviewLayer!
    // Session
    private let captureSession = AVCaptureSession()
    // Be Taken a photo image
    private var outputPhoto    = AVCapturePhotoOutput()
    // Main Device
    private var mainDevice:      AVCaptureDevice!
    // InCamera Device
    private var incameraDevice:  AVCaptureDevice!
    // Current Device
    private var currentDevice:   AVCaptureDevice!
    
    override init() {
        super.init()
        prepareCameraSession()
        setUpDevice()
        beginSession()
        startSession()
    }
    
    // 写真撮影ボタンの処理
    func takePhotoAfterTappedTakeButton() {
        let setting = AVCapturePhotoSettings()
        setting.flashMode = .off
        self.outputPhoto.capturePhoto(with: setting, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    // 撮影された写真を取得
    func pullImageTaken() -> UIImage {        
        return self.imageModel.image
    }
}
    
extension CameraViewModel: AVCapturePhotoCaptureDelegate{    
    // Prepare a session for iPhone/iPad camera
     private func prepareCameraSession() {
         self.captureSession.sessionPreset = .photo
     }
     
     // Set up an available Camera Device
     private func setUpDevice() {
         let deviceDiscocerySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
         let devices = deviceDiscocerySession.devices
         for device in devices {
             if device.position == AVCaptureDevice.Position.back {
                 self.mainDevice = device
             } else if device.position == AVCaptureDevice.Position.back {
                 self.incameraDevice = device
             }
         }
         // Initiate Device is Main Device
         self.currentDevice = self.mainDevice
     }
     
     // Begin a session
     private func beginSession() {
         do {
             let captureDeviceInput = try AVCaptureDeviceInput(device: self.currentDevice)
             self.captureSession.addInput(captureDeviceInput)
         } catch {
             print(error.localizedDescription)
         }
         let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
         previewLayer.connection?.videoOrientation = .portrait
         self.previewLayer = previewLayer
         self.previewLayer.connection?.videoOrientation = .portrait
         self.outputPhoto = AVCapturePhotoOutput()
         self.outputPhoto.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
         if captureSession.canAddOutput(self.outputPhoto) {
             captureSession.addOutput(self.outputPhoto)
         }
     }
     
     // Start a session
     func startSession() {
         if self.captureSession.isRunning { return }
         captureSession.startRunning()
     }
     
     // End a session
     func endSession() {
         if !captureSession.isRunning { return }
         captureSession.stopRunning()
     }
     
     // Delegate when the use take a photo
     func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
         if let imageData = photo.fileDataRepresentation() {
             if let uiImage = UIImage(data: imageData) {
                 // Notifiy image value
                self.imageModel.image = uiImage
             }
         }
     }
}

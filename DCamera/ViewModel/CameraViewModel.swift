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
    
    // Imageモデル
    var imageModel = ImageModel()
    // Layer for preview
    var previewLayer: AVCaptureVideoPreviewLayer!
    // セッション
    private let captureSession = AVCaptureSession()
    // アウトプット
    private var outputPhoto    = AVCapturePhotoOutput()
    // メインデバイス
    private var mainDevice:      AVCaptureDevice!
    // インカメラ
    private var incameraDevice:  AVCaptureDevice!
    // 現在設定されているデバイス
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
    // カメラセッションの準備
     private func prepareCameraSession() {
         self.captureSession.sessionPreset = .photo
     }
     
     // 使用可能なデバイスの設定
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
         // 現在のデバイスをメインデバイスに設定
         self.currentDevice = self.mainDevice
     }
     
     // セッションの起動
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
     
     // セッション開始
     func startSession() {
         if self.captureSession.isRunning { return }
         captureSession.startRunning()
     }
     
     // セッション終了
     func endSession() {
         if !captureSession.isRunning { return }
         captureSession.stopRunning()
     }
     
     // 撮影された写真の出力処理
     func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
         if let imageData = photo.fileDataRepresentation() {
             if let uiImage = UIImage(data: imageData) {
                 // Notifiy image value
                self.imageModel.image = uiImage
             }
         }
     }
}

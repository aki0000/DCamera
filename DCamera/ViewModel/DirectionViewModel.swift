//
//  DirectionViewModel.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI

class DirectionViewModel: NSObject, ObservableObject {
      
    // ユーザーの方角の値
    @Published var gettingHeading = 0.0     
    // Imageモデル
    private var imageModel       = ImageModel()
    // 方角UIの方角を指すCAShapeLayer
    var directionLayer = CAShapeLayer()
    // 方角UIの土台となる円のCAShapeLayer
    var circleLayer    = CAShapeLayer()
    // アングル値
    private var angle: (CGFloat, CGFloat) = (0.0, 0.0)
    // 配置する方角UIの位置
    private var position        = CGPoint()
    // LocationManager
    private var locationManager = CLLocationManager()
    // 方角UIの半径
    private var radius: CGFloat = 0.0
    // 方角UIのFrame
    private var frame           = CGRect()
            
    // 初期化
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.position       = CGPoint(x: (UIScreen.main.bounds.width*6)/7 - 50, y: (UIScreen.main.bounds.height*2)/3)
        self.radius         = UIScreen.main.bounds.width/6
        self.angle          = calculateHeadingVaule(heading: gettingHeading)
        self.frame          = UIScreen.main.bounds
        self.circleLayer    = makeCircleLayer(center: self.position)
        self.directionLayer.lineWidth   = 10
        self.directionLayer.strokeColor = UIColor.red.cgColor
        self.directionLayer             = updateDirectionLayer()
        startToUpdate()
    }
    
    // ユーザーの方角の更新を開始
    private func startToUpdate() {
        self.locationManager.startUpdatingHeading()
    }
    
    // 方角UIをUIImageとしてキャプチャー
    func captureDirectionView() {
        let frame = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.75)
        let context = UIGraphicsGetCurrentContext()!
        self.circleLayer.render(in: context)
        self.directionLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image != nil {
            self.imageModel.image = image!            
        }
    }
    
    // キャプチャーされた方角UIのUIImageを取得
    func pullDirectionImage() -> UIImage {
        return self.imageModel.image
    }
    
    // 方角UIの更新
    func updateDirectionLayer() -> CAShapeLayer {
        // When makeUIViewController only
        self.directionLayer.path = UIBezierPath(arcCenter: self.position,
                                                radius: radius,
                                                startAngle: self.angle.0,
                                                endAngle: self.angle.1,
                                                clockwise: true).cgPath
        return self.directionLayer
    }
        
    
    // 方角UIの土台となる円の作成
    private func makeCircleLayer(center: CGPoint) -> CAShapeLayer {
        let circleLayer         = CAShapeLayer()
        circleLayer.frame       = self.frame
        circleLayer.lineWidth   = 5
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.fillColor   = UIColor.clear.cgColor
        circleLayer.path        = UIBezierPath(arcCenter: center,
                                               radius: self.radius,
                                               startAngle: degreeToRadian(degree: 0.0),
                                               endAngle: degreeToRadian(degree: 360.0),
                                               clockwise: true).cgPath
        return circleLayer
    }
    
    // 方角の値を計算
    // 北となる基準: -1/18*pi < θ < 1/18*pi
    private func calculateHeadingVaule(heading: Double) -> (CGFloat, CGFloat) {
        let referAngle = degreeToRadian(degree: CGFloat(heading))
        let startAngle = referAngle + degreeToRadian(degree: -10)
        let endAngle   = referAngle + degreeToRadian(degree: 10)
        return (startAngle, endAngle)
    }
        
    // 角からラジアンに変換
    private func degreeToRadian(degree: CGFloat) -> CGFloat {
        return (degree * CGFloat.pi) / 180.0
    }
    
}

extension DirectionViewModel: CLLocationManagerDelegate {
    // ユーザーの方角の値が更新された後
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.gettingHeading = Double(newHeading.magneticHeading)
        self.angle = calculateHeadingVaule(heading: self.gettingHeading)
    }
    
    // ユーザーの方角の値が更新失敗した場合
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Locatinon Getting Error")
    }
    
}



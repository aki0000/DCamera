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
      
    @Published var gettingHeading = 0.0     
    // Image which CAShapeLayer is rendered
    private var imageModel       = ImageModel()
    // Direction UI for CAShepeLayer
    var directionLayer = CAShapeLayer()
    // Direction Circle UI for CAShepeLayer
    var circleLayer    = CAShapeLayer()
    // Direction which is shown as UI
    private var angle: (CGFloat, CGFloat) = (0.0, 0.0)
    // Center position for UIs
    private var position        = CGPoint()
    // LocationManager
    private var locationManager = CLLocationManager()
    // Radius
    private var radius: CGFloat = 0.0
    // fram
    private var frame           = CGRect()
            
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
    
    // Start Heading of LocationManager
    private func startToUpdate() {
        self.locationManager.startUpdatingHeading()
    }
    
    // Capture UIs as UIImage
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
    
    func pullDirectionImage() -> UIImage {
        return self.imageModel.image
    }
    
    // Update Direction UI
    func updateDirectionLayer() -> CAShapeLayer {
        // When makeUIViewController only
        self.directionLayer.path = UIBezierPath(arcCenter: self.position,
                                                radius: radius,
                                                startAngle: self.angle.0,
                                                endAngle: self.angle.1,
                                                clockwise: true).cgPath
        return self.directionLayer
    }
    
    // Make Circle part which is become for foundation for direction UI
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
    
    // Calculation for Heaging Value
    // Reference point is -5/9*pi < θ < -2/9*pi
    private func calculateHeadingVaule(heading: Double) -> (CGFloat, CGFloat) {
        let referAngle = degreeToRadian(degree: CGFloat(heading))
        let startAngle = referAngle + degreeToRadian(degree: -100)
        let endAngle   = referAngle + degreeToRadian(degree: -80)
        return (startAngle, endAngle)
    }
        
    // Translate degree to radiao
    private func degreeToRadian(degree: CGFloat) -> CGFloat {
        return (degree * CGFloat.pi) / 180.0
    }
    
}

extension DirectionViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.gettingHeading = Double(newHeading.magneticHeading)
        self.angle = calculateHeadingVaule(heading: self.gettingHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Locatinon Getting Error")
    }
}



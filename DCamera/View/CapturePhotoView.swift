//
//  CapturePhotoView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import SwiftUI

struct CapturePhotoView: UIViewRepresentable {
    
    var cameraViewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return UIView(frame: frame)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        self.cameraViewModel.previewLayer.frame = uiView.frame
        uiView.layer.addSublayer(self.cameraViewModel.previewLayer)
    }
}

struct CapturePhotoView_Previews: PreviewProvider{
    static var previews: some View {
        CapturePhotoView(cameraViewModel: CameraViewModel())
    }
}

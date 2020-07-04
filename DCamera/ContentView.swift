//
//  ContentView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // カメラ処理用ViewModel
    @ObservedObject var cameraViewModel    = CameraViewModel()
    // 方角UI用ViewModel
    @ObservedObject var directionViewModel = DirectionViewModel()
    
    var body: some View {        
        CapturePhotoView(cameraViewModel: self.cameraViewModel)
            .overlay(DirectionView(directionViewModel: self.directionViewModel))
            .overlay(TakeButton(cameraViewModel: self.cameraViewModel, directionViewModel: self.directionViewModel))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

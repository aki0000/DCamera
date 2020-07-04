//
//  TakeButtonView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//  写真を撮影するButton View

import SwiftUI

struct TakeButton: View {
    
    @State var isTake = false
    
    var cameraViewModel: CameraViewModel
    var directionViewModel: DirectionViewModel
        
    var body: some View {
        Button(action: {
            // 写真の撮影処理を実行
            self.cameraViewModel.takePhotoAfterTappedTakeButton()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.directionViewModel.captureDirectionView()
                self.isTake.toggle()
            })
        }, label: {
            // ボタンの画像を格納
          Image("button")
            .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
        })
            // 撮影後のViewを表示
            .sheet(isPresented: self.$isTake) {
                ImageTakenView(image: self.cameraViewModel.pullImageTaken(), directionImage: self.directionViewModel.pullDirectionImage())
        }
    }
}

struct TakeButton_Previews: PreviewProvider {
    static var previews: some View {
        TakeButton(cameraViewModel: CameraViewModel(), directionViewModel: DirectionViewModel())
    }
}

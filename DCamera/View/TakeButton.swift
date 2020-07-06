//
//  TakeButtonView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//  写真を撮影するButton View

import SwiftUI

struct TakeButton: View {
    
    // 写真を撮影した後のフラグ: 写真のImageと方角UIのImageが取得できた後にフラグが変化する
    @State var isTake = false
    
    // カメラ用のViewModel
    var cameraViewModel: CameraViewModel
    // 方角UIのViewModel
    var directionViewModel: DirectionViewModel
        
    var body: some View {
        Button(action: {
            // 写真の撮影処理を実行
            self.cameraViewModel.takePhotoAfterTappedTakeButton()
            // 方角UIのCAShapeLayerからUIImageへの変換に遅延があるため、同期処理とする
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                // 撮影した時の方角UIのImageをキャウチャーする
                self.directionViewModel.captureDirectionView()
                // 撮影フラグを発砲
                self.isTake.toggle()
            })
        }, label: {        
          Image("button")
            .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
            .resizable()
            .frame(width: 120, height: 120, alignment: .center)
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

//
//  TakeButtonView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//  写真を撮影するButton View

import SwiftUI

struct TakeButtonView: View {
    
    // 写真撮影用ViewModel
    @ObservedObject var takeButtonViewModel = TakeButtonViewModel()
    
    var body: some View {
        Button(action: {
            // 写真の撮影処理を実行
            self.takeButtonViewModel.takenPhoto()
        }, label: {
            // ボタンの画像を格納
          Image("button")
            .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
        })
            // 撮影後のViewを表示
            .sheet(isPresented: self.$takeButtonViewModel.isTake) {
                Text("Take").onAppear() {
                    print("take")
                }
        }
    }
}

struct TakeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TakeButtonView()
    }
}

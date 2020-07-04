//
//  ImageTakenView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import SwiftUI
import UIKit

struct ImageTakenView: View {
    
    // 現在表示されているViewの状態を管理
    @Environment(\.presentationMode) var presentationMode
    
    // 撮影された写真のUIImage
    var image: UIImage
    // 方角UIのUIImage
    var directionImage: UIImage
    // 撮影View用のViewModel
    var imageTakenViewModel = ImageTakenViewModel()
    
    var body: some View {
        VStack {
            // 合成されたImageを表示
            Image(uiImage: self.imageTakenViewModel.pullImageComposed(image: self.image, directionImage: self.directionImage))
                .resizable()
                .aspectRatio( 0.75, contentMode: .fit)
            HStack {
                // Save/Cancelボタン
                Button(action: {
                    // Cancelボタンがタップされた後のアクション
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(Color.red)
                })
                Spacer()
                Button(action: {
                    // Saveボタンがタップされた後のアクション
                    // 合成されたUIImageを写真として保存
                    self.imageTakenViewModel.savedComposedImage()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            }
            .padding()
        }
    }
}

struct ImageTakenView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTakenView(image: UIImage(), directionImage: UIImage())
    }
}

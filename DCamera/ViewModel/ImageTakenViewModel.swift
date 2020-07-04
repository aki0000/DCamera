//
//  ImageTakenViewModel.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import Foundation
import UIKit

class ImageTakenViewModel {
        
    // Imageモデル
    private var imageModel = ImageModel()    
    
    // 合成されたImageの取得
    func pullImageComposed(image: UIImage, directionImage: UIImage) -> UIImage {
        self.imageModel.image = composedImages(image: image, directionImage: directionImage)
        return self.imageModel.image
    }
    
    // 合成されたImageの保存
    func savedComposedImage() {
        UIImageWriteToSavedPhotosAlbum(self.imageModel.image, nil, nil, nil)
    }
    
    // 取得したImageの合成処理
    private func composedImages(image: UIImage, directionImage: UIImage) -> UIImage  {
        var composedImage = UIImage()
        
        // 合成されるImageのサイズは撮影されたImageのサイズを基準とする
        let composedWitdh  = image.size.width
        let composedHeight = image.size.height
        // 方角UIのImageと撮影されたImageの合成処理を開始
        UIGraphicsBeginImageContext(CGSize(width: composedWitdh, height: composedHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: composedWitdh, height: composedHeight))
        directionImage.draw(in: CGRect(x: 0, y: 0, width: composedWitdh, height: composedHeight))
        composedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return composedImage
    }
}

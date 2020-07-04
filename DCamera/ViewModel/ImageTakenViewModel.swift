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
    
    private var imageModel = ImageModel()    
    
    func pullImageComposed(image: UIImage, directionImage: UIImage) -> UIImage {
        self.imageModel.image = composedImages(image: image, directionImage: directionImage)
        return self.imageModel.image
    }
    
    // Save an image which is composed in device
    func savedComposedImage() {
        UIImageWriteToSavedPhotosAlbum(self.imageModel.image, nil, nil, nil)
    }
    
    private func composedImages(image: UIImage, directionImage: UIImage) -> UIImage  {
        var composedImage = UIImage()
        
        // Unify image size which the user is taken
        let composedWitdh  = image.size.width
        let composedHeight = image.size.height
        print(image, directionImage)
        // Begin to compose Image which the user is taken and Direction UI for Image
        UIGraphicsBeginImageContext(CGSize(width: composedWitdh, height: composedHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: composedWitdh, height: composedHeight))
        directionImage.draw(in: CGRect(x: 0, y: 0, width: composedWitdh, height: composedHeight))
        composedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return composedImage
    }
}

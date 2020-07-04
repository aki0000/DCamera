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
    
    @Environment(\.presentationMode) var presentationMode
    
    var image: UIImage
    var directionImage: UIImage
    
    var imageTakenViewModel = ImageTakenViewModel()
    
    var body: some View {
        VStack {
            Image(uiImage: self.imageTakenViewModel.pullImageComposed(image: self.image, directionImage: self.directionImage))
                .resizable()
                .aspectRatio( 0.75, contentMode: .fit)
            HStack {
                // Save & Cancell Button
                Button(action: {
                    // Action when the user tap cancel button
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(Color.red)
                })
                Spacer()
                Button(action: {
                    // Action when the user tap saved button
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

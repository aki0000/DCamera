//
//  DirectionView.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import SwiftUI

struct DirectionView: UIViewRepresentable {
    
    @ObservedObject var directionViewModel: DirectionViewModel
    
    func makeUIView(context: Context) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let view  = UIView(frame: frame)
        view.layer.addSublayer(self.directionViewModel.directionLayer)
        view.layer.addSublayer(self.directionViewModel.circleLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if uiView.layer.sublayers != nil {
            uiView.layer.sublayers![0] = self.directionViewModel.updateDirectionLayer()
        } else {
            NSLog("Error: Not exist DirectionLayer for updating")
        }
    }
}

struct DirectionView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionView(directionViewModel: DirectionViewModel())
    }
}

//
//  TakeButtonViewModel.swift
//  DCamera
//
//  Created by Akihisa Hino on 2020/07/04.
//  Copyright © 2020 Akihisa Hino. All rights reserved.
//

import Foundation

class TakeButtonViewModel: ObservableObject {
    // 写真撮影の実行フラグ
    @Published var isTake = false
    
    // 写真撮影を実行
    func takenPhoto() {        
        self.isTake = true
    }
}

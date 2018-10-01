//
//  CGFloat+Extension.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/1.
//  Copyright © 2018 李莎鑫. All rights reserved.
//

import Foundation
import UIKit

let fixes = UIScreen.main.scale * 0.5 == 1.0 ? CGFloat(1.0) : CGFloat(1.1)

let scale = UIScreen.main.bounds.height < 576.0 ? CGFloat(0.45) * fixes  : CGFloat(0.5) * fixes

extension Int {
    var cgFloat: CGFloat {
        return CGFloat(self) * scale
    }
}

extension Float {

    var cgFloat:CGFloat {
        return CGFloat(self) * scale
    }
}


extension Double {
    
    var cgFloat:CGFloat {
        return CGFloat(self) * scale
    }
    
}

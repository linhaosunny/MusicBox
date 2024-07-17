//
//  CGFloat+Extension.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/1.
//  Copyright © 2018 李莎鑫. All rights reserved.
//

import Foundation
import UIKit



extension CGFloat {
    var fixes: CGFloat {
        return UIScreen.main.scale * 0.5 == 1.0 ? CGFloat(1.0) : CGFloat(1.1)
    }
    
    var scale: CGFloat {
        let scale = UIScreen.main.bounds.height < 576.0 ? CGFloat(0.45) * fixes  : CGFloat(0.5) * fixes
        return self * scale
    }
}
extension Int {
    var cgFloat: CGFloat {
        return CGFloat(self).scale
    }
}

extension Float {

    var cgFloat:CGFloat {
        return CGFloat(self).scale
    }
}


extension Double {
    
    var cgFloat:CGFloat {
        return CGFloat(self).scale
    }
    
}

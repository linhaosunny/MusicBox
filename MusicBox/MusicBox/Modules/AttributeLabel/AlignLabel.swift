//
//  AlignLabel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/5/9.
//  Copyright © 2018年 Bok Man. All rights reserved.
//

import UIKit

public enum VerticalAlign : Int {
    
    case verticalAlignTop  = 0
    
    case verticalAlignCenter  = 1
    
    case verticalAlignBottom  = 2
    
}


class AlignLabel: UILabel {

    var verticalAlignment:VerticalAlign = .verticalAlignCenter {
        didSet {
            setNeedsDisplay() // : 重新绘制
        }
    }
    
    // MARK - 系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        switch verticalAlignment {
        case .verticalAlignTop:
            rect.origin.y = bounds.origin.y
        case .verticalAlignCenter:
            rect.origin.y = bounds.origin.y + (bounds.size.height - rect.size.height) * 0.5
        case .verticalAlignBottom:
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height
        }
        
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        
        super.drawText(in: actualRect)
    }
    
}

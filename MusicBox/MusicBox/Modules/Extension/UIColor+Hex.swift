//
//  UIColor+Hex.swift
//  MacroCaster-ws
//
//  Created by sunshine.lee on 2017/11/29.
//  Copyright © 2017年 Bok Man. All rights reserved.
//  颜色拓展类

import Foundation
import UIKit

extension UIColor {
    class public func colorWithHex(rgb:Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgb & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgb & 0xFF)) / 255.0, alpha: alpha)
    }
    
    class public func colorWithHex(rgb:Int) -> UIColor {
        return colorWithHex(rgb: rgb, alpha: 1.0)
    }
    
    /// 获取主题颜色
    class public func colorWithTheme(alpha: CGFloat = 1.0) -> UIColor {
        return colorWithHex(rgb: 0x1ad572, alpha: alpha)
       
    }
    
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // 随机颜色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}

extension UIColor {
    
    /// 获取UIColor的RCBA * 255的值
    ///
    /// - Returns: 返回
    public func getRGBA255() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let color = self.cgColor
        var num255s: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0 , 0)
        guard let numComponents = color.components else {
            return num255s
        }
        
        for (index, num) in numComponents.enumerated() {
            if index == 0 {
                num255s.0 = num * 255
            } else if index == 1 {
                num255s.1 = num * 255
            } else if index == 2 {
                num255s.2 = num * 255
            } else {
                num255s.3 = num
            }
        }
        return num255s
    }
}

//
//  UIButton+Radius.swift
//  MacroCaster-ws
//
//  Created by sunshine.lee on 2017/11/29.
//  Copyright © 2017年 Bok Man. All rights reserved.
//  UIView 圆角拓展

import Foundation
import UIKit

extension UIView {
    public func viewRadius(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func viewBorderRadius(_ radius:CGFloat,width:CGFloat,color:UIColor) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        
        layer.mask = cornerLayer
    }

}

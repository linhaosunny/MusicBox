//
//  UIImageView+Extension.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/2.
//  Copyright © 2018 李莎鑫. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// 添加旋转动画
    func addRotationAnimation() {
        layer.removeAnimation(forKey: "rotation")
        let roateAnimate = CABasicAnimation(keyPath: "transform.rotation.z")
        roateAnimate.fromValue = 0
        roateAnimate.toValue = Double.pi * 2.0
        roateAnimate.repeatCount = Float.greatestFiniteMagnitude
        roateAnimate.duration = 36
        layer.add(roateAnimate, forKey: nil)
    }
    
    /// 暂停
    func pauseAnimation() {
        layer.pauseAnimate()
    }
    
    /// 重启
    func resumeAnimation() {
        layer.resumeAnimate()
    }
    
    /// 设置圆角图片
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - size: <#size description#>
    func cornerImage(_ image:UIImage?,size:CGSize) {
        self.image = image
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners,
                                         cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

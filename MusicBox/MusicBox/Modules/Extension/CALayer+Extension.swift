//
//  CALayer+Extension.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/2.
//  Copyright © 2018 李莎鑫. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func pauseAnimate() {
        let pauseTime:CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
    
    func resumeAnimate() {
        let pausedTime: CFTimeInterval = timeOffset
        speed = 1.0;
        timeOffset = 0.0;
        beginTime = 0.0;
        let timeSincePause: CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause;
    }
}

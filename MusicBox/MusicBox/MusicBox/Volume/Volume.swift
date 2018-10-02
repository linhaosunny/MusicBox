//
//  Volume.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/3.
//  Copyright © 2018 李莎鑫. All rights reserved.
// 音量控制器

import Foundation
import UIKit
import MediaPlayer


public enum Volume
{
    public typealias Block = (_ divValue: Float) -> Void
    
    case up, down
    
    /// 当他改变的时候
    ///
    /// - Parameters:
    ///   - kind: <#kind description#>
    ///   - block: <#block description#>
    public static func when(_ kind: Volume, _ block: @escaping Block) {
        Volume.setup()
        var array = Volume.blocks[kind] ?? []
        array.append(block)
        Volume.blocks[kind] = array
    }
    
    /// 当他改变的时候
    ///
    /// - Parameter block: <#block description#>
    public func when(block: @escaping Block) {
        Volume.when(self, block)
    }
    
    /// 重置
    public static func reset() {
        Volume.blocks = [Volume: [Block]]()
        self.unsetup()
    }
    
    public static var keepIntact = true
    
    private static var blocks = [Volume: [Block]]()
    private static var hasSetup = false
    private static var volumeView: MPVolumeView!
    
    public static func use(volumeView: MPVolumeView) {
        self.volumeView = volumeView
    }
    
    private static var observer: Observer!
    
    
    ///初始化配置
    private static func setup() {
        if hasSetup {
            return
        }
        hasSetup = true
        
        if volumeView == nil {
            volumeView = MPVolumeView(frame: CGRect(x: 0,y: -100,width: 100,height: 50))
            UIApplication.shared.windows.first!.addSubview(volumeView!)
        }
        
        if observer == nil {
            observer = Observer()
        }
        
        volumeView?.slider?.addTarget(self.observer,action: #selector(Observer.sliderDidChange(_:)),
                                           for: .valueChanged)
    }
    
    /// 取消初始化配置
    private static func unsetup() {
        if !hasSetup {
            return
        }
        
        hasSetup = false
        self.volumeView?.slider?.removeTarget(self.observer,
                                              action: #selector(Observer.sliderDidChange(_:)),
                                              for: .valueChanged)
        self.observer = nil
        self.volumeView.removeFromSuperview()
        self.volumeView = nil
    }
    
    //MARK: Observer Delegate
    fileprivate static func didChange(up: Bool,div value:Float) {
        if let tempBlocks = Volume.blocks[up.asVolume] {
            for block in tempBlocks {
                DispatchQueue.main.async {
                    block(value)
                }
            }
        }
    }
}

@objc private class Observer: NSObject {
    private var initialValue: Float!
    
    private var activationCount = 2
    private var notify = true
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Observer.willBecomeInactive(_:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    /// 音量滑动
    ///
    /// - Parameter sender: <#sender description#>
    @objc fileprivate func sliderDidChange(_ sender: UISlider) {
        activationCount -= 1
        if activationCount > 0 {
            if initialValue == nil {
                initialValue = sender.value
            }
            return
        }
        if initialValue == nil {
            return
        }
        if !notify {
            notify = true
            return
        }
        if sender.value == initialValue {
            Volume.didChange(up: sender.value == 1.0,div: 0.0)
        } else {
            Volume.didChange(up: sender.value > initialValue,div: fabsf(sender.value - initialValue))
        }
        if Volume.keepIntact {
            notify = false
            sender.value = initialValue
        }
    }
    
    @objc fileprivate func willBecomeInactive(_ notification: NSNotification) {
        activationCount = 1
        initialValue = nil
    }
}

private extension MPVolumeView {
    var slider: UISlider? {
        return self.subviews.first(where: { $0 is UISlider }) as? UISlider
    }
}

private extension Bool {
    var asVolume: Volume {
        return self ? .up : .down
    }
}


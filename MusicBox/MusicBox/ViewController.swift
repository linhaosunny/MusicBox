//
//  ViewController.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/1.
//  Copyright © 2018 李莎鑫. All rights reserved.
//

import UIKit
import QorumLogs

class ViewController: UIViewController {
    
    var popMusicButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("弹出音乐盒", for: .normal)
        button.setTitleColor(UIColor.colorWithTheme(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28.0.cgFloat)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(popMusicButton)
        
        popMusicButton.viewBorderRadius(6.0.cgFloat, width: 2.0.cgFloat, color: UIColor.colorWithTheme())
        
        popMusicButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(200.0.cgFloat)
            make.height.equalTo(45.0.cgFloat)
        }
        
        popMusicButton.addTarget(self, action: #selector(popMusicBoxButtonClick), for: .touchUpInside)
        
        MusicBox.setupMusicBox(isInternelPlayer: true)
        
        setupPrintLog()
    }
    
    deinit {
        MusicBox.closePlay()
    }
    
    @objc fileprivate func popMusicBoxButtonClick() {
        MusicBox.showBox(.portrail, complete: { [weak self] (action, preference) in
            self?.processMusicBoxAction(action, preference: preference)
        })
    }
    
    fileprivate func processMusicBoxAction(_ action:MusicActionType,preference:PersionPreference) {
        switch action {
        case .switchPlay:
            QL1("切换歌曲")
//            let playUrl = preference.playUrl ?? ""
//
//            livePusher?.startBGM(withMusicPathAsync: playUrl)
//            livePusher?.setAudioDenoise(true)
//            livePusher?.setBGMEarsBack(true)
//            livePusher?.setCaptureVolume(50)
        case .play:
            QL1("播放和暂停")
//            if preference.isPlay {
//                livePusher?.resumeBGM()
//            } else {
//                livePusher?.pauseBGM()
//            }
        case .stop:
            QL1("播放和暂停")
//            livePusher?.stopBGMAsync()
        case .mute:
            QL1("静音和恢复播放")
//            if !preference.isMute {
//                livePusher?.setBGMVolume(Int32(preference.volume))
//            } else {
//                livePusher?.setBGMVolume(0)
//            }
        case .volume:
            QL1("音量调整")
//            livePusher?.setBGMVolume(Int32(preference.volume))
        case .runLoop:
            QL1("歌曲循环")
//            livePusher?.setBGMLoop(preference.isRunLoop)
        case .songList:
            QL1("进入本地曲库列表")
        }
    }

    /// 使用打印工具
    fileprivate func setupPrintLog() {
        //: 使用调试打印工具
        QorumLogs.enabled = true
        QorumLogs.minimumLogLevelShown = 1
    }
}


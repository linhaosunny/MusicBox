//
//  MusicPlayer.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/2.
//  Copyright © 2018 李莎鑫. All rights reserved.
//  音乐播放器

import UIKit
import AVFoundation

class MusicPlayer: NSObject {
    
    static let shared = MusicPlayer()
    
    fileprivate var player:AVAudioPlayer?
    
    /// 是否单曲循环
    fileprivate var isLoop:Bool = false {
        didSet {
            player?.numberOfLoops = isLoop ? -1 : 0
        }
    }
    
    /// 初始化播放器
    class func setupPlayer() {
        let session = AVAudioSession.sharedInstance()
        if #available(iOS 10.0, *) {
            try? session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers])
        }
        
        try? session.setActive(true, options: [.notifyOthersOnDeactivation])
    }
    
    /// 播放切换歌曲
    ///
    /// - Parameter filePath: <#filePath description#>
    /// - Returns: <#return value description#>
    @discardableResult
    class func playMusic(_ filePath:String) -> Bool {
        let player = try? AVAudioPlayer.init(contentsOf: URL(fileURLWithPath: filePath))
        player?.numberOfLoops = 0
        player?.delegate = shared
        shared.player = player
        
        if let result = player?.prepareToPlay() {
            if result {
                resumePlayer()
            }
            return result
        }
        
        return false
    }
    
    class func resumePlayer() {
        if let player = shared.player,!player.isPlaying {
            player.play()
        }
    }
    
    class func pausePlayer() {
        if let player = shared.player,player.isPlaying {
            player.pause()
        }
    }
    
    class func stopPlayer() {
        if let player = shared.player, player.isPlaying {
            player.stop()
        }
    }
    
    class func setLoop(_ isLoop:Bool = false) {
        shared.isLoop = isLoop
    }
    
    class func updateVolume(_ volume:Float) {
        shared.player?.volume = volume
        shared.player?.updateMeters()
    }
}

extension MusicPlayer:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}

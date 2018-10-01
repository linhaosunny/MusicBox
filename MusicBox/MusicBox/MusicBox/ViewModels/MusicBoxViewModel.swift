//
//  MusicBoxViewModel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/13.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  音乐盒视图模型

import UIKit

/// 播放器动作
///
/// - switchPlay: <#switchPlay description#>
/// - play: <#play description#>
/// - mute: <#mute description#>
/// - voluem: <#voluem description#>
/// - songList: <#songList description#>
/// - runLoop: <#runLoop description#>
public enum MusicActionType : Int {
    /* 切歌 */
    case switchPlay = 0
    /* 播放 */
    case play  = 1
    /* 停止 */
    case stop = 2
    /* 静音 */
    case mute  = 3
    /* 音量调整 */
    case volume = 4
    /* 歌曲列表 */
    case songList = 5
    /* 歌曲循环 */
    case runLoop = 6
}

public enum MusicLoadingStatus : Int {
    /* 开始加载 */
    case start = 0
    /* 加载中 */
    case loading  = 1
    /* 加载完成 */
    case loaded  = 2

}

class MusicBoxViewModel: NSObject {
    
    var musicLabelText:String?

    var musicListButtonIcon:String?
    
    var playerButtonPlayIcon:String?
    
    var playerButtonPauseIcon:String?
    
    var muteButtonNormalIcon:String?
    
    var muteButtonSelectIcon:String?
    
    var playloopButtonNormalIcon:String?
    
    var playloopButtonSingleLoopIcon:String?
    
    var playvolumeSliderButtonIcon:String?
    
    var currentPlayVolume:Int = 0
    
    var isMute:Bool = false
    
    var isRunLoop:Bool = false
    
    var playList:[MusicPlayListCellViewModel]?
    
    /// 构造方法
    ///
    /// - Returns: <#return value description#>
    class func createViewModel() -> MusicBoxViewModel {
        let model = MusicBoxViewModel()
        model.musicLabelText = "配乐"
        model.musicListButtonIcon = "live_popup_icon_music"
        model.playerButtonPlayIcon = "live_popup_icon_broadcast".nameWithTheme()
        model.playerButtonPauseIcon = "live_popup_icon_suspend".nameWithTheme()
        model.playloopButtonNormalIcon = "live_popup_icon_cycle2"
        model.playloopButtonSingleLoopIcon = "live_popup_icon_cycle"
        model.muteButtonNormalIcon = "live_popup_icon_volume"
        model.muteButtonSelectIcon = "live_popup_icon_static"
        model.playvolumeSliderButtonIcon = "live_popup_icon_circular".nameWithTheme()
        model.currentPlayVolume = 20
        
        if let preference = Preference.shared.preference {
            model.currentPlayVolume = preference.volume
            model.isMute = preference.isMute
            model.isRunLoop = preference.isRunLoop
        }
        
        model.getPlayList()
        
        return model
    }
    
    func getPlayList(){
        var modelList:[MusicPlayListCellViewModel] = [MusicPlayListCellViewModel]()
        if let list = MusicBox.shared.playList {
            for song in list {
                modelList.append(MusicPlayListCellViewModel(song))
            }
        }
        
        playList = modelList
    }
    
    /// 更新数据
    ///
    /// - Parameter cellModel: <#cellModel description#>
    func updateViewModel(_ cellModel:MusicPlayListCellViewModel?) {
        if let song = cellModel?.song {
            MusicBox.deletePlayListSong(song)
            getPlayList()
        }
    }
    
    /// 更新本地曲库
    func updateLocalList() {
        if MusicBox.isMusicListNeededUpdate() {
            MusicBox.updateMusicList({
            }) { (msg) in
            }
        }
    }
}

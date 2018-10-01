//
//  PersionPreference.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/14.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  个人配置信息

import UIKit

class PersionPreference: NSObject {
    
    /// 是否刷新
    var isUpdate:Bool = false
    
    /// 歌曲名
    var songName:String? {
        didSet {
            isUpdate = true
        }
    }
    
    /// 歌手
    var songArtist:String? {
        didSet {
            isUpdate = true
        }
    }
    
    /// 歌曲资源本地链接
    var playUrl:String? {
        didSet {
            isUpdate = true
        }
    }

    /// 是否播放
    var isPlay:Bool = false
    
    /// 是否静音
    var isMute:Bool = false {
        didSet {
            isUpdate = true
        }
    }
    
    /// 是否单曲循环
    var isRunLoop:Bool = false {
        didSet {
            isUpdate = true
        }
    }
    
    /// 音量
    var volume:Int = 0 {
        didSet {
            isUpdate = true
        }
    }
    
    
    /// 转换成对象
    ///
    /// - Parameter dict: <#dict description#>
    convenience init(_ dict:[String:Any] ) {
        self.init()
        
        songName = (dict["songName"] as? String) ?? ""
        songArtist = (dict["songArtist"] as? String) ?? ""
        playUrl = (dict["playUrl"] as? String) ?? ""
        isMute = (dict["isMute"] as? Bool) ?? false
        isRunLoop = (dict["isRunLoop"] as? Bool) ?? false
        volume = (dict["volume"] as? Int) ?? 0
        isUpdate = false
    }
    
    /// 转换成字典
    ///
    /// - Returns: <#return value description#>
    func dictionary() -> [String:Any] {
        var dict:[String:Any] = [String:Any]()
        dict.updateValue(songName ?? "", forKey: "songName")
        dict.updateValue(songArtist ?? "", forKey: "songArtist")
        dict.updateValue(playUrl ?? "", forKey: "playUrl")
        dict.updateValue(isMute, forKey: "isMute")
        dict.updateValue(isRunLoop, forKey: "isRunLoop")
        dict.updateValue(volume, forKey: "volume")
        return dict
    }
}

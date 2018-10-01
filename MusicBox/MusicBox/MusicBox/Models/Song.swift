//
//  Song.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/12.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  歌曲信息

import UIKit

/// 歌曲是否添加到播放列表
///
/// - add: <#add description#>
/// - delete: <#delete description#>
public enum SongAddType : String {
    /* 添加 */
    case add = "true"
    /* 移除 */
    case delete = "delete"
    
}

class Song: NSObject {
    
    /// 歌曲名称
    var title:String?
    
    /// 歌曲作者
    var artist:String?
    
    /// 歌曲简介
    var albumArtist:String?
    
    /// 歌曲资源本地链接
    var localUrl:String?
    
    /// 歌曲资源外部链接
    var serverUrl:String?
    
    /// 歌曲播放时长
    var playBackDuration:String?
    
    /// 是否添加到播放列表
    var isAddPlayList:String = SongAddType.delete.rawValue
    
    /// 转换成对象
    ///
    /// - Parameter dict: <#dict description#>
    convenience init(_ dict:[String:String] ) {
        self.init()
        
        title = dict["title"]
        artist = dict["artist"]
        albumArtist = dict["albumArtist"]
        localUrl = dict["localUrl"]
        serverUrl = dict["serverUrl"]
        playBackDuration = dict["playBackDuration"]
        isAddPlayList = dict["isAddPlayList"] ?? SongAddType.delete.rawValue
    }
    
    /// 转换成字典
    ///
    /// - Returns: <#return value description#>
    func dictionary() -> [String:String] {
        var dict:[String:String] = [String:String]()
        dict.updateValue(title ?? "", forKey: "title")
        dict.updateValue(artist ?? "", forKey: "artist")
        dict.updateValue(albumArtist ?? "", forKey: "albumArtist")
        dict.updateValue(localUrl ?? "", forKey: "localUrl")
        dict.updateValue(serverUrl ?? "", forKey: "serverUrl")
        dict.updateValue(playBackDuration ?? "", forKey: "playBackDuration")
        dict.updateValue(isAddPlayList, forKey: "isAddPlayList")
        return dict
    }
}

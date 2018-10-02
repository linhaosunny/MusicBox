//
//  MusicListCellViewModel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  

import UIKit

class MusicListCellViewModel: NSObject {

    /// 歌曲名和作者
    var titleText:String?
    
    /// 歌曲时长
    var timeLabelText:String?
    
    /// 封面图
    var albumPicturePath:String?
    
    /// 未添加
    var addButtonNormalIcon:String?
    
    /// 添加选中
    var addButtonSeletedIcon:String?
    
    var isAdd:Bool = false
    
    var song:Song?
    
    convenience init(_ song:Song) {
        self.init()
        self.song = song
        titleText = (song.title ?? "") + " - " + (song.artist ?? "")
        timeLabelText = song.playBackDuration ?? ""
        albumPicturePath = AlbumPictures.albumPicturesLocalPath(song.albumPicturePath ?? "")
        addButtonNormalIcon = "live_music_icon_plus"
        addButtonSeletedIcon = "select_btn_s".nameWithTheme()
        isAdd = Bool(song.isAddPlayList) ?? false
    }
}

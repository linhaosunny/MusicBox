//
//  MusicListCellViewModel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  

import UIKit

class MusicListCellViewModel: NSObject {

    var titleText:String?
    
    var timeLabelText:String?
    
    var addButtonNormalIcon:String?
    
    var addButtonSeletedIcon:String?
    
    var isAdd:Bool = false
    
    var song:Song?
    
    convenience init(_ song:Song) {
        self.init()
        self.song = song
        titleText = song.title ?? ""
        timeLabelText = song.playBackDuration ?? ""
        addButtonNormalIcon = "live_music_icon_plus"
        addButtonSeletedIcon = "select_btn_s".nameWithTheme()
        isAdd = Bool(song.isAddPlayList) ?? false
    }
}

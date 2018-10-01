//
//  MusicPlayListCellViewModel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  播放列表视图模型

import UIKit

class MusicPlayListCellViewModel: NSObject {
    
    var titleText:String?
    
    var isDelete:Bool  = false
    
    var deleteButtonIcon:String?
    
    var song:Song?
    
    var isSelected:Bool = false
    
    convenience init(_ song:Song,isSelected:Bool = false) {
        self.init()
        self.song = song
        self.isSelected = isSelected
        titleText = (song.title ?? "") + " - " + (song.artist ?? "")
        deleteButtonIcon = "btn_close"
        isDelete = !(Bool(song.isAddPlayList) ?? false)
    }
}

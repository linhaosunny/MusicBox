//
//  MusicLocalListViewModel.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  本地音乐列表

import UIKit

class MusicLocalListViewModel: NSObject {
    var addMusicTitleText:String {
        get {
            return "添加配乐"
        }
    }
    
    var totalMusicText:String {
        get {
            return "本地配乐共"
        }
    }
    
    var startLoadingText:String {
        get {
            return "开始加载曲库..."
        }
    }
    
    var loadingText:String {
        get {
            return "曲库加载中..."
        }
    }
    
    var totalMusicUnitText:String {
        get {
            return "首"
        }
    }
    
    var totalMusicNumText:String?
    
    var closeButtonIcon:String?
    
    var status:MusicLoadingStatus = .loaded
    
    var dataList:[MusicListCellViewModel]?
    
    class func createViewModel() -> MusicLocalListViewModel {
        let model = MusicLocalListViewModel()
        model.closeButtonIcon = "btn_close"
        
        var modelList:[MusicListCellViewModel] = [MusicListCellViewModel]()
        if let list = MusicBox.shared.songList {
            for song in list {
                modelList.append(MusicListCellViewModel(song))
            }
        }
        model.dataList = modelList
        model.totalMusicNumText = "\(modelList.count)"
        
        return model
    }
    
    /// 更新数据
    ///
    /// - Parameter cellModel: <#cellModel description#>
    func updateViewModel(_ cellModel:MusicListCellViewModel?) {
        if let song = cellModel?.song {
            MusicBox.appendPlayListSong(song)
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

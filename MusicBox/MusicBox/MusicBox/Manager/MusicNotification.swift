//
//  MusicNotification.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/15.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  一些通知

import Foundation


/// 内部播放器播放一曲结束
let MusicBoxInterPlayerPlayCompletedKey = NSNotification.Name("MusicBox.InternalPlayer.playCompleted")

/// 下一曲
let MusicBoxPlayNextSongKey = NSNotification.Name("MusicBox.playNextSong")

/// 加载状态
let MusicBoxSongLoadingStatusKey = NSNotification.Name("MusicBox.SongLoading")

//
//  MusicBox.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/12.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  音乐盒

import UIKit
import QorumLogs
import MediaPlayer

public enum ScreenDirection:Int {
    
    case landscape = 0
    
    case portrail = 1
    
}

class MusicBox: NSObject {
    
    static let shared = MusicBox()
    
    var musicBoxModel: MusicBoxViewModel?
    
    fileprivate let userKey = "sunshine.lee:" + "\(120834064)"
    
    fileprivate let documentPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    var musicsPath:String {
        get {
            return documentPath + "/musics/"
        }
    }
    // 本地曲库歌曲信息
    var songList:[Song]?
    // 播放列表
    var playList:[Song]?
    
    var playListSelectIndexPath:IndexPath?
    
    var isPlaying:Bool = false
    
    // 是否运行在后台
    var isMusixBoxBackground:Bool = true
    // 歌曲加载状态
    var loadSongStatus:MusicLoadingStatus = .loaded
    // 是否使用内部播放器
    fileprivate var isInternelPlayer:Bool = false
    
    fileprivate var completed:((_ action:MusicActionType,_ info:PersionPreference)->())?
    
    
    deinit {
        if isInternelPlayer {
            NotificationCenter.default.removeObserver(self, name: MusicBoxInterPlayerPlayCompletedKey, object: nil)
        }
    }
    
    /// 初始化音乐盒
    class func setupMusicBox(isInternelPlayer:Bool = true) {
    
        if shared.isInternelPlayer {
            NotificationCenter.default.removeObserver(self, name: MusicBoxInterPlayerPlayCompletedKey, object: nil)
        }
        
        shared.isInternelPlayer = isInternelPlayer

        if isInternelPlayer {
            MusicPlayer.setupPlayer()
            NotificationCenter.default.addObserver(shared, selector: #selector(internalPlayerPlayCompleted), name: MusicBoxInterPlayerPlayCompletedKey, object: nil)
        }

        // 读取个人配置
        Preference.getPreference(shared.userKey,song:nil)
        
        openMediaService { (isOpen) in
            if isOpen {
                // 读取本地歌曲，获取播放列表
                readLocalMusic({
                    getMusicListSong()
                }) { (msg) in
                    
                }
            }
        }
        
    }
    
    /// 检查是否打开媒体库
    ///
    /// - Parameter acttoin: <#acttoin description#>
    class func openMediaService(_ acttoin:@escaping (_ isOpen:Bool)->()) {
        if #available(iOS 9.3, *) {
            let authStatus = MPMediaLibrary.authorizationStatus()
            switch authStatus {
            case .notDetermined:
                MPMediaLibrary.requestAuthorization { (status) in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            acttoin(true)
                        }
                    default:
                        DispatchQueue.main.async {
                            acttoin(false)
                        }
                    }
                }
            case .authorized:
                acttoin(true)
            default:
                acttoin(false)
            }
            
        } else {
           acttoin(true)
        }
    }
    
    /// 显示音乐盒
    ///
    /// - Parameters:
    ///   - screen: <#screen description#>
    ///   - complete: <#complete description#>
    class func showBox(_ screen:ScreenDirection = .portrail, complete:@escaping (_ action:MusicActionType,_ info:PersionPreference)->()) {
        
        //使用内部播放器
        if shared.isInternelPlayer {
            shared.completed = internalPlayerComplete()
        } else {
            shared.completed = complete
        }
        
        if let operation = shared.completed {
            let musicBox = MusicBoxPopView(screen, complete: operation, finish: {(view) in
                if Preference.shared.isUpdate {
                    Preference.updatePeferenceFile(shared.userKey, successed: { (prefrence, msg) in
                        view?.viewModel = MusicBoxViewModel.createViewModel()
                    }, failed: { (msg) in
                    })
                }
            })
            musicBox.viewModel = MusicBoxViewModel.createViewModel()
            musicBox.show()
        }
    }
    
    /// 读取本地音乐
    ///
    /// - Parameters:
    ///   - success: <#success description#>
    ///   - fail: <#fail description#>
    class func readLocalMusic(_ success:@escaping ()->(),fail:@escaping (_ msg:String)->()) {
        let media = MPMediaQuery()
        let predicate = MPMediaPropertyPredicate(value: NSNumber(value: MPMediaType.music.rawValue), forProperty: MPMediaItemPropertyMediaType)
        media.addFilterPredicate(predicate)
        
        getMusicList()
        
        if let items = media.items {
    
            findNewSong(items)
            
            if MusicList.getNewSongNum() > 0 {
                exportNewSong(items, success: success, fail: fail)
            } else {
                success()
            }
        }
    }
    
    /// 获取歌曲的实际路径
    ///
    /// - Parameter songName: <#songName description#>
    /// - Returns: <#return value description#>
    class func songLocalPath(_ songName:String) -> String {
        return shared.musicsPath + songName
    }
    
    /// 检查是否同一首歌
    ///
    /// - Parameters:
    ///   - localSong: <#localSong description#>
    ///   - checkSong: <#checkSong description#>
    /// - Returns: <#return value description#>
    class func isSameSong(_ localSong:Song,checkSong:Song) -> Bool {
        
        return MusicList.isSameSong(localSong, checkSong: checkSong)
    }
}

// MARK: - 内部播放工具
extension MusicBox {
    
    /// 内部播放器播放结束
    @objc fileprivate func internalPlayerPlayCompleted() {
        if isInternelPlayer {
            MusicBox.nextSong()
        }
    }
    
    /// 内部播放操作
    ///
    /// - Parameter operation: <#operation description#>
    /// - Returns: <#return value description#>
    fileprivate class func internalPlayerOperation(_ operation:@escaping ((_ action:MusicActionType,_ info:PersionPreference)->()) ) -> ((_ action:MusicActionType,_ info:PersionPreference)->()) {
        return operation
    }
    
    /// 内部播放操作
    fileprivate class func internalPlayerComplete() -> ((_ action:MusicActionType,_ info:PersionPreference)->()) {
        return internalPlayerOperation { (action, preference) in
            switch action {
            case .switchPlay:
                QL1("切换歌曲")
                let playUrl = preference.playUrl ?? ""
                
                MusicPlayer.playMusic(playUrl)
                
//                livePusher?.startBGM(withMusicPathAsync: playUrl)
//                livePusher?.setAudioDenoise(true)
//                livePusher?.setBGMEarsBack(true)
//                livePusher?.setCaptureVolume(50)
            case .play:
                QL1("播放和暂停")
                if preference.isPlay {
                    MusicPlayer.resumePlayer()
                } else {
                    MusicPlayer.pausePlayer()
                }
            case .stop:
                QL1("结束播放")
                MusicPlayer.stopPlayer()
            case .mute:
                QL1("静音和恢复播放")
                if !preference.isMute {
                      MusicPlayer.updateVolume(Float(preference.volume)/100.0)
                } else {
                      MusicPlayer.updateVolume(0.0)
                }
            case .volume:
                QL1("音量调整")
                MusicPlayer.updateVolume(Float(preference.volume)/100.0)
            case .runLoop:
                QL1("歌曲循环")
                MusicPlayer.setLoop(preference.isRunLoop)
            case .songList:
                QL1("进入本地曲库列表")
            }
        }
    }
}

// MARK: - 相关工具
extension MusicBox {
    
    class func timeToSeconds(time: TimeInterval) -> String {
        
        let timeTicks = time

        let minute = Int(timeTicks) / 60
        
        let seconds = Int(timeTicks) % 60
        
        return String(format: "%02d:%02d", arguments: [minute, seconds])
    }
    
    /// 添加到播放列表
    ///
    /// - Parameter song: <#song description#>
    class func appendPlayListSong(_ song:Song) {
        shared.playList = MusicList.updatePlayList(shared.userKey, song: song, type: .add)
    }
    
    /// 从播放列表移除
    ///
    /// - Parameter song: <#song description#>
    class func deletePlayListSong(_ song:Song) {
        shared.playList = MusicList.updatePlayList(shared.userKey, song: song, type: .delete)
    }
    
    /// 更新本地曲目
    ///
    /// - Parameters:
    ///   - success: <#success description#>
    ///   - fail: <#fail description#>
    class func updateMusicList(_ success:@escaping ()->(),fail:@escaping (_ msg:String)->()) {
        
        if MusicList.isNeededUpdateLocal() {
            
            MusicList.updateMusicFile(shared.userKey, successed: { (list, msg) in
                getMusicList()
                success()
            }) { (msg) in
                fail(msg)
            }
        }
    }
    
    /// 检查曲库信息是否更改
    ///
    /// - Returns: <#return value description#>
    class func isMusicListNeededUpdate() -> Bool {
        return MusicList.isNeededUpdateLocal()
    }
}

// MARK: - 播放歌曲操作
extension MusicBox {
    
    /// 结束播放器
    class func closePlay() {
        if let preference = Preference.shared.preference {
            shared.completed?(.stop,preference)
        }
    }
    
    /// 播放下一曲
    class func nextSong() {
         // 是否单曲循环
        if shared.isPlaying, let preference = Preference.shared.preference,preference.isRunLoop == false {
            // 如果在后台播放
            if shared.isMusixBoxBackground {
                guard let index = shared.playListSelectIndexPath?.item,let list = shared.playList else {
                    return
                }
                
                var item = index + 1
                if item >= list.count {
                    item = 0
                }
                
                let song = list[item]
                shared.playListSelectIndexPath = IndexPath(item: item, section: 0)
                
                
                preference.songName = song.title ?? ""
                preference.songArtist = song.artist ?? ""
                if let playUrl = song.localUrl {
                    preference.playUrl = songLocalPath(playUrl)
                } else {
                    preference.playUrl = song.serverUrl ?? ""
                }
                shared.completed?(.switchPlay,preference)
                
            } else {
                NotificationCenter.default.post(name: MusicBoxPlayNextSongKey, object: nil)
            }
        }
    }
}

// MARK: - 歌曲文件和歌曲目录处理
extension MusicBox {
    
    /// 加载消息分发
    ///
    /// - Parameter status: <#status description#>
    fileprivate class func postLoadingMessage(_ status:MusicLoadingStatus) {
        var params:[String:Int] = [String:Int]()
        params.updateValue(status.rawValue, forKey: "status")
        
        if status == .loading {
            NotificationCenter.default.post(name: MusicBoxSongLoadingStatusKey, object: params)
        } else {
          if status != shared.loadSongStatus {
            shared.loadSongStatus = status
            NotificationCenter.default.post(name: MusicBoxSongLoadingStatusKey, object: params)
           }
        }
        
    }
    
    /// 导出新的歌曲
    ///
    /// - Parameters:
    ///   - items: <#items description#>
    ///   - success: <#success description#>
    ///   - fail: <#fail description#>
    fileprivate class func exportNewSong(_ items:[MPMediaItem],success:@escaping ()->(),fail:@escaping (_ msg:String)->()) {
        for song in items {
            QL2("歌曲名称：" + "\(song.title ?? "")" + "\n" +
                "歌曲简介:" + "\(song.albumArtist ?? "")" + "\n" +
                "歌曲作者:" + "\(song.artist ?? "")" + "\n" +
                "歌曲链接:" + "\(String(describing: song.assetURL?.absoluteString))"
            )
            
            // 如果有该歌曲不用导出
            if checkHasSong(title: song.title ?? "", artist: song.artist ?? "") {
                continue
            }
            
            
            postLoadingMessage(.start)
            
            // 导出文件
            exportMusicToMp3(song, completed: { (songUrl, msg) in
                /// 歌曲信息
                let localSong = Song()
                localSong.title = song.title
                localSong.artist = song.artist
                localSong.albumArtist = song.albumArtist
                localSong.ipodLibraryUrl = song.assetURL?.absoluteString
                localSong.localUrl = songUrl
                localSong.playBackDuration = timeToSeconds(time: song.playbackDuration)
                
                appendMusicListSong(localSong)
                
                MusicList.plusNewSongNum()
                
                postLoadingMessage(.loading)
                
                if MusicList.getNewSongNum() < 1 {
                    updateMusicList(success, fail: fail)
                    postLoadingMessage(.loaded)
                }
                
            }) { (msg) in
                fail(msg)
                MusicList.plusNewSongNum()
            }
        }
    }
    
    /// 新增曲目数量
    ///
    /// - Parameter items: <#items description#>
    fileprivate class func findNewSong(_ items:[MPMediaItem]) {
        for song in items {
            // 如果有该歌曲不用导出
            if checkHasSong(title: song.title ?? "", artist: song.artist ?? "") {
                continue
            }
            MusicList.increaseNewSongNum()
        }
    }
    
    /// 检查是否有该曲目
    ///
    /// - Parameters:
    ///   - tiltle: <#tiltle description#>
    ///   - artist: <#artist description#>
    /// - Returns: <#return value description#>
    fileprivate class func checkHasSong(title:String,artist:String) -> Bool {
        guard title != "",artist != "", let list = shared.songList else {
            return false
        }
        
        for song in list {
            if let songTitle = song.title,let songArtist = song.artist, songTitle != "", songArtist != "",title == songTitle,artist == songArtist  {
                return true
            }
        }
        
        return false
    }
    
    
    /// 获取歌曲列表
    ///
    /// - Returns: <#return value description#>
    @discardableResult
    fileprivate class func getMusicList() -> [Song]? {
        shared.songList = MusicList.getMusicList(shared.userKey)
        return shared.songList
    }
    
    /// 获取播放列表
    fileprivate class func getMusicListSong() {
        shared.playList = MusicList.getPlayList(shared.userKey)
    }
    
    /// 添加歌曲
    ///
    /// - Parameter song: <#song description#>
    fileprivate class func appendMusicListSong(_ song:Song) {
        MusicList.appendMusic(shared.userKey, song: song)
    }
    
    /// 获取加载中的曲库
    public class func getLoadMusicList() {
        shared.songList = MusicList.getLoadSongList()
        return
    }
   
    
    /// 转换成mp3格式
    ///
    /// - Parameters:
    ///   - song: <#song description#>
    ///   - completed: <#completed description#>
    ///   - failed: <#failed description#>
    fileprivate class func exportMusicToMp3(_ song:MPMediaItem,completed:@escaping (_ path:String,_ msg:String)->(),failed:@escaping (_ msg:String)->()){
        if let url = song.assetURL {
            let asset = AVURLAsset(url: url)
            let manger = FileManager.default
            let musicPath = shared.musicsPath
            
            do {
                try manger.createDirectory(atPath: musicPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                failed("创建目录失败:错误代码 - #" + error.localizedDescription + "#")
            }
            
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
            exporter?.outputFileType = AVFileType("com.apple.m4a-audio")
            
            let fileName = song.title! + ".m4a"
            let exportFile = musicPath  + fileName
            
            if manger.fileExists(atPath: exportFile) {
                do {
                    try  manger.removeItem(atPath: exportFile)
                }
                catch {
                    failed("打开文件失败:错误代码 - #" + error.localizedDescription + "#")
                }
            }
            
            let urlPath = URL(fileURLWithPath: exportFile)
            exporter?.outputURL = urlPath
            
            exporter?.exportAsynchronously(completionHandler: {
                if let exporter = exporter {
                    switch exporter.status {
                    case .unknown:
                        failed("#文件导出未知异常! - # ," + (exporter.error?.localizedDescription ?? "") + "#")
                    case .completed:
                        completed(fileName,"#文件导出成功!#")
                    case .cancelled:
                        failed("#文件导出被取消! - # ," + (exporter.error?.localizedDescription ?? "") + "#")
                    case .failed:
                        failed("#文件导出失败! - #" + (exporter.error?.localizedDescription ?? "") + "#")
                    default:
                        break
                        
                    }
                }
            })
            
        }
        
    }
}

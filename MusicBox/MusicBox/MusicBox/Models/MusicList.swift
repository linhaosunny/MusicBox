//
//  MusicList.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/12.
//  Copyright © 2018年 Bok Man. All rights reserved.
//  歌曲播放列表

import UIKit

class MusicList: NSObject {
    static let shared = MusicList()
    
    fileprivate let documentPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    var musicsInfoPath:String {
        get {
            return documentPath + "/musicInfo-list/"
        }
    }
    
    fileprivate var songNewNum:Int = 0
    
    fileprivate var isUpdateList:Bool = false
    
    fileprivate var songList:[Song] = {
        let list = [Song]()
        
        return list
    }()
    
    /// 添加歌曲到本地曲库
    ///
    /// - Parameter song: <#song description#>
    class func appendMusic(_ user:String,song:Song) {
        shared.songList.append(song)
        shared.isUpdateList = true
    }
    
    /// 获取播放列表
    ///
    /// - Parameter user: <#user description#>
    /// - Returns: <#return value description#>
    class func getPlayList(_ user:String) -> [Song]{
        var playList:[Song] = [Song]()
        
        for localSong in shared.songList {
            if let type = SongAddType(rawValue: localSong.isAddPlayList) {
                switch type {
                case .add:
                    playList.append(localSong)
                default:
                    break
                }
            }
        }
        
        return playList
    }
    
    /// 更新播放列表
    ///
    /// - Parameters:
    ///   - user: <#user description#>
    ///   - song: <#song description#>
    class func updatePlayList(_ user:String,song:Song,type:SongAddType) -> [Song]  {

        for localSong in shared.songList {
            if isSameSong(localSong, checkSong: song) {
                localSong.isAddPlayList = type.rawValue
                shared.isUpdateList = true
            }
        }
        
        return getPlayList(user)
    }
    
    /// 检查是否同一首歌
    ///
    /// - Parameters:
    ///   - localSong: <#localSong description#>
    ///   - checkSong: <#checkSong description#>
    /// - Returns: <#return value description#>
    class func isSameSong(_ localSong:Song,checkSong:Song) -> Bool {
        
        guard let localTitle = localSong.title,let checkTitle = checkSong.title,
            localTitle != "",checkTitle != "", localTitle == checkTitle,
            let localArtist = localSong.artist,let checkArtist = checkSong.artist,
            localArtist != "",checkArtist != "", localArtist == checkArtist else {
            return false
        }
        
        return true
    }
    
    /// 获取用户歌曲列表
    ///
    /// - Parameter user: <#user description#>
    /// - Returns: <#return value description#>
    class func getMusicList(_ user:String) -> [Song]? {
        let musicsFilePath = shared.musicsInfoPath + "\(user)-musicsinfo.plist"
        if let musicList = NSArray(contentsOfFile: musicsFilePath) {
            if shared.songList.count > 0 {
                shared.songList.removeAll()
            }
            
            for dict in musicList {
                if let item = dict as? [String:String] {
                    let song = Song(item)
                    shared.songList.append(song)
                }
            }
            
            return shared.songList
        }
       
        return nil
    }
    
    /// 是否需要更新本地文件
    ///
    /// - Returns: <#return value description#>
    class func isNeededUpdateLocal() -> Bool {
        return shared.isUpdateList
    }
    
    /// 新增的曲目
    ///
    /// - Returns: <#return value description#>
    class func getNewSongNum() -> Int {
        return shared.songNewNum
    }
    
    /// 歌曲数目增加
    class func increaseNewSongNum() {
        shared.songNewNum += 1
    }
    
    /// 歌曲数目减少
    class func plusNewSongNum() {
        if getNewSongNum() > 0 {
            shared.songNewNum -= 1
        }
    }
    /// 判断文件是否存在
    ///
    /// - Parameter filePath: <#filePath description#>
    /// - Returns: <#return value description#>
    class func fileExistAtPath(_ filePath:String) -> Bool {
        if (FileManager.default.fileExists(atPath: filePath))
        {
            return true
        }
        return false
    }
    
    /// 删除文件
    ///
    /// - Parameter user: <#user description#>
    /// - Returns: <#return value description#>
    class func deleteMusicFile(_ user:String,successed:@escaping (_ msg:String)->(),failed:@escaping (_ msg:String)->()) {
        let musicsFilePath = shared.musicsInfoPath + "\(user)-musicsinfo.plist"
        
        if fileExistAtPath(musicsFilePath) {
            let fileUrl = URL(fileURLWithPath:musicsFilePath)

            do {
                try FileManager.default.removeItem(at: fileUrl)
                
                successed("#删除文件成功 - #")
            } catch let error {
                failed("#删除文件失败:错误代码 - #" + error.localizedDescription + "#")
            }
        } else {
            failed("#文件使用中,删除文件失败 - #")
        }
        
    }
    
    
    /// 更新文件
    ///
    /// - Parameters:
    ///   - user: <#user description#>
    ///   - successed: <#successed description#>
    ///   - failed: <#failed description#>
    class func updateMusicFile(_ user:String,successed:@escaping (_ list:[[String:String]],_ msg:String)->(),failed:@escaping (_ msg:String)->()) {
        let musicsDirPath = shared.musicsInfoPath
        let musicsFilePath = musicsDirPath + "/\(user)-musicsinfo.plist"
        let manger = FileManager.default
        
        do {
            try manger.createDirectory(atPath: musicsDirPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            failed("#创建目录失败:错误代码 - #" + error.localizedDescription + "#")
        }
        
//        if !fileExistAtPath(musicsFilePath) {
//            failed("#更新文件失败:错误代码 - #")
//            return
//        }

        var list:[[String:String]] = [[String:String]]()
        for song in shared.songList {
            list.append(song.dictionary())
        }
        
        NSArray(array: list).write(toFile: musicsFilePath, atomically: true)
        
        successed(list,"")
        shared.isUpdateList = false
    }
    
}

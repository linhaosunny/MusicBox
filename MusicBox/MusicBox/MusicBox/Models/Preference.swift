//
//  Preference.swift
//  MacroCaster
//
//  Created by sunshine.lee on 2018/9/14.
//  Copyright © 2018年 Bok Man. All rights reserved.
// 个人偏好配置存储

import UIKit

class Preference: NSObject {
    static let shared = Preference()

    var preference:PersionPreference?
    
    var isUpdate:Bool {
        get {
            return preference?.isUpdate ?? false
        }
    }
    
    fileprivate let documentPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    var preferencePath:String {
        get {
            return documentPath + "/musicPreference-list/"
        }
    }
    
    /// 获取用户歌曲列表
    ///
    /// - Parameter user: <#user description#>
    /// - Returns: <#return value description#>
    @discardableResult
    class func getPreference(_ user:String,song:Song?) -> PersionPreference? {
        let preferenceFilePath = shared.preferencePath + "\(user)-preference.plist"
        
        if let dict = NSDictionary(contentsOfFile: preferenceFilePath) as? [String:Any] {
            shared.preference = PersionPreference(dict)
            
        } else {
            
            let preference = PersionPreference()
            preference.songName = song?.title ?? ""
            preference.songArtist = song?.artist ?? ""
            preference.playUrl = song?.localUrl ?? (song?.serverUrl ?? "")
            preference.volume = 20
            
            shared.preference = preference
            updatePeferenceFile(user, successed: { (preference, msg) in
                
            }) { (msg) in
                
            }
        }
        
        return shared.preference
    }
    
    /// 更新文件
    ///
    /// - Parameters:
    ///   - user: <#user description#>
    ///   - successed: <#successed description#>
    ///   - failed: <#failed description#>
    class func updatePeferenceFile(_ user:String,successed:@escaping (_ preference:PersionPreference,_ msg:String)->(),failed:@escaping (_ msg:String)->()) {
         let preferenceFilePath = shared.preferencePath + "\(user)-preference.plist"
        let manger = FileManager.default
        
        do {
            try manger.createDirectory(atPath: shared.preferencePath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            failed("#创建目录失败:错误代码 - #" + error.localizedDescription + "#")
        }
        
        if let preference = shared.preference {
            let dict = preference.dictionary()
            NSDictionary.init(dictionary: dict).write(toFile: preferenceFilePath, atomically: true)
            
            successed(preference,"更新个人偏好设置成功")
            shared.preference?.isUpdate = false
        }
    }
    
}

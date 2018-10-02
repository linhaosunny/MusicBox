//
//  AlbumPictures.swift
//  MusicBox
//
//  Created by 李莎鑫 on 2018/10/2.
//  Copyright © 2018 李莎鑫. All rights reserved.
//  保存封面图

import UIKit

class AlbumPictures: NSObject {
    static let shared = AlbumPictures()
    
    fileprivate let documentPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    var albumPicturesPath:String {
        get {
            return documentPath + "/musicAlbumPicture-list/"
        }
    }
    
    /// 获取图片的实际路径
    ///
    /// - Parameter songName: <#songName description#>
    /// - Returns: <#return value description#>
    class func albumPicturesLocalPath(_ pictureName:String) -> String {
        return shared.albumPicturesPath + pictureName
    }
    
    /// 保存封面图
    ///
    /// - Parameter image: <#image description#>
    /// - Returns: <#return value description#>
    class func saveAlbumPicture(_ fileName:String?, image:UIImage?) -> String?{
        guard let albumImage = image, let name = fileName,let imageData = albumImage.jpegData(compressionQuality: 0.8) as NSData? else {
            return ""
        }
        
        let manger = FileManager.default
        try? manger.createDirectory(atPath: shared.albumPicturesPath, withIntermediateDirectories: true, attributes: nil)
        let fileName = name + ".jpg"
        let filePath = shared.albumPicturesPath + fileName
        
        imageData.write(toFile: filePath, atomically: true)
            
        return fileName
    }
}

//
//  UIConfig.swift
//  MacroCaster_ws
//
//  Created by sunshine.lee on 2017/12/8.
//  Copyright © 2017年 Bok Man. All rights reserved.
//

import Foundation
import UIKit


var isiPhoneXSeries: Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return UIApplication.shared.windows[0].safeAreaInsets.top == 44.0
}

/// 状态栏高度
let kStatusBarHeight = isiPhoneXSeries ? 44.0 : 20.0
/// 导航栏高度
let kNavigationBarHeight: CGFloat = 44.0

/// 顶部安全区距离
let kTopSafeOffset = UIApplication.shared.statusBarFrame.size.height > 20 ? (kStatusBarHeight - 20) :0
/// 底部安全区距离
let kBottomSafeOffset = isiPhoneXSeries ? 34.0 : 0

/// 导航栏加状态栏的高度
let kNavAndStatusBarHeight: CGFloat = CGFloat(kStatusBarHeight) + kNavigationBarHeight
/// tabBar加底部安全区域的高度
let kTabbarAndSafeOffsetHeight: CGFloat = CGFloat(kBottomSafeOffset + 49.0)


let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let ScreenScale = UIScreen.main.scale

let kShortScreenWidth = ScreenWidth > ScreenHeight ? ScreenHeight : ScreenWidth

let kQRcodePadViewHeight = 250 + kBottomSafeOffset


/// 直播相关配置
let liveTranspatColor = UIColor(white: 0.0, alpha: 0.2)
let homeTintColor = UIColor(red: 26.0/255.0, green: 205.0/255.0, blue: 103.0/255.0, alpha: 1.0)
let scalePixes = UIScreen.main.scale == 3.0 ? 1.0:0.78

// MARK:- 颜色相关
/// 背景底色配置
let kBackgroudColor = UIColor.colorWithHex(rgb: 0xf5f5f6)
let kLineColor = UIColor.colorWithHex(rgb: 0xeeeeee)
let kNavitaionBarItemColor = UIColor.white

let kCommonDynamicNumberLength = 4
let kCommonChinaPhoneLenght = 11
let kCommonStringLenght = 20

let appDelegate = (UIApplication.shared.delegate) as! AppDelegate



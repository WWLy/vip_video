//
//  YYDefine.swift
//  vip_video
//
//  Created by WWLy on 2019/12/16.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit

/*** 宽高 ***/
let SCREEN_BOUNDS       = UIScreen.main.bounds
let SCREEN_WIDTH        = SCREEN_BOUNDS.width
let SCREEN_HEIGHT       = SCREEN_BOUNDS.height

let SCREEN_HEIGHT_SCALE = SCREEN_HEIGHT / 667.0
let SCREEN_WIDTH_SCALE  = SCREEN_WIDTH  / 375.0

let isiPhoneX = ((max(SCREEN_WIDTH, SCREEN_HEIGHT) == 896) || (max(SCREEN_WIDTH, SCREEN_HEIGHT) == 812))

/// iphoneX 顶部圆角高度 (实际是34)
let CYFringeTopHeight: CGFloat       = (isiPhoneX ? 34.0 : 0.0)
/// iphoneX 导航栏高度
let CYSafeAreaTopHeight: CGFloat     = (isiPhoneX ? 88.0 : 64.0)
/// iphoneX 底部圆角高度 (实际是34)
let CYSafeAreaBottomHeight: CGFloat  = (isiPhoneX ? 30.0 : 0.0)


/*** 颜色 ***/

func CYColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

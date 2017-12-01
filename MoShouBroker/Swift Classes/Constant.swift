//
//  Constant.swift
//  MoShou2
//  swift中用到的常量和函数
//  Created by NiLaisong on 2017/10/24.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import UIKit

let kAppVersion  =   LocalFileSystem.sharedManager().versionName

let kVersionCode  =  LocalFileSystem.sharedManager().versionCode

let kIosVersion = UIDevice.current.systemVersion

let kAppBundleId = Bundle.main.bundleIdentifier

let kDeviceId = Tool.getDeviceId()

let kDeviceName = Tool.getDeviceName()



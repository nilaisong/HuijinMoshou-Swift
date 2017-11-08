//
//  PageData.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import HandyJSON
//从swift3.0升级到4.0时，需要暴露给OC代码的方法和属性必须添加@objc关键字说明
class PageModel:NSObject,HandyJSON
{
    @objc var pageNo: NSNumber = NSNumber.init(value: 0)
    @objc var pageSize: NSNumber = NSNumber.init(value: 0)
    @objc var totalCount: NSNumber = NSNumber.init(value: 0)
    @objc var pageCount: NSNumber = NSNumber.init(value: 0)
    
    @objc var morePage:Bool
    {
        if (self.pageNo.intValue<self.pageCount.intValue) {
            return true;
        }
        return false;
    }
    
    required override init()
    {
        super.init()
    }
}

//
//  PageData.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

class PageModel:NSObject,HandyJSON
{
    var pageNo: NSNumber = NSNumber.init(value: 0)
    var pageSize: NSNumber = NSNumber.init(value: 0)
    var totalCount: NSNumber = NSNumber.init(value: 0)
    var pageCount: NSNumber = NSNumber.init(value: 0)
    
    var morePage:Bool
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

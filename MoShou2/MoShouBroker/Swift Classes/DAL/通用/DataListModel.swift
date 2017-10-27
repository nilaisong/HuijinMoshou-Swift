//
//  DataListModel.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

class DataListModel:NSObject,HandyJSON
{
    var dataArray: Any?//数据列表
    var morePage :Bool = false//是否有下一页数据
    var totalCount :Int = 0//数据条目总数
    
    required override init()
    {
        super.init()
    }
}

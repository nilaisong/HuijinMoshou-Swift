//
//  PointsData.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import HandyJSON

class PointsModel:NSObject,HandyJSON
{
    @objc var ruleName: String = ""//积分规则名称
    @objc var point: String = ""//积分
    @objc var ruleOpt: String = ""//符号 + 为增加了积分 -为减少了积分
    @objc var title: String = ""//标题名称
    @objc var operationTime: String = ""//积分时间
    
    required override init()
    {
        super.init()
    }
}

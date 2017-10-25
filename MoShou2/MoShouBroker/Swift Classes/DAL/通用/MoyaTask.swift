//
//  MoyaTask.swift
//  MoShou2
//  封装数据接口请求任务枚举类型，携带参数
//  Created by NiLaisong on 2017/10/25.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
//扩展枚举类型
extension Task
{
    //增加个静态方法，返回相关值带请求参数的枚举值
    static func postParameters(params:[String: Any]) -> Task {
        return .requestParameters(parameters:params, encoding: URLEncoding.httpBody)
    }
}


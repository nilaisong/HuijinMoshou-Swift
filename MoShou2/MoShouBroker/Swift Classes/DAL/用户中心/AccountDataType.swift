//
//  AccountService_APIEnum.swift
//  MoShou2
//  提供用户相关的登录、注册、修改密码和个人信息等业务接口类型
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

//原始值可以是字符串，字符，或者任何整型值或浮点型值。每个原始值在它的枚举声明中必须是唯一的
//其他类型可以被枚举继承
enum AccountDataType {
    case pointsList(pageIndex:String,pageSize:String)//用户积分列表

}
//通过继承协议来扩展枚举类型，实现继承下来的属性和方法
extension AccountDataType:TargetType
{
    //根据自身枚举类型设置对应数据接口path属性
    var path: String {
        switch self {
        case .pointsList(_, _):
            return "/api/agency/goods/getDetailList"
        }
    }
    //根据自身枚举类型设置对应数据接口任务功能和请求参数
    var task: Task {
        switch self{
        case .pointsList(let pageIndex,let pageSize)://使用let从枚举里取出相关值
                return .postParameters(["pageNo": pageIndex, "pageSize": pageSize])
        default:
            break
        }
    }
}


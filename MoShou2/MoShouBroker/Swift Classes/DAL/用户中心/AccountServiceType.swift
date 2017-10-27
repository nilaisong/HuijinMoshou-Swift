//
//  AccountService_APIEnum.swift
//  MoShou2
//  提供用户相关的业务接口类型
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

//原始值可以是字符串，字符，或者任何整型值或浮点型值。每个原始值在它的枚举声明中必须是唯一的
//其他类型可以被枚举继承
enum AccountServiceType {
    case login(mobile: String,passWord: String)//登录
    case userInfo//获取用户信息
    case logout//退出
}

extension AccountServiceType:TargetType
{
    var path: String {
        switch self {
        case .login(_, _):
            return "/dologin"
        case .userInfo:
            return "/userinfo"
        case .logout:
            return "/logout"
        }
    }
    
    var task: Task {
        switch self
        {
            case .login(let mobile, let passWord):
                Tool.removeCache("user_token")//清除token
                return .postParameters(params:["principal": mobile, "password": passWord,"validepassword":"1"])
            case .userInfo:
            return .requestPlain
            case .logout:
                return .requestPlain
        }
    }
}

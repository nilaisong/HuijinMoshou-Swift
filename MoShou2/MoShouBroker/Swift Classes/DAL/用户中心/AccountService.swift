//
//  AccountService_APIEnum.swift
//  MoShou2
//  提供用户相关的业务逻辑
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

enum AccountService {
    case login(mobile: String,passWord: String)//登录
    case logout//退出
    
}

extension AccountService:TargetType
{
    var path: String {
        switch self {
        case .login(_, _):
            return "/dologin"
        case .logout:
            return "/logout"
        }
    }
    
    var task: Task {
        switch self
        {
            case .login(let mobile, let passWord):
                return .postParameters(params:["principal": mobile, "password": passWord,"validepassword":"1"])
            case .logout:
                return .requestPlain
        }
    }
}

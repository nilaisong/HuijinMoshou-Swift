//
//  AccountServiceProvider.swift
//  MoShou2
//  提供用户相关的业务逻辑处理接口
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

class AccountServiceProvider:NSObject
{
    static let sharedInstance = AccountServiceProvider()
    
    private  let provider = MoyaProvider<AccountService>()
    
    override init()
    {
        
    }
    //@escaping，用以标记“逃逸闭包”（函数执行完还没被调用的闭包-在网络请求的异步处理响应结果中用到
     func login(mobile:String,password:String,completionClosure:@escaping RequestCompletionClosure)
    {
        provider.request(.login(mobile: mobile, passWord: password))
        { result in
            let resResult = getResultModel(result: result);
            let data:[String:Any] = resResult.data as![String:Any]
            Tool.setCache("user_account", value: mobile)
            let token = data["token"]
            Tool.setCache("user_token",value:token);
            completionClosure(resResult)
        }
        
    }
}

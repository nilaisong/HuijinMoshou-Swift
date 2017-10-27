//
//  AccountServiceProvider.swift
//  MoShou2
//  提供用户相关的业务接口处理服务
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
//import BaiduMapAPI_Base

class AccountServiceProvider:NSObject
{
    static let sharedInstance = AccountServiceProvider()
    
    private  let provider = MoyaProvider<AccountServiceType>()
    
    override init()
    {
        
    }
    //@escaping，用以标记“逃逸闭包”（函数执行完还没被调用的闭包-在网络请求的异步处理响应结果中用到
     func login(mobile:String,password:String,completionClosure:@escaping RequestCompletionClosure)
    {
        provider.request(.login(mobile: mobile, passWord: password))
        { result in
            let resResult = getResultModel(result: result);
            if resResult.success{
                let data:[String:Any] = resResult.data as![String:Any]
                Tool.setCache("user_account", value: mobile)
                
                let b = data.keys.contains("passwordLegal")
                var isLegal:Bool = true
                if b
                {
                    isLegal = data["passwordLegal"] as! Bool
                }
                //如果这个字段存在并且是false，则说明密码过于简单
                if b && !isLegal
                {
                    resResult.success = false;
                    resResult.code = "-100"//密码太简单，需要修改
                    completionClosure(resResult)
                }
                else
                {
                    resResult.success = true
                    let token = data["token"]
                    Tool.setCache("user_token",value:token);
                    self.getUserInfo(completionClosure);
                }
            }
            else{
                completionClosure(resResult)
            }
        }
    }
    //不专门指定的话，默认内部参数名就是外部参数名，“_”表示第一个外部参数名可省略
    func getUserInfo(_ completionClosure:@escaping RequestCompletionClosure)
    {
        provider.request(.userInfo)
        { result in
            let resResult = getResultModel(result: result);
            if resResult.success
            {
                let data: [String:Any] = resResult.data as! [String:Any]
                let user: [String:Any] = data["user"] as! [String:Any]
                if let userInfo: UserInfo = JSONDeserializer<UserInfo>.deserializeFrom(dict:user)
                {
                    userInfo.initialize()
                    print("\(userInfo.userName),\(userInfo.storeNum)")
                    resResult.data = userInfo;
                }
            }
            completionClosure(resResult)
        }
        
    }
    
    func logout(_ completionClosure:@escaping RequestCompletionClosure)
    {
        provider.request(.logout)
        { result in
            let resResult = getResultModel(result: result);
            if resResult.success
            {
                Tool.removeCache("user_token")
            }
            completionClosure(resResult)
        }
    }
    
    func updateAvatar(_ avatar:UIImage,completionClosure:@escaping RequestCompletionClosure)
    {
        provider.request(.updateAvatar(avatar))
        { result in
            let resResult = getResultModel(result: result);
            if let dic = resResult.data as? [String:AnyObject]
            {
                let avatarUrl = dic["headpicUrl"]
                resResult.data = avatarUrl
            }
            completionClosure(resResult)
        }
    }
    
    //只有可选类型赋值为nil
    func submitFeedback(content:String,imgArray:[UIImage]? = nil,completionClosure:@escaping RequestCompletionClosure)
    {
        var images:[UIImage]
        if imgArray != nil
        {
            images = imgArray!
        }
        else
        {
            images = []
        }
        provider.request(.submitFeedback(content:content,imgArray:images))
        { result in
            let resResult = getResultModel(result: result);
            completionClosure(resResult)
        }
    }
}

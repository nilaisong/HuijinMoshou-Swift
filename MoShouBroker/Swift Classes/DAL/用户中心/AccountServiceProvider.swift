//
//  AccountServiceProvider.swift
//  MoShou2
//  提供用户相关的业务接口处理服务
//  Created by NiLaisong on 2017/10/23.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
import RxSwift

class AccountServiceProvider:NSObject
{
    @objc static let sharedInstance = AccountServiceProvider()
    
    private  let provider = MoyaProvider<AccountServiceType>()
    
    override init()
    {
        
    }
    //@escaping，用以标记“逃逸闭包”（函数执行完还没被调用的闭包-在网络请求的异步处理响应结果中用到
     @objc func login(mobile:String,password:String,completionClosure:@escaping RequestCompletionClosure)
    {
        if NetworkStatus.shareInstance.isConnected
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
                        Tool.setCache("user_token",value:token)
                        
                        self.getUserInfo{ (resResult) in
                            completionClosure(resResult)
                        }
                    }
                }
                else{
                    completionClosure(resResult)
                }
            }
        }
    }
    //不专门指定的话，默认内部参数名就是外部参数名，“_”表示第一个外部参数名可省略
    @objc func getUserInfo(_ completionClosure:@escaping RequestCompletionClosure)
    {
        let subject = self.getUserInfo()
        
        let  _ = subject.subscribe(onNext: { (resResult) in
            completionClosure(resResult)
            print("getUserInfo complete")
        })
//        disposable.dispose()//释放掉，就不会再执行订阅的事件了
    }
    //
    func getUserInfo()->PublishSubject<ResponseResult>
    {
        let subject = provider.rxRequest(.userInfo)
        { result -> ResponseResult in
            let resResult = getResultModel(result: result);
            if resResult.success
            {
                let data: [String:Any] = resResult.data as! [String:Any]
                let user: [String:Any] = data["user"] as! [String:Any]
                if let userInfo: UserInfo = JSONDeserializer<UserInfo>.deserializeFrom(dict:user)
                {
                    userInfo.initialize()
                    if let userDic = userInfo.toJSON()
                    {
                        print(userDic)
                    }
//                        print("\(userInfo.userName),\(userInfo.storeNum)")
                    resResult.data = userInfo;
                }
            }
           return resResult //返回解析后的数据模型
        }
        return subject //返回带数据的可订阅对象
    }
    
    @objc func logout(_ completionClosure:@escaping RequestCompletionClosure)
    {
        if NetworkStatus.shareInstance.isConnected
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
    }
    
    @objc func updateAvatar(_ avatar:UIImage,completionClosure:@escaping RequestCompletionClosure)
    {
        if NetworkStatus.shareInstance.isConnected
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
    }
    
    //只有可选类型才能赋值为nil，表示该参数可省略
    @objc func submitFeedback(content:String,imgArray:[UIImage]? = nil,completionClosure:@escaping RequestCompletionClosure)
    {
        if NetworkStatus.shareInstance.isConnected
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
}

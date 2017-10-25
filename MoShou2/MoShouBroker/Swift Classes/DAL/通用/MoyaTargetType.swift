//
//  MoyaTargetType.swift
//  MoShou2
//  设置网络请求相关的一些共用参数
//  Created by NiLaisong on 2017/10/25.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
//通过扩展协议，实现一些属性和方法可供继承者直接调用
extension TargetType {
    
    var method: Method {
            return .post
    }
    // The headers to be used in the request.
    //字典类型
    var headers: [String: String]?
    {
        var dic:[String: String] = ["deviceSource":"2","loginEntry": "1","osVersion":kIosVersion,"appVersion":kAppVersion!,"deviceName":kDeviceName!,"deviceId":kDeviceId!,"appBundleId":kAppBundleId!]
        
//        dic.updateValue(, forKey: )//增加和修改
//        dic.removeValue(forKey: ) //移除
        let userToken = Tool.getCache("user_token")
        //if let语法支持可选类型解包，as!强制类型转换不会返回可选类型
        if let token = userToken as? String
        {
            dic["token"] = token //增、删、改都支持
        }
        else
        {
            dic["token"] = nil;//删除
        }
        return dic
    }
    
    var baseURL: URL {
        
        return URL(string: kBaseUrl)!
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
}

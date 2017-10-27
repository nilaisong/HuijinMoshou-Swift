//
//  MoyaCommon.swift
//  MoShou2
//  数据请求相关的通用类型、常量和方法
//  Created by NiLaisong on 2017/10/25.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

//可选参数可以省略
func uniquePicName(_ name:String?=nil,typeName:String?=nil) -> String {
    let date:Date = Date.init(timeIntervalSinceNow: 0);
    let a:TimeInterval = date.timeIntervalSince1970 * 1000;
    var picFullName:String = "" //var和let初始化变量和常量
    if let picName = name
    {
        if let type = typeName
        {
            picFullName = "\(picName)\(a).\(type)"
        }
        else
        {
            picFullName = "\(picName)\(a).jpg"
        }
    }
    else
    {
        if let type = typeName
        {
            picFullName = "\(a).\(type)"
        }
        else
        {
            picFullName = "\(a).jpg"
        }
    }
    return picFullName
}

typealias RequestCompletionClosure = (_ result:ResponseResult) -> Void

func getResultModel(result:Result<Response, MoyaError>)->ResponseResult
{
    var resResult:ResponseResult =  ResponseResult()
    
    switch result {
    case let .success(response):
        let jsonString : String = NSString(data:response.data,encoding:String.Encoding.utf8.rawValue)! as String
        //可以解析json串、数据字典，也可以指定解析的节点路径
        if let optResult = JSONDeserializer<ResponseResult>.deserializeFrom(json: jsonString)
        {
            resResult = optResult
        }
        else
        {
            resResult.success = false
            resResult.message = "数据解析异常"
            resResult.code = ""
        }
        break
    case let .failure(error):
//        resResult = ResponseResult()
        resResult.success = false
        resResult.message = "服务器未知异常"
        resResult.code = ""
        print(error.errorDescription!);
        break
    }
    return resResult
}

//
//  MoyaCommon.swift
//  MoShou2
//  数据请求相关的通用类型、常量和方法
//  Created by NiLaisong on 2017/10/25.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import Moya
import Result
import HandyJSON

let kPageSize = "20"//一页数据大小
//定义请求结束后回调用的闭包类型
typealias RequestCompletionClosure = (_ result:ResponseResult) -> Void

//可选类型的参数，如果给予nil默认值则调用时可省略
//函数的参数名也默认为外部参数名，但可以明确指定外部参数名或明确省略外部参数名
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
//定义一个函数，初步解析和封装数据接口请求返回结果，参数result是一个范型类型的参数（使用泛型时要指明尖括号中的泛型参数）
func getResultModel(result:Result<Response, MoyaError>)->ResponseResult
{
    var resResult:ResponseResult =  ResponseResult()
    
    switch result {
    case let .success(response):
        //把Data转化为字符串-用data构造字符串对象
        let jsonString : String = String.init(data: response.data, encoding:String.Encoding.utf8)!
//        NSString(data:response.data,encoding:String.Encoding.utf8.rawValue)! as String
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

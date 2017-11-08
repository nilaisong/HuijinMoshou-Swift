//
//  CommonServiceType.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/11/1.
//  Copyright © 2017年 5i5j. All rights reserved.
//
/*
访问控制权限说明：private只能类型内和文件内访问，internal仅能模块内访问和使用；
 public可以被其他模块访问但不能被被继承和重写，而open则可以；枚举和结构体由于不能
 被继承则不需要open权限；public协议能被其他模块继承实现而不需要open权限
 */
import Foundation

import Alamofire
import Moya
import RxSwift


enum CommonServiceType {
    case downloadFile(urlString:String,savePath:String)

}
//public修饰的类型，在引入他们的模块中不能被继承；public修饰的方法和属性不能在引入他们的模块中的子类重写
//而open修饰的类型、方法和属性，在引入他们的模块中可以被继承以及重写
extension CommonServiceType:TargetType {
    //重写扩展协议里的method属性
    var method: Moya.Method {
        switch self
        {
        case .downloadFile(_,_):
            return .get
        default:
            break
        }
    }
    //重写扩展协议里的baseURL属性
    var baseURL: URL {
        switch self
        {
        case .downloadFile(let urlString,_):
            var baseUrlStr:String
           
            if let lastIndex = urlString.lastIndexOf(Character.init("/"))
            {
                baseUrlStr = urlString.substring(to: lastIndex)//不包括该索引
            }
            else
            {
                baseUrlStr = "http://"
            }
            return URL.init(string: baseUrlStr)!
        }
    }

    //请求数据接口子路径
    var path:String{
        switch self {
        case .downloadFile(let urlString,_):
            var subUrlStr:String
            if let lastIndex = urlString.lastIndexOf(Character.init("/"))
            {
                subUrlStr = urlString.substring(from: lastIndex)//包括该索引
            }
            else
            {
                subUrlStr = ""
            }
            return subUrlStr;
        }
    }
    
   mutating func changeBaseURL()  {
//        self.baseURL = URL("")
    }
    
    //请求任务类型和参数
    var task:Task{
        switch self {
        case .downloadFile(_,let savePath):
            //定义和创建一个闭包对象，用以返回下载文件保存路径；（闭包就是把参数和返回类型移到大括号里的匿名函数）
            let d:DownloadDestination = {(temporaryURL:URL,response: HTTPURLResponse) -> (URL,DownloadRequest.DownloadOptions) in
                print("\(response.statusCode),\(response.suggestedFilename!)")
                print(response.url!.absoluteString)
                let  savePathUrl = URL.init(fileURLWithPath: savePath)
                return (savePathUrl,DownloadRequest.DownloadOptions.removePreviousFile)
            }
            return .downloadDestination(d)
        }
    }
}

//
//  BaseMoyaProvider.swift
//  MoShou2
//
//  Created by NiLaisong on 2017/10/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import Moya

class CommonProvider:NSObject
{
    static let sharedInstance = CommonProvider()
    
    let provider = MoyaProvider<CommonServiceType>()
    
    override init()
    {
        
    }
    
    func downloadFile(urlString:String,savePath:String,completionClosure:@escaping RequestCompletionClosure){
        provider.request(.downloadFile(urlString: urlString, savePath: savePath)) {result in
            let resResult:ResponseResult =  ResponseResult()
            switch result {
            case  .success(_):
                resResult.success = true
            case  .failure(let error):
                resResult.success = false
                //判断并同时解包可选对象，等同于先判断是否为空再通过！解包数据
                if let errorMsg = error.errorDescription
                {
                    resResult.message = errorMsg
                }
            }
            completionClosure(resResult)//调用和执行闭包
        }
    }
}


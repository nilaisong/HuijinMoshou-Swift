//
//  AccountDataProvider.swift
//  MoShou2
//  提供用户相关数据的业务接口处理服务
//  Created by NiLaisong on 2017/10/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

class AccountDataProvider:NSObject
{
    @objc static let sharedInstance = AccountDataProvider()
    
    private  let provider = MoyaProvider<AccountDataType>()
    
    override init()
    {
        
    }
    //
    @objc func getPointsList(pageIndex:String,completionClosure:@escaping RequestCompletionClosure)
    {
        provider.request(.pointsList(pageIndex: pageIndex, pageSize: kPageSize))
        { result in
            let resResult = getResultModel(result: result);
            if resResult.success{
            
                if let data:[Any] = resResult.data as? [Any]
                {
                    if let dataArray = JSONDeserializer<PointsModel>.deserializeModelArrayFrom(array:data)
                    {
                        resResult.data = dataArray
                    }
                }
            }
            completionClosure(resResult)
        }
    }
}

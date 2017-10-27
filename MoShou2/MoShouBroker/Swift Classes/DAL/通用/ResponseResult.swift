//
//  ResponseResult.swift
//  MoShou2
//  数据请求返回的数据结构
//  Created by NiLaisong on 2017/10/24.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

//@objc(ResponseResult) //继承自OC的类或被@objc标记的类才能被OC代码调用
class ResponseResult:NSObject,HandyJSON
{
    var success:Bool = false
    var code:String=""
    var message:String=""
    var data:AnyObject?
    
    required override init()
    {
        super.init()
    }
    //字段映射
    func mapping(mapper: HelpingMapper) {
        // 指定 message 字段用 "msg" 去解析
        mapper.specify(property: &message, name: "msg")
        
//        // 指定 parent 字段用这个方法去解析
//        mapper.specify(property: &parent) { (rawString) -> (String, String) in
//            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
//            return (parentNames[0], parentNames[1])
//        }
    }
 
}

//
//  ResponseResult.swift
//  MoShou2
//  数据请求返回的数据结构
//  Created by NiLaisong on 2017/10/24.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
import HandyJSON
 //继承自OC框架里的类或被@objc标记的类才能被OC代码调用
class ResponseResult:NSObject,HandyJSON
{
    @objc var success:Bool = false
    @objc var code:String=""//常用以标示失败类型
    @objc var message:String=""
    
    @objc var data:Any?//返回的主体数据
    
    @objc var page:PageModel?//如果是列表数据，则有页码
    //实现协议的构造函数时，要加上required关键字
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

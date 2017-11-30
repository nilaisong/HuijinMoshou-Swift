//
//  User.swift
//  MoShou2
//  用户表对应的类-嵌套类
//  Created by NiLaisong on 2017/11/30.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation
/*
 看上面的实体类定义可以发现，我们并没有指定这个用户类对应的数据表的名字。其实 SQLTable 内部已经帮我们做了，将类名变成小写并在尾部添加 s 便是对应的表名。（如果是 y 结尾的则去掉 y，加 ies）
 比如：User 类对应的表是 users，SweetCandy 对应的表是 sweetcandies。
 原文出自：www.hangge.com  转载请保留原文链接：http://www.hangge.com/blog/cache/detail_953.html
 */
class User:SQLTable {
    var uid = -1
    var uname  = ""
    var mobile = ""
    
    //设置主键（如果主键字段名就是id的话，这个可以省去,不用覆盖）
    override func primaryKey() -> String {
        return "uid";
    }
    
    required convenience init(tableName:String) {
        self.init()
    }
}

//
//  SQLiteDB.swift
//  MoShou2
//  初始化SQLite数据库并创建用到的表
//  原文链接：http://www.hangge.com/blog/cache/detail_953.html
//  Created by NiLaisong on 2017/11/30.
//  Copyright © 2017年 5i5j. All rights reserved.
//

import Foundation

@objcMembers
class SQLiteDBMgr: NSObject {

    static let shared = SQLiteDBMgr()
    //获取数据库实例
    private let db = SQLiteDB.shared
    
    override init()
    {
        //打开数据库
        let b = db.openDB(copyFile:true)
        if b {
        //如果表还不存在则创建表
        _ = db.execute(sql: "create table if not exists users(uid integer primary key,uname varchar(20),mobile varchar(20))")
        }
    }
    //测试示例
    func test()  {
        //插入三条数据
        print("------ 开始插入数据 ------")
        let user1 = User()
        user1.uname = "张三"
        user1.mobile = "123"
        if user1.save() > 0 {
            print("数据插入成功")
        }
        
        let user2 = User()
        user2.uname = "李四"
        user2.mobile = "456"
        if user2.save() > 0 {
            print("数据插入成功")
        }
        
        let user3 = User()
        user3.uname = "王五"
        user3.mobile = "110"
        if user3.save() > 0 {
            print("数据插入成功")
        }
        
        //查询出所有的用户（order条件:按id排序）
        print("\n------ 开始查询所有数据 ------")
        let data = User.rows(order:"uid ASC") as! [User]
        for item in data {
            print("\(item.uid)：\(item.uname)：\(item.mobile)")
        }
        
        //修改数据
        print("\n------ 修改第二条数据 ------")
        data[1].mobile = "hangge.com"
        if data[1].save() > 0  {
            print("数据修改成功")
        }
        
        //再次查询出所有的用户（order条件:按id排序）
        print("\n------ 再次查询所有数据 ------")
        let data2 = User.rows(order:"uid ASC") as! [User]
        for item in data2 {
            print("\(item.uid)：\(item.uname)：\(item.mobile)")
        }
        
        //查询出前两条数据（limit条件）
        print("\n------ 查询出前两条数据 ------")
        let data3 = User.rows(limit: 2) as! [User]
        for item in data3 {
            print("\(item.uid)：\(item.uname)：\(item.mobile)")
        }
        //查询出电话以1开头的所有用户(filter条件)
        print("\n------ 查询出电话以1开头的所有用户 ------")
        let data4 = User.rows(filter:"mobile like '1%'") as! [User]
        for item in data4 {
            print("\(item.uid)：\(item.uname)：\(item.mobile)")
        }
        
        //多条件（filter,order,limit）
        print("\n------ 查询出电话以1开头的第一个用户 ------")
        let data5 = User.rows(filter:"mobile like '1%'", order:"uid ASC", limit:1) as! [User]
        for item in data5 {
            print("\(item.uid)：\(item.uname)：\(item.mobile)")
        }
    }
}

//
//  ActionResult.h
//  MoShouBroker
//  用户操作返回结果数据结构
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageData.h"
@interface ActionResult : NSObject

//接口错误编码，字符串格式，0为正常，负数为错误，-1000未登录
@property (nonatomic,assign)int code;
@property (nonatomic,copy)NSString *message;//提示信息
//@property (nonatomic,assign)BOOL isLogin;//是否登录
@property (nonatomic,assign)BOOL success;//操作是否成功
//可以把page.morePage赋值给其他数据模型中的morePage，从而判断是否有下一页数据
@property (nonatomic,strong) PageData* page;

@end

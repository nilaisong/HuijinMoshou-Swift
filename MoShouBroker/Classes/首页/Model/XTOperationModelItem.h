//
//  XTOperationModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//  运营数据模型

#import <Foundation/Foundation.h>



@interface XTOperationModelItem : NSObject



/**
 *  跳转链接
 */
@property (nonatomic,copy)NSString* skipUrl;

/**
 *  是否跳转链接 1：未跳转 2：跳转
 */
@property (nonatomic,assign)NSInteger isSkipUrl;

/**
 *  链接地址,如果有值，使用这个
 */
@property (nonatomic,copy)NSString* contentUrl;

/**
 *  图片地址
 */
@property (nonatomic,copy)NSString* imgUrl;

/**
 *  资讯ID
 */
@property (nonatomic,copy)NSString* ID;

/**
 *  资讯标题
 */
@property (nonatomic,copy)NSString* title;

/**
 *  更新时间
 */
@property (nonatomic,copy)NSString* updateTime;

/**
 *  资讯标识
 */
@property (nonatomic,copy)NSString* type;

@end

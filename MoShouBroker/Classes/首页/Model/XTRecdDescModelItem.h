//
//  XTRecdDescModelItem.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/29.
//  Copyright © 2016年 5i5j. All rights reserved.
// 推荐详情 详情 desc

#import <Foundation/Foundation.h>

@interface XTRecdDescModelItem : NSObject

/**
 *  当前资讯id
 */
@property (nonatomic,copy)NSString* ID;

/**
 *  标题
 */
@property (nonatomic,copy)NSString* title;

/**
 *  城市
 */
@property (nonatomic,copy)NSString* city;

/**
 *  图片
 */
@property (nonatomic,copy)NSString* imageUrl;

/**
 *  状态1上线
 */
@property (nonatomic,copy)NSString* status;

/**
 *  上线时间
 */
@property (nonatomic,copy)NSString* onlineTime;

/**
 *  浏览人数
 */
@property (nonatomic,copy)NSString* pv;

/**
 *  浏览次数
 */
@property (nonatomic,copy)NSString* uv;

@property (nonatomic,copy)NSString* isAdmin;

@property (nonatomic,copy)NSString* creator;

@property (nonatomic,copy)NSString* createTime;

@property (nonatomic,copy)NSString* updater;

/**
 *  资讯创建时间
 */
@property (nonatomic,copy)NSString* updateTime;

/**
 *  资讯更新时间
 */
@property (nonatomic,copy)NSString* delFlag;

/**
 *  资讯内容
 */
@property (nonatomic,copy)NSString* content;
/**
 *  资讯内容无标签
 */
@property (nonatomic,copy)NSString* contentNotag;
@end

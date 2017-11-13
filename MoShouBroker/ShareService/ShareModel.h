//
//  ShareDataModel.h
//  TuluAuction
//
//  Created by haoxiangfeng on 15-3-30.
//  Copyright (c) 2015年 artron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic,copy) NSString *buildingId;//楼盘id，分享完成后回调用
@property (nonatomic,assign)BOOL isShareImage;//是否是分享图片
@property (nonatomic,copy)  NSString *title;//标题（QQ空间、QQ、微信、朋友圈）
@property (nonatomic, copy) NSString *linkUrl;//分享链接wap页（QQ空间、QQ、微信、朋友圈）
@property (nonatomic,copy)  NSString *content;//分享信息（QQ好友、微信好友）
@property (nonatomic, copy) NSString *img;//分享缩略图名称或url地址
@property (nonatomic, assign) BOOL *isShareApp;//分享缩略图名称或url地址

//@property (nonatomic, strong) NSString *weiboInfo;//微博分享信息(新浪、腾讯微博)

@end

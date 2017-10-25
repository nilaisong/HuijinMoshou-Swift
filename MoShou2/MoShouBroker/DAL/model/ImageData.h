//
//  ImageData.h
//  MoShouBroker
//  网络图片数据结构
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageData : NSObject

@property(nonatomic,copy) NSString* logoUrl;//缩略图地址
@property(nonatomic,copy) NSString* hdUrl;//高清图地址

@end

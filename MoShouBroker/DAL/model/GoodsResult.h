//
//  GoodsResult.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsResult : NSObject

@property (nonatomic,strong) NSArray *adArray;//顶部广告数组，元素Ad

@property (nonatomic,strong) NSArray *dataArray;//商品数据列表
@property (nonatomic,assign) BOOL morePage; //是否有下页数据

@end

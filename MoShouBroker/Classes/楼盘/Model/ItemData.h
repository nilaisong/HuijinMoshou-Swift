//
//  ItemData.h
//  MoShou2
//
//  Created by strongcoder on 16/5/5.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemData : NSObject

@property (nonatomic,copy)NSString *itemID;   //ID
@property (nonatomic,copy)NSString *itemName;   //名称

@property (nonatomic,strong)NSArray *platLists;   //数组  ItemData里面也是这个

/**
 经度
 */
@property (nonatomic,copy)NSString* longitude;

/**
 纬度
 */
@property (nonatomic,copy)NSString* latitude;

@end

//
//  PageData.h
//  MoShou2
//
//  Created by NiLaisong on 16/4/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageData : NSObject

@property(nonatomic,strong) NSNumber* pageNo;
@property(nonatomic,strong) NSNumber* pageSize;
@property(nonatomic,strong) NSNumber* totalCount;   //共有多少个楼盘的数量  
@property(nonatomic,strong) NSNumber* pageCount;

@property(nonatomic,assign) BOOL morePage;

@end

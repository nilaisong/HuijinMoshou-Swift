//
//  LookRanking.h
//  MoShou2
//
//  Created by xiaotei's on 15/12/19.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LookRanking : NSObject

@property (nonatomic,assign)NSInteger rownum;
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,copy)NSString* userName;
@property (nonatomic,copy)NSString* shopName;
@property (nonatomic,assign)NSInteger guideNum;//带看数
@property (nonatomic,copy)NSString* headPic;
@property (nonatomic,copy)NSString* startDate;
@property (nonatomic,copy)NSString* endDate;//
@end

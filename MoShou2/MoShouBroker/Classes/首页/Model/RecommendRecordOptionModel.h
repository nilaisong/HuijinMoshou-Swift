//
//  RecommendRecordOptionModel.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/25.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendRecordOptionModel : NSObject

//标签名字
@property (nonatomic,copy)NSString* title;

//标签数量
@property (nonatomic,assign)NSInteger dataNumber;


@property (nonatomic,assign)NSInteger groupId;
@end

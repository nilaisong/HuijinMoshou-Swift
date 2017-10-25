//
//  RecommendRecordController.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/23.
//  Copyright © 2015年 5i5j. All rights reserved.
//
//报备记录


#import "BaseViewController.h"

@interface RecommendRecordController : BaseViewController


//设置可当前标题
@property (nonatomic,copy)NSString* customTitle;

//设置当前的item index
@property (nonatomic,assign)NSInteger currentIndex;
@end

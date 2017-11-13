//
//  NetworkRequestFailed.h
//  MoShouBroker
//
//  Created by caotianyuan on 15/8/24.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReloadDataBlock)();

@interface NetworkRequestFailed : UIView

@property (atomic,strong) ReloadDataBlock reloadData ;
//根据热点调整视图显示尺寸
-(void)adjustFrameForHotSpotChange;
@end

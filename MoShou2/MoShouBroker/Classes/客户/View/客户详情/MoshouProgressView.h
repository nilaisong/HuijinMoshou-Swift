//
//  MoshouProgressView.h
//  MoShouBroker
//
//  Created by wangzz on 15/6/24.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressStatus.h"

@interface MoshouProgressView : UIView

@property (nonatomic, strong) ProgressStatus   *progressDataSource;
//@property (nonatomic, strong) NSArray   *contentArray;

@end

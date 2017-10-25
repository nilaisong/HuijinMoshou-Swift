//
//  XTCollectBuildingNoResultView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCollectBuildingNoResultView.h"

@interface XTCollectBuildingNoResultView()

@property (nonatomic,weak)UILabel* noResultLabel;

@end

@implementation XTCollectBuildingNoResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"暂无收藏数据";
        [self addSubview:label];
        _noResultLabel = label;
    }
    return self;
}

- (void)layoutSubviews{
    _noResultLabel.center = self.center;
}

@end

//
//  XTMineRankingInfoView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTMineRankingInfoView.h"

@interface XTMineRankingInfoView()

@end

@implementation XTMineRankingInfoView

+ (instancetype)mineRankingInfoView{
    NSString* className = NSStringFromClass([self class]);
    
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil]lastObject];
}

- (void)awakeFromNib{
    _myHeadPic.clipsToBounds = YES;
    _myHeadPic.layer.cornerRadius = _myHeadPic.frame.size.width / 2.0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    _currentRankingLabel.center = CGPointMake(self.center.x, 32);
}

@end

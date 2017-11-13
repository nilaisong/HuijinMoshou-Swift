//
//  CustomerShowVisitInfoView.m
//  MoShou2
//
//  Created by wangzz on 16/7/4.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerShowVisitInfoView.h"

@implementation CustomerShowVisitInfoView
@synthesize visitCountLabel;
@synthesize visitDateLabel;
@synthesize visitFuncLabel;
@synthesize confirmUserLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = BACKGROUNDCOLOR;
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4];
    }
    return self;
}

-(void)setShowInfoType:(showType)showInfoType
{
    if (_showInfoType != showInfoType) {
        _showInfoType = showInfoType;
    }
    [self layoutUI];
}

//-(void)setMechanismType:(BOOL)mechanismType
//{
//    if (_mechanismType != mechanismType) {
//        _mechanismType = mechanismType;
//    }
//    if (_mechanismType) {
//        confirmUserLabel.hidden = NO;
//    }
//}

- (void)layoutUI
{
    if (_showInfoType == kShowVisitInfo) {
        visitDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width-10, 20)];
        visitDateLabel.textColor = LABELCOLOR;
//        visitDateLabel.backgroundColor = [UIColor purpleColor];
        [self addSubview:visitDateLabel];
        
        visitCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(visitDateLabel.left, visitDateLabel.bottom, self.width-20, 20)];
        visitCountLabel.textColor = LABELCOLOR;
        [self addSubview:visitCountLabel];
        
        visitFuncLabel = [[UILabel alloc] initWithFrame:CGRectMake(visitDateLabel.left, visitCountLabel.bottom, self.width-20, 20)];
        visitFuncLabel.textColor = LABELCOLOR;
        [self addSubview:visitFuncLabel];
        
        confirmUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(visitDateLabel.left, visitFuncLabel.bottom, self.width-20, 20)];
        confirmUserLabel.textColor = LABELCOLOR;
//        confirmUserLabel.backgroundColor = [UIColor greenColor];
//        confirmUserLabel.hidden = YES;

        [self addSubview:confirmUserLabel];

        if (kMainScreenWidth > 320) {
            visitDateLabel.font = FONT(10.5);
            visitCountLabel.font = FONT(10.5);
            visitFuncLabel.font = FONT(10.5);
            confirmUserLabel.font = FONT(10.5);
        }else
        {
            visitDateLabel.font = FONT(9);
            visitCountLabel.font = FONT(9);
            visitFuncLabel.font = FONT(9);
            confirmUserLabel.font = FONT(9);
        }
    }else if (_showInfoType == kShowConfirmInfo)
    {
        confirmUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width-10, 20)];
        confirmUserLabel.textColor = LABELCOLOR;
//        confirmUserLabel.backgroundColor = [UIColor yellowColor];
//        confirmUserLabel.hidden = YES;
            [self addSubview:confirmUserLabel];
        
        if (kMainScreenWidth > 320) {
            confirmUserLabel.font = FONT(10.5);
        }else
        {
            confirmUserLabel.font = FONT(9);
        }
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

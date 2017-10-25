//
//  TopOptionItemView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/25.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "TopOptionItemView.h"
#import "RecommendRecordOptionModel.h"
@interface TopOptionItemView()

//数量label
@property (nonatomic,weak)UILabel* dataNumberLabel;



@end

@implementation TopOptionItemView

- (void)setHighlighted:(BOOL)highlighted{

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.00f green:0.58f blue:0.91f alpha:1.00f] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return self;
}

- (void)setOptionModel:(RecommendRecordOptionModel *)optionModel{
    _optionModel = optionModel;
    [self setTitle:optionModel.title forState:UIControlStateNormal];
    NSString* numTitle = nil;
    if (optionModel.dataNumber < 1000) {
        numTitle = [NSString stringWithFormat:@"%zi",optionModel.dataNumber];
    }else if(optionModel.dataNumber < 10000){
        if (optionModel.dataNumber % 1000 == 0) {
            numTitle = [NSString stringWithFormat:@"%zi千",optionModel.dataNumber / 1000];
        }else{
            numTitle = [NSString stringWithFormat:@"%zi千+",optionModel.dataNumber / 1000];
        }
    }else if(optionModel.dataNumber < 100000){
        if (optionModel.dataNumber % 10000 == 0) {
            numTitle = [NSString stringWithFormat:@"%zi万",optionModel.dataNumber / 10000];
        }else if(optionModel.dataNumber % 10000 < 1000){
            numTitle = [NSString stringWithFormat:@"%zi万+",optionModel.dataNumber / 10000];
        }else if(optionModel.dataNumber % 10000 % 1000 == 0){
            numTitle = [NSString stringWithFormat:@"%zi.%zi万",optionModel.dataNumber / 10000,optionModel.dataNumber % 10000 / 1000];
        }else if(optionModel.dataNumber % 10000 % 1000 < 1000){
           numTitle = [NSString stringWithFormat:@"%zi.%zi万+",optionModel.dataNumber / 10000,optionModel.dataNumber % 10000 / 1000];
        }
    
    }
    self.dataNumberLabel.text = numTitle;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, 15, self.frame.size.width, self.titleLabel.frame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dataNumberLabel.frame = CGRectMake(0, self.frame.size.height - 7 - 10, self.frame.size.width, 10);
}

- (UILabel *)dataNumberLabel{
    if (!_dataNumberLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithRed:0.00f green:0.58f blue:0.91f alpha:1.00f];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        _dataNumberLabel = label;
    }
    return _dataNumberLabel;
}

@end

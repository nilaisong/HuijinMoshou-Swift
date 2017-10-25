//
//  XTCollectBuildingTips.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCollectBuildingTips.h"

@interface XTCollectBuildingTips()

@property (nonatomic,weak)UIImageView* imageView;

@property (nonatomic,weak)UILabel* textLabel;

@end

@implementation XTCollectBuildingTips

-(void)willMoveToSuperview:(UIView *)newSuperview{
    

}

- (void)layoutSubviews{
    self.imageView.hidden = NO;
    self.textLabel.hidden = NO;
    switch (_type) {
        case XTBuildingTipsTypeHot:
            self.imageView.frame = CGRectMake(10, (self.height - 18)/2.0, 14, 18);
            break;
        case XTBuildingTipsTypeNoResult:{
            self.imageView.hidden = YES;
            self.textLabel.hidden = YES;
        }break;
        default:
            self.imageView.frame = CGRectMake(10, (self.height - 18)/2.0, 14, 18);
            break;
    }
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 7.5, 0, kMainScreenWidth - CGRectGetMaxX(_imageView.frame) - 7.5, self.frame.size.height);
    
}

//- (NSString *)imageName{
//    if (_imageName.length <=0 || !_imageName) {
//        
//    }
//    return _imageName;
//}

- (NSString *)imageName{
    switch (_type) {
        case XTBuildingTipsTypeHot:
            _imageName = @"home-hot";
            break;
        case XTBuildingTipsTypeRecommend:
            _imageName =  @"home-recommend";
            break;
        case XTBuildingTipsTypeNoResult:{
            _imageName = @"home-hot";
        }
            break;
        default:
            _imageName = @"home-recommend";
            break;
    }
    return _imageName;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView* imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        UILabel* textLabel = [[UILabel alloc]init];
        [self addSubview:textLabel];
        textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        textLabel.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        textLabel.text = self.title;
        _textLabel = textLabel;
    }
    return _textLabel;
}

- (void)setType:(XTBuildingTipsType)type{
    _type = type;
    self.imageView.hidden = NO;
    self.textLabel.hidden = NO;
    [self.imageView setImage:[UIImage imageNamed:self.imageName]];
    switch (type) {
        case XTBuildingTipsTypeHot:
            [self.textLabel setText:@"热销楼盘"];
            break;
        case XTBuildingTipsTypeRecommend:
            [self.textLabel setText:@"推荐楼盘"];
            break;
        case XTBuildingTipsTypeNoResult:{
            self.imageView.hidden = YES;
            self.textLabel.hidden = YES;
        }break;
        default:
            [self.textLabel setText:@""];
            break;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end

//
//  MineItemButtonView.m
//  MoShou2
//
//  Created by wangzz on 2016/11/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MineItemButtonView.h"

@interface MineItemButtonView ()
{
    NSString    *_imgName;
    NSString    *_title;
}
@end

@implementation MineItemButtonView

- (id)initViewWithImgName:(NSString*)imgName WithTitle:(NSString*)title WithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];//250 * 180
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _imgName = imgName;
        _title = title;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    float scale = kMainScreenWidth/375.0;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-25*scale/2, self.height/2-25*scale, 25*scale, 25*scale)];
    [imgView setImage:[UIImage imageNamed:_imgName]];
    [self addSubview:imgView];
    
    CGSize size = [_title sizeWithAttributes:@{NSFontAttributeName:FONT(14)}];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2-size.width/2, imgView.bottom+10*scale, size.width, size.height)];
    titleLabel.textColor = NAVIGATIONTITLE;
    titleLabel.font = FONT(14);
    titleLabel.text = _title;
    [self addSubview:titleLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGestureClick:(UITapGestureRecognizer*)recognize
{
    if ([self.delegate respondsToSelector:@selector(itemViewTapClick:)])
    {
        [self.delegate itemViewTapClick:self];
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

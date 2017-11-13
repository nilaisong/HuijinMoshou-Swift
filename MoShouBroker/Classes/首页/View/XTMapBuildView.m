//
//  XTMapBuildView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapBuildView.h"
#import "NSString+Extension.h"
#import "XTButton.h"
@interface XTMapBuildView()<UIGestureRecognizerDelegate>

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)UILabel* subTitleLabel;

@property (nonatomic,weak)XTButton* backButton;

@property (nonatomic,weak)UITapGestureRecognizer* backGesture;

@end

@implementation XTMapBuildView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        _backGesture = tap;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        //
        self.userInteractionEnabled = YES;
        
        self.backButton.userInteractionEnabled = NO;
        
        //        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.subTitleLabel.text.length <= 0) {
        CGSize textSize = [self.titleLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        if (textSize.width>kMainScreenWidth-40) {
            textSize.width = kMainScreenWidth-40;
        }
        [self setBounds:CGRectMake(0.f, 0.f, textSize.width + 20, (textSize.height + 14))];
        self.backButton.frame = CGRectMake(0, 0, self.width, self.height/2.0);
        self.titleLabel.frame = CGRectMake(0, 5,self.width, 13.0f);
        return ;
    }
    CGSize textSize = [self.titleLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize subSize = [self.subTitleLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat maxWidth = textSize.width > subSize.width?textSize.width:subSize.width;
    [self setBounds:CGRectMake(0.f, 0.f, maxWidth + 20, (textSize.height + subSize.height + 18))];
    if(maxWidth > kMainScreenWidth - 40){
        maxWidth = kMainScreenWidth - 40;
    }

      self.backButton.frame = CGRectMake(0, 0, self.width, self.height);
    self.centerOffset = CGPointMake(0, -self.height/2.0);
    
    self.titleLabel.frame = CGRectMake(0, 5,self.width, 13.0f);
    self.subTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 5, self.width, 13.0f);
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [label setText:@"朝阳区"];
        [self.backButton addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [label setText:@"12"];
        [self.backButton addSubview:label];
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (void)setInfoModel:(XTMapBuildInfoModel *)infoModel{
    _infoModel = infoModel;
    
    self.titleLabel.text = infoModel.name;
    if (infoModel.price.length > 0) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@元/平",infoModel.price];
    }else{
        self.subTitleLabel.text = @"";
    }
    
    
    //    self.backButton.selected = infoModel.isSelected;
    self.highted = infoModel.isSelected;
    [self setNeedsLayout];
}

- (XTButton *)backButton{
    if (!_backButton) {
        XTButton* btn = [XTButton buttonWithType:UIButtonTypeCustom];
        btn.showHighlight = NO;
        [btn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        //43.5 31
        //        UIImage* selectedImage = [UIImage imageNamed:@"mapbuild-selected"];
        //        UIImage* normalImage = [UIImage imageNamed:@"mapbuild-normal"];
        //
        //        CGFloat top = 2; // 顶端盖高度
        //        CGFloat bottom = 15; // 底端盖高度
        //        CGFloat left = 2; // 左端盖宽度
        //        CGFloat right = 2; // 右端盖宽度
        //        UIEdgeInsets inset = UIEdgeInsetsMake(top, left , bottom,right);
        //        selectedImage = [selectedImage resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
        //        normalImage = [normalImage resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
        //        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        //        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        //
        [self addSubview:btn];
        _backButton = btn;
    }
    return _backButton;
}

- (void)actionClick:(UIButton*)btn{
    if ([_delegate respondsToSelector:@selector(mapBuildView:didSelected:)]) {
        [_delegate mapBuildView:self didSelected:_infoModel];
    }
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    //    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat jianWidth = 8;
    CGFloat jianHeight = 6;
    
    UIColor* backColor = [UIColor colorWithRed:0.29 green:0.71 blue:0.99 alpha:1.0];
    if (_highted) {
        backColor = [UIColor colorWithRed:0.00f green:0.41f blue:0.69f alpha:1.00f];
    }
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextFillRect(context, rect);
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - jianHeight) cornerRadius: 5];
    [backColor setFill];
    [rectanglePath fill];
    [[UIColor colorWithRed:0.00f green:0.41f blue:0.69f alpha:1.00f] setStroke];
    rectanglePath.lineWidth = 0.5;
    [rectanglePath stroke];
    //    UIGraphicsGetCurrentContext();
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake((width - jianWidth)/2.0, height - jianHeight - 0.5)];
    [bezierPath addLineToPoint: CGPointMake((width)/2.0, height)];
    [bezierPath addLineToPoint: CGPointMake((width + jianWidth)/2.0, height - jianHeight - 0.5)];
    [bezierPath moveToPoint: CGPointMake((width - jianWidth)/2.0, height - jianHeight - 0.5)];
    [bezierPath closePath];
    [backColor setFill];
    [bezierPath fill];
    [[UIColor colorWithRed:0.00f green:0.41f blue:0.69f alpha:1.00f] setStroke];
    bezierPath.lineWidth = 0.5;
    [bezierPath stroke];
}
- (void)setHighted:(BOOL)highted{
    _highted = highted;
    self.backButton.selected = highted;
    [self setNeedsDisplay];
}

- (void)tapAction:(UIGestureRecognizer*)gest{
    
    if ([_delegate respondsToSelector:@selector(mapBuildView:didSelected:)] && [gest.view isEqual:self]) {
        self.backButton.selected = !_backButton.selected;
        self.highted = _backButton.selected;
        [_delegate mapBuildView:self didSelected:_infoModel];
    }
}


@end

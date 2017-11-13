//
//  XTOperationItemView.m
//  MoShou2
//
//  Created by xiaotei's on 16/9/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTOperationItemView.h"
#import "UIViewExt.h"
#import "XTOperationModelItem.h"

@interface XTOperationItemView()

/**
 *  标题
 */
@property (nonatomic,strong)UILabel* textLabel;

/**
 *  字标题
 */
@property (nonatomic,strong)UILabel* subTextLabel;

@property (nonatomic,strong)UIImageView* imgView;

@property (nonatomic,strong)UIImageView* newImgV;

@property (nonatomic,strong)UIButton* maskButton;

@property (nonatomic,copy)OperationItemCallBack callBack;

@end

@implementation XTOperationItemView

- (instancetype)initWithCallBack:(OperationItemCallBack)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //    self.textLabel.frame = CGRectMake(16, 16,self.width - (42 * SCALE6 + 16 + 25), 13);
    self.textLabel.hidden= YES;
    self.subTextLabel.frame=  CGRectMake(10,15, self.width - 70,self.height - 30);
    self.imgView.frame = CGRectMake(_subTextLabel.right + 12.5, (self.height - 35)/2.0, 35, 35);
    self.newImgV.frame= CGRectMake(_imgView.right - 15.5,self.imgView.frame.origin.y - 4.5, 20, 9);
    
    self.maskButton.frame = self.bounds;
}


- (UILabel *)textLabel{
    if (!_textLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        _textLabel = label;
    }
    return _textLabel;
}

- (UILabel *)subTextLabel{
    if (!_subTextLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:label];
        label.text = @"内容即将上线，敬请期待！";
        label.numberOfLines = 0;
        _subTextLabel = label;
    }
    return _subTextLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        UIImageView* imgv = [[UIImageView alloc]init];
        [imgv setImage:[UIImage imageNamed:DEFAULTIMG]];
        [self addSubview:imgv];
        imgv.clipsToBounds = YES;
        imgv.layer.cornerRadius = 2.5;
        _imgView = imgv;
    }
    return _imgView;
}

- (UIImageView *)newImgV{
    if (!_newImgV) {
        UIImageView* imgv = [[UIImageView alloc]init];
        [imgv setImage:[UIImage imageNamed:@"new"]];
        [self addSubview:imgv];
        imgv.hidden = YES;
        _newImgV = imgv;
    }
    return _newImgV;
}

//蒙版按钮
- (UIButton *)maskButton{
    if (!_maskButton) {
        UIButton* button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = NO;
        [self addSubview:button];
        _maskButton = button;
    }
    return _maskButton;
}

- (void)buttonClick:(UIButton*)btn{
    if (_callBack) {
        _callBack(self);
    }
}

- (void)setItemModel:(XTOperationModelItem *)itemModel{
    _itemModel = itemModel;
    
    if (itemModel.title.length > 0) {
        self.subTextLabel.text = itemModel.title;
        self.maskButton.userInteractionEnabled = YES;
    }else{
        self.subTextLabel.text = @"内容即将上线，敬请期待！";
        self.maskButton.userInteractionEnabled = NO;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.imgUrl] placeholderImage:[UIImage imageNamed:DEFAULTIMG]];
    [self newImgV];
    if ([itemModel.type isEqualToString:@"RECD_PROJECT"]) {
        
    }else if([itemModel.type isEqualToString:@"RECD_AGENCY"]){
        
    }else if ([itemModel.type isEqualToString:@"RECD_NEWS"]){
        
    }else if ([itemModel.type isEqualToString:@"RECD_FEATURES"]){
        
    }
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title{
    self.textLabel.text = title;
}

- (void)setHiddenNewTips:(BOOL)hiddenNewTips{
    _hiddenNewTips = hiddenNewTips;
    self.newImgV.hidden = hiddenNewTips;
    [self setNeedsDisplay];
}

@end

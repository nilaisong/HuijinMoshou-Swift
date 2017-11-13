//
//  GSTagView.m
//  TagsAutoLayout
//
//  Created by 小怪兽 on 15/2/11.
//  Copyright (c) 2015年 小怪兽. All rights reserved.
//

#import "GSTagView.h"
#import "NSString+Extension.h"

#define TITLE_LABEL_FONT(x) [UIFont systemFontOfSize:x] //字体大小
//#define BUTTON_HEIGHT                  56/2               //按钮高
#define BUTTON_NORMAL_BGCOLOR  UIColorFromRGB(0xf3f3f3)      //正常背景色
#define BUTTON_SELECT_BGCOLOR  UIColorFromRGB(0xf3f3f3)     //选中背景色

@interface GSTagView ()
{
    int _row;
    CGFloat _allWidth;
    NSMutableArray *_itemArray;
}
@end

@implementation GSTagView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark-------------数据源
- (void)setDataSource:(NSArray *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    
    self.height = [self creatButtonWithDataSource:(NSArray *)dataSource];
    
    
}
#pragma mark-------------创建按钮
- (CGFloat)creatButtonWithDataSource:(NSArray *)dataSource {
    
    CGFloat left   = _padding.left;     //左边距
    CGFloat right  = _padding.right;    //右边距
    CGFloat top    = _padding.top;      //上边距
    CGFloat bottom = _padding.bottom;   //下边距
    _allWidth      = left;              //记录总长
    _row           = 0;                 //记录行数
  
    CGFloat BUTTON_HEIGHT;  //按钮宽度

    
    for (int i = 0; i < dataSource.count; i ++) {
        NSString *str = dataSource[i];
        
        CGFloat width;
        
        if (_tagViewStyle == ShaiXuanTagViewStyle) {
            
             width = [str widthWithFont:TITLE_LABEL_FONT(13)] +15;//按钮宽度
             BUTTON_HEIGHT = 56/2;
        }else if(_tagViewStyle == BuildingDetailTagViewStyle){
            
            width = [str widthWithFont:TITLE_LABEL_FONT(10)] +10;//按钮宽度
            BUTTON_HEIGHT =15;

        }
        
        //判断是否越界,如果越界,从下一行开始
        if ((_allWidth + width + right) > self.width) {
            _allWidth = left;
            _row ++;
        }
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        button.tag = i;

        if (_tagViewStyle == ShaiXuanTagViewStyle) {
            
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = TITLE_LABEL_FONT(13);
            button.backgroundColor = BUTTON_NORMAL_BGCOLOR;
            button.layer.cornerRadius = 3.f;
            button.layer.masksToBounds = YES;
            
        }else if(_tagViewStyle == BuildingDetailTagViewStyle){
            
            [button setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = TITLE_LABEL_FONT(10);
            button.backgroundColor = [UIColor clearColor];
            button.layer.cornerRadius = 3.f;
            button.layer.masksToBounds = YES;
            button.layer.borderColor =UIColorFromRGB(0x888888).CGColor;
            button.layer.borderWidth = 0.5;
            
            
            
        }
        

        button.frame = CGRectMake(_allWidth, top + _row * (BUTTON_HEIGHT + _verticalSpace), width, BUTTON_HEIGHT);
        
        _allWidth += (button.width + _horizontalSpace);
        
        [self addSubview:button];
        [_itemArray addObject:button];
    }
    
    return  (_row + 1) * BUTTON_HEIGHT +_row * _verticalSpace + top + bottom;

}

#pragma mark-------------button响应事件
- (void)buttonAction:(UIButton *)button {
    for (UIButton *item in _itemArray) {
        item.backgroundColor = BUTTON_NORMAL_BGCOLOR;
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (item == button) {
            button.backgroundColor = BUTTON_SELECT_BGCOLOR;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    //delegate和block任选一个即可
//    _didSelectedAtIndex((int)button.tag);
    
    if ([self.delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
        [self.delegate didSelectAtIndex:(int)button.tag];
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

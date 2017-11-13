//
//  CustomerSelectButton.m
//  MoShouBroker
//
//  Created by wangzz on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "CustomerSelectButton.h"
#import "CustomerListViewController.h"
#import "OptionData.h"

#define TITLE_LABEL_FONT(x) [UIFont systemFontOfSize:x] //字体大小
#define BUTTON_HEIGHT                  30               //按钮高
#define BUTTON_NORMAL_COLOR [UIColor colorWithHexString:@"9e9e9e"]//正常边框色
#define BUTTON_SELECT_BGCOLOR [UIColor colorWithHexString:@"f78383"]//选中背景色
#define BUTTON_SELECT_COLOR [UIColor colorWithHexString:@"f75857"]//选中边框色

@implementation CustomerSelectButton
{
    int _row;
    CGFloat _allWidth;
    NSMutableArray *_itemArray;
    NSMutableArray *_labelArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        _itemArray = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark-------------数据源
- (void)setDataSource:(NSArray *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
//    NSLog(@"self.purchaseArray = %@",self.purchseArray);
    CGFloat width = [self creatButtonWithDataSource:(NSArray *)dataSource];
    self.contentSize = CGSizeMake(width, self.height);
}
#pragma mark-------------创建按钮
- (CGFloat)creatButtonWithDataSource:(NSArray *)dataSource {
    
    CGFloat left   = _padding.left;     //左边距
    CGFloat right  = _padding.right;    //右边距
    CGFloat top    = _padding.top;      //上边距
//    CGFloat bottom = _padding.bottom;   //下边距
    _allWidth      = left;              //记录总长
    _row           = 0;                 //记录个数
    for (int i=0; i<dataSource.count; i++) {
        OptionData *option = [dataSource objectForIndex:i];
        NSString *str = option.itemName;
        if (str.length>4) {
            str = [str substringToIndex:4];
            str = [NSString stringWithFormat:@"%@...",str];
        }
        NSDictionary *attributes = @{NSFontAttributeName:TITLE_LABEL_FONT(16)};
        CGSize size = [str sizeWithAttributes:attributes];
        CGFloat width = size.width+30;
        _allWidth += (width + _horizontalSpace);
    }
    CGFloat width = kMainScreenWidth - 15 - 10 - 30;
//    DLog(@"_allWidth = %f,self.width = %f",_allWidth,width);

    if (_allWidth < width) {
        _allWidth = left;
        CGFloat btnWidth = (width-(left+right+2*self.horizontalSpace))/dataSource.count;
        for (int i = 0; i < dataSource.count; i ++) {
            OptionData *option = [dataSource objectForIndex:i];
            NSString *str = option.itemName;
            if (str.length>4) {
                str = [str substringToIndex:4];
                str = [NSString stringWithFormat:@"%@...",str];
            }
            width = btnWidth;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:str forState:UIControlStateNormal];
            [button setTitle:str forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"1a9fea"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = TITLE_LABEL_FONT(16);
//            button.tag = i+self.tagValue;
            button.frame = CGRectMake(_allWidth, top, width, BUTTON_HEIGHT);
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(_allWidth, self.height-4, width, 3);
            if (i==_lastSelected) {
                button.selected = YES;
                label.backgroundColor = [UIColor colorWithHexString:@"1a9fea"];
            }
            _allWidth += (button.width + _horizontalSpace);
            
            [self addSubview:button];
            [_itemArray appendObject:button];
            [self addSubview:label];
            [_labelArray appendObject:label];
        }
    }
    else
    {
        _allWidth = left;
//        CGFloat btnWidth = (kMainScreenWidth-(left+right+2*self.horizontalSpace))/3;
        for (int i = 0; i < dataSource.count; i ++) {
            OptionData *option = [dataSource objectForIndex:i];
            NSString *str = option.itemName;
            if (str.length>4) {
                str = [str substringToIndex:4];
                str = [NSString stringWithFormat:@"%@...",str];
            }
            NSDictionary *attributes = @{NSFontAttributeName:TITLE_LABEL_FONT(16)};
            CGSize size = [str sizeWithAttributes:attributes];
            CGFloat width = size.width+30;

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:str forState:UIControlStateNormal];
            [button setTitle:str forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"1a9fea"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = TITLE_LABEL_FONT(16);
            button.frame = CGRectMake(_allWidth, top, width, BUTTON_HEIGHT);
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(_allWidth, self.height-4, width, 3);
            
            [self addSubview:button];
            [_itemArray appendObject:button];
            [self addSubview:label];
            [_labelArray appendObject:label];
            
            if (i==_lastSelected) {
                button.selected = YES;
                label.backgroundColor = [UIColor colorWithHexString:@"1a9fea"];
                CGFloat offsetX = 0;
                //    计算即将展示的选项的应有偏移量
                if ( CGRectGetMaxX(button.frame) > self.frame.size.width) {
                    offsetX = CGRectGetMaxX(button.frame) - self.frame.size.width;
                }
                //    当当前item不是最后一个时，把下一个也推出展示
                if (i < _itemArray.count - 1) {
                    offsetX += button.width;
                }
                
                if (i == 0) {
                    offsetX = 0;
                }
                //    NSLog(@"%f",offsetX);
                [UIView animateWithDuration:0.1 animations:^{
                    self.contentOffset = CGPointMake(offsetX, 0);
                }];
            }
            _allWidth += (button.width + _horizontalSpace);
        }
    }
    
    return  _allWidth;//(_row + 1) * BUTTON_HEIGHT +_row * _verticalSpace + top + bottom;
    
}

#pragma mark-------------button响应事件
- (void)buttonAction:(UIButton *)sender {
    NSInteger index=0;
    
    for (UIButton *item in _itemArray) {
        item.selected = NO;
        if (item == sender) {
            index = [_itemArray indexOfObject:item];
            sender.selected = YES;
        }
    }
    
    for (UILabel *label in _labelArray) {
        label.backgroundColor = [UIColor clearColor];
        if (label == [_labelArray objectForIndex:index]) {
            label.backgroundColor = [UIColor colorWithHexString:@"1a9fea"];
        }
    }
    
    CGFloat offsetX = 0;
    //    计算即将展示的选项的应有偏移量
    if ( CGRectGetMaxX(sender.frame) > self.frame.size.width) {
        offsetX = CGRectGetMaxX(sender.frame) - self.frame.size.width;
    }
    //    当当前item不是最后一个时，把下一个也推出展示
    if (index < _itemArray.count - 1 && sender.right >= self.width) {
        offsetX += sender.width;
    }
    
//    if (index == 0) {
//        offsetX = 0;
//    }
    //    NSLog(@"%f",offsetX);
    [UIView animateWithDuration:0.1 animations:^{
        self.contentOffset = CGPointMake(offsetX, 0);
    }];
//    _didSelectedAtIndex((int)(sender.tag-self.tagValue),!sender.selected);
    _didSelectedAtIndex((int)index,!sender.selected);
}

- (void)buttonSeleteBlock:(selectedBlock)ablock
{
    self.didSelectedAtIndex = ablock;
}

- (void)seletedbBtnWithScrollIndex:(NSInteger)currentIndex
{
    NSInteger index=0;
    
    for (UIButton *item in _itemArray) {
        item.selected = NO;
        if ([_itemArray indexOfObject:item] == currentIndex) {
            index = [_itemArray indexOfObject:item];
            item.selected = YES;
            
            CGFloat offsetX = 0;
            //    计算即将展示的选项的应有偏移量
            if ( CGRectGetMaxX(item.frame) > self.frame.size.width) {
                offsetX = CGRectGetMaxX(item.frame) - self.frame.size.width;
            }
            //    当当前item不是最后一个时，把下一个也推出展示
            if (currentIndex < _itemArray.count - 1 && item.right >= self.width) {
                offsetX += item.width;
            }
            
//            if (currentIndex == 0) {
//                offsetX = 0;
//            }
                NSLog(@"%f",offsetX);
            [UIView animateWithDuration:0.1 animations:^{
                self.contentOffset = CGPointMake(offsetX, 0);
            }];
        }
    }
    
    for (UILabel *label in _labelArray) {
        label.backgroundColor = [UIColor clearColor];
        if (label == [_labelArray objectForIndex:index]) {
            label.backgroundColor = [UIColor colorWithHexString:@"1a9fea"];
        }
    }
    
    //    _didSelectedAtIndex((int)(sender.tag-self.tagValue),!sender.selected);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

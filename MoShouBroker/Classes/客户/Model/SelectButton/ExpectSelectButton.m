//
//  ExpectSelectButton.m
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ExpectSelectButton.h"

#define TITLE_LABEL_FONT(x) [UIFont systemFontOfSize:x] //字体大小
#define BUTTON_HEIGHT                  32               //按钮高

@implementation ExpectSelectButton


{
    int _row;
    CGFloat _allWidth;
    NSMutableArray *_itemArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _itemArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark-------------数据源
- (void)setDataSource:(NSArray *)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
    }
    //    NSLog(@"self.purchaseArray = %@",self.purchseArray);
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
    CGFloat btnWidth = (kMainScreenWidth-(left+right+2*self.horizontalSpace))/3;
    for (int i = 0; i < dataSource.count; i ++) {
        NSString *str = dataSource[i];
        //        CGFloat width = [str widthWithFont:TITLE_LABEL_FONT(13)] +15;//按钮宽度
        NSDictionary *attributes = @{NSFontAttributeName:TITLE_LABEL_FONT(12)};
        CGSize size = [str sizeWithAttributes:attributes];
        //        CGFloat width = size.width+15;
        CGFloat width = 0;
        if (size.width>btnWidth) {
            width = size.width+15;
        }else
        {
            width = btnWidth;
        }
        //判断是否越界,如果越界,从下一行开始
        if ((_allWidth + width + right) > self.width) {
            _allWidth = left;
            _row ++;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = TITLE_LABEL_FONT(12);
        button.layer.cornerRadius = 4.f;
        button.layer.masksToBounds = YES;
        [button.layer setBorderWidth:0.5];
        button.enabled = self.btnEnabled;
        if (!button.enabled) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:BLUEBTBCOLOR];
            button.layer.borderColor = BLUEBTBCOLOR.CGColor;
            
        }else
        {
            [button setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.layer.borderColor = CustomerBorderColor.CGColor;
        }
        if (_lookStyle && i==0) {
            button.selected = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:BLUEBTBCOLOR];
            button.layer.borderColor = BLUEBTBCOLOR.CGColor;
        }
        if (self.purchseArray.count != 0) {
            for (NSString *purchase in self.purchseArray) {
                if ([purchase isEqualToString:str]) {
                    button.selected = YES;
                    [button setBackgroundColor:BLUEBTBCOLOR];
                    button.layer.borderColor = BLUEBTBCOLOR.CGColor;
                }
            }
        }
        button.tag = i+self.tagValue;
        button.frame = CGRectMake(_allWidth, top + _row * (BUTTON_HEIGHT + _verticalSpace), width, BUTTON_HEIGHT);
        
        _allWidth += (button.width + _horizontalSpace);
        
        [self addSubview:button];
        [_itemArray appendObject:button];
        
    }
    
    return  (_row + 1) * BUTTON_HEIGHT +_row * _verticalSpace + top + bottom;
    
}

#pragma mark-------------button响应事件
- (void)buttonAction:(UIButton *)sender {
    if (sender.tag == 1251 || sender.tag == 1252) {
        for (UIButton *item in _itemArray) {
            item.selected = NO;
            [item setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
            [item setBackgroundColor:[UIColor whiteColor]];
            item.layer.borderColor = CustomerBorderColor.CGColor;
            
            if (item == sender) {
                sender.selected = YES;
                [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [sender setBackgroundColor:BLUEBTBCOLOR];
                sender.layer.borderColor = BLUEBTBCOLOR.CGColor;
            }
        }
    }else
    {
        if(!sender.selected) {
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundColor:BLUEBTBCOLOR];
            sender.layer.borderColor = BLUEBTBCOLOR.CGColor;
            sender.selected = NO;
        }else
        {
            [sender setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
            [sender setBackgroundColor:[UIColor whiteColor]];
            sender.layer.borderColor = CustomerBorderColor.CGColor;
            sender.selected = YES;
        }
    }
    _didSelectedAtIndex((int)(sender.tag-self.tagValue),!sender.selected);
    
    sender.selected = !sender.selected;
}

- (void)excptButtonSeleteBlock:(selectedBlock)ablock
{
    self.didSelectedAtIndex = ablock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

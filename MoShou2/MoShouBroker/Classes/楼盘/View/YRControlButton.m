//
//  MGJControlButton.m
//  MogujieTuan4iPhone
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "YRControlButton.h"
#import "UIView+YR.h"

#define SEPARATOR_WIDTH 1.f
#define MGJ_CHANNEL_ANIMATION_DURATION 0.2
#define _SEPARTOR_LEFT 12
#define _SEPARTOR_WIDTH 25

@interface YRControlButton (){
    BOOL  _isHome;
    NSMutableArray *_iconImageArray;
    NSInteger _separtorLeft;
    UIColor *_buttonBackgroundColor;
    UIColor *_buttonSelectedColor;
    UILabel *_countLabel;
    int _count;
}

- (void)isShortSelector:(BOOL)isShort;
- (void)setButtonBackground:(UIColor *)color;
- (void)setButtonSelectedBackground:(UIColor *)color;

@end

@implementation YRControlButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHome = NO;
        _selectedIndex = 0;
        _separtorLeft = _SEPARTOR_LEFT;
        _buttonBackgroundColor = [UIColor whiteColor];
        _buttonSelectedColor = [UIColor whiteColor];
        _selectedTextColor =  BLUEBTBCOLOR;                                   //UIColorFromRGB(0xf4595b);
        _normalTextColor = UIColorFromRGB(0x333333);                //UIColorFromRGB(0x625e5b);
        self.backgroundColor = _buttonBackgroundColor;
    }
    return self;
}



- (void)initButtonWithTitles:(NSArray*)titles
                        icon:(NSArray*)icons
                iconSelected:(NSArray*)selectedIcons
             isShowSeparator:(BOOL) separator
             isShortSelector:(BOOL)isShort
         setButtonBackground:(UIColor *)color
 setButtonSelectedBackground:(UIColor *)selectedColor
                defaultIndex:(NSInteger)index {
    _selectedIndex = index;
    _count = (int)titles.count;
    
    [self removeAllSubviews];
    
    
    [self setButtonBackground:color];
    [self setButtonSelectedBackground:selectedColor];
    
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.height)];
    bg.backgroundColor = _buttonBackgroundColor;
    [self addSubview:bg];
    
    NSInteger num = [titles count];
    
    _btnArray = [[NSMutableArray alloc] initWithCapacity:num];
    _linebtnArray = [[NSMutableArray alloc]initWithCapacity:num];
    _iconArray = [icons mutableCopy];
    _selectedIconArray = [selectedIcons mutableCopy];
    int i = 0;
    
    _buttonWidth = (self.width - (num - 1) * SEPARATOR_WIDTH) / num;
    
    for (NSString *title in titles) {
        //按钮
        UIImage *icon = nil;
        if (icons) {
            icon = [icons objectForIndex:i];
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIButton *lineBtn = [UIButton buttonWithType:UIButtonTypeCustom];//下方横线line
        
        btn.opaque = NO;
        btn.frame = CGRectMake((_buttonWidth + SEPARATOR_WIDTH ) * i, 0, _buttonWidth, self.height-4);
        lineBtn.frame = CGRectMake((_buttonWidth + SEPARATOR_WIDTH ) * i, self.height-4, _buttonWidth, 3);
        if (icon) {
            [self  buttonWithImage:icon imageEdgeInsets:UIEdgeInsetsMake(self.height/2- icon.size.height/2-2, _buttonWidth/8, self.height/2- icon.size.height/2-2, _buttonWidth/8 + icon.size.width) title:title titleEdgeInsets:UIEdgeInsetsMake(self.height/2- icon.size.height/2-2, _buttonWidth/8 , self.height/2- icon.size.height/2-2, 0) font:FONT(15) target:self action:@selector(buttonAction:) button:btn];
        } else {
            [self buttonWithImage:nil imageEdgeInsets:UIEdgeInsetsZero title:title titleEdgeInsets:UIEdgeInsetsZero font:FONT(15) target:self action:@selector(buttonAction:) button:btn];
        }
        
        if (i == _selectedIndex) {
            if (icons) {
                [btn setImage:_selectedIconArray[i] forState:UIControlStateNormal];
                [btn setImage:_selectedIconArray[i] forState:UIControlStateHighlighted];
            }
            [btn setTitleColor:_selectedTextColor forState:UIControlStateNormal];
            [btn setBackgroundColor:_buttonSelectedColor];
            
            [lineBtn setBackgroundColor:BLUEBTBCOLOR];
            
        }
        btn.tag = i;
        lineBtn.tag = i+1000;
        [self addSubview:btn];
        [self addSubview:lineBtn];
        
        [_btnArray addObject:btn];
        [_linebtnArray addObject:lineBtn];

        i++;
    }
    
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 2)];
    bottomSeparator.backgroundColor = color;
    [self addSubview:bottomSeparator];
    
 [self addSubview:_selectedColor];
    
    [self isShortSelector:isShort];
}




- (void)isShortSelector:(BOOL)isShort {
    if (!isShort) {
        _selectedColor.frame = CGRectMake((_buttonWidth + SEPARATOR_WIDTH)* _selectedIndex ,self.height - 2, _buttonWidth, 2);
        _separtorLeft = 0;
    }
}

- (void)setButtonBackground:(UIColor *)color {
    if (color) {
        _buttonBackgroundColor = color;
    }
}

- (void)setButtonSelectedBackground:(UIColor *)color {
    if (color) {
        _buttonSelectedColor = color;
    }
}

- (void)buttonAction:(UIButton *)btn
{
    if (btn.tag == _selectedIndex) {
        return;
    }
    
    
//    for (UIButton *lineBtn in _linebtnArray) {
//        
//        lineBtn.backgroundColor = [UIColor blackColor];
//    }
//    
//    UIButton *tempLineBtn =(UIButton *)[self viewWithTag:btn.tag+1000];
//    tempLineBtn.backgroundColor = BLUEBTBCOLOR;
//    
    [self selectAtIndex:btn.tag];
    if (self.block) {
        self.block(btn.tag);
    }
}

- (void)selectAtIndex:(NSInteger)index {
   ((UIButton*)(_btnArray[_selectedIndex])).titleLabel.font = FONT(15);
    if ([_iconArray count] > 0) {
    
        if ([_iconArray[_selectedIndex] isKindOfClass:[UIImage class]]) {
            
            ((UIImageView*)(_iconImageArray[_selectedIndex])).image = _iconArray[_selectedIndex];
           
        } else {
//            [((UIImageView*)(_iconImageArray[_selectedIndex])) setImageWithURL:_iconArray[_selectedIndex]];
//            [BDImageUtil setImageView:((UIImageView*)(_iconImageArray[_selectedIndex])) withImageUrl:_iconArray[_selectedIndex]];
           
        }
    }
    if (_isHome) {
        [(UIButton*)(_btnArray[_selectedIndex]) setTitleColor:_normalTextColor  forState:UIControlStateNormal];
    } else {
        [(UIButton*)(_btnArray[_selectedIndex]) setImage:_iconArray[_selectedIndex] forState:UIControlStateNormal];
        [(UIButton*)(_btnArray[_selectedIndex]) setImage:_iconArray[_selectedIndex] forState:UIControlStateHighlighted];

        [(UIButton*)(_btnArray[_selectedIndex]) setBackgroundColor:_buttonBackgroundColor];
        [(UIButton*)(_btnArray[index]) setBackgroundColor:_buttonSelectedColor];
        

        [(UIButton*)(_linebtnArray[_selectedIndex]) setBackgroundColor:[UIColor whiteColor]];
        [(UIButton*)(_linebtnArray[index]) setBackgroundColor:BLUEBTBCOLOR];
        
        

        [(UIButton*)(_btnArray[_selectedIndex]) setTitleColor:_normalTextColor  forState:UIControlStateNormal];
    }
    _selectedIndex = index;
    
    [UIView animateWithDuration:MGJ_CHANNEL_ANIMATION_DURATION animations:^{
        _selectedColor.left = (_buttonWidth + SEPARATOR_WIDTH)* _selectedIndex + _separtorLeft;//_SEPARTOR_LEFT;
    }];
    if (_selectedImg) {
        _selectedImg.left = (_buttonWidth + SEPARATOR_WIDTH ) * _selectedIndex;
    }

    if ([_selectedIconArray count] > 0) {
        if ([_selectedIconArray[_selectedIndex] isKindOfClass:[UIImage class]]) {
            ((UIImageView*)(_iconImageArray[_selectedIndex])).image = _selectedIconArray[_selectedIndex];
            if (!_isHome) {
                [(UIButton*)(_btnArray[_selectedIndex]) setImage:_selectedIconArray[_selectedIndex] forState:UIControlStateNormal];
                [(UIButton*)(_btnArray[_selectedIndex]) setImage:_selectedIconArray[_selectedIndex] forState:UIControlStateHighlighted];
            }
           
        } else {
//            [((UIImageView*)(_iconImageArray[_selectedIndex])) setImageWithURL:_selectedIconArray[_selectedIndex]];
//            [BDImageUtil setImageView:((UIImageView*)(_iconImageArray[_selectedIndex])) withImageUrl:_selectedIconArray[_selectedIndex]];
        }
       
    }
    [(UIButton*)(_btnArray[_selectedIndex]) setTitleColor:_selectedTextColor  forState:UIControlStateNormal];

}

- (void)setBoldFontAtIndex:(NSInteger)index {
    ((UIButton*)(_btnArray[index])).titleLabel.font = FONT(15);
}


- (void)buttonWithImage:(UIImage *)image
        imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                  title:(NSString *)title
        titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                   font:(UIFont *)font target:(id)target
                 action:(SEL)action
                 button:(UIButton*)button {
    
    button.backgroundColor = _buttonBackgroundColor;//RGB(246, 246, 246);
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    button.imageEdgeInsets = imageEdgeInsets;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.titleEdgeInsets = titleEdgeInsets;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonWithTitle:(NSString *)title
        titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                   font:(UIFont *)font
                 target:(id)target
                 action:(SEL)action
                 button:(UIButton*)button {
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.titleEdgeInsets = titleEdgeInsets;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


@end

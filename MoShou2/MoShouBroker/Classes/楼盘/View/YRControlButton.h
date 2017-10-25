//
//  MGJControlButton.h
//  MogujieTuan4iPhone
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.//

#import <UIKit/UIKit.h>

typedef void(^buttonActionLock)(NSInteger index);

@interface YRControlButton : UIView {
    UIView          *_selectedColor;
    UIImageView     *_selectedImg;
    NSInteger       _buttonWidth;
    NSMutableArray  *_iconArray;
    NSMutableArray  *_selectedIconArray;
}
@property (nonatomic,copy   ) buttonActionLock block;
@property (nonatomic, assign) NSInteger        selectedIndex;
@property (nonatomic, strong) NSMutableArray   *btnArray;
@property (nonatomic, strong) NSMutableArray   *linebtnArray;

@property (nonatomic, strong) UIColor          *selectedTextColor;
@property (nonatomic, strong) UIColor          *normalTextColor;


- (void)initButtonWithTitles:(NSArray*)titles
                        icon:(NSArray*)icons
                iconSelected:(NSArray*)selectedIcons
             isShowSeparator:(BOOL) separator
             isShortSelector:(BOOL)isShort
         setButtonBackground:(UIColor *)color
 setButtonSelectedBackground:(UIColor *)selectedColor
                defaultIndex:(NSInteger)index;

- (void)selectAtIndex:(NSInteger)index;
- (void)setBoldFontAtIndex:(NSInteger)index;


@end




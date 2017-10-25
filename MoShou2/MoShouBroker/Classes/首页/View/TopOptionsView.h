//
//  TopOptionsView.h
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OptionItemWidth 58
#define OptionItemHeight 53
#define OptionMargin 10

@class TopOptionsView;

@protocol TopOptionsViewDelegate <NSObject>

/**
 *  选中了某个标签选项
 */
-(void)topOptionsView:(TopOptionsView*)opView didSelectedOptions:(NSInteger)index;

- (void)topOptionsView:(TopOptionsView *)opView requestOptionsWithCurrentIndeex:(NSInteger)index;
@end

@interface TopOptionsView : UIView

/**顶部分类选项按钮*/
@property (nonatomic,weak)NSArray* optionsArray;

//当前选中的标签
@property (nonatomic,assign)NSInteger currentIndex;

- (instancetype)initWithOptionsArray:(NSArray*)options;

+ (instancetype)optionsViewWithArray:(NSArray*)options;

//顶部标签栏的代理
@property (nonatomic,weak)id<TopOptionsViewDelegate> delegate;

@end

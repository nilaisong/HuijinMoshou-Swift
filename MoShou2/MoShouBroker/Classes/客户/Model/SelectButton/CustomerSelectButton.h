//
//  CustomerSelectButton.h
//  MoShouBroker
//
//  Created by wangzz on 15/6/23.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"

typedef void(^selectedBlock)(int ,BOOL);

@interface CustomerSelectButton : UIScrollView

@property (nonatomic, assign) UIEdgeInsets      padding;            //边距
@property (nonatomic, assign) CGFloat           horizontalSpace;    //横向间隔
@property (nonatomic, assign) CGFloat           verticalSpace;      //纵向间隔
@property (nonatomic, assign) NSInteger         tagValue;
@property (nonatomic, assign) NSInteger         lastSelected;
@property (nonatomic, strong) NSArray           *dataSource;        //数据源

@property (nonatomic, copy) selectedBlock didSelectedAtIndex;     //block

@property (nonatomic, assign) BOOL              btnEnabled;//button是否可点击

@property (nonatomic, strong) NSArray           *purchseArray;//购房意向
@property (nonatomic, assign) BOOL              lookStyle;

- (void)seletedbBtnWithScrollIndex:(NSInteger)currentIndex;
- (void)buttonSeleteBlock:(selectedBlock)ablock;

@end

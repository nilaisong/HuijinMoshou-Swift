//
//  ExpectSelectButton.h
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"

typedef void(^selectedBlock)(int ,BOOL);

@interface ExpectSelectButton : UIView

@property (nonatomic, assign) UIEdgeInsets      padding;            //边距
@property (nonatomic, assign) CGFloat           horizontalSpace;    //横向间隔
@property (nonatomic, assign) CGFloat           verticalSpace;      //纵向间隔
@property (nonatomic, assign) NSInteger         tagValue;
@property (nonatomic, strong) NSArray           *dataSource;        //数据源

@property (nonatomic, copy) selectedBlock didSelectedAtIndex;     //block

@property (nonatomic, assign) BOOL              btnEnabled;//button是否可点击

@property (nonatomic, strong) NSArray           *purchseArray;//购房意向
@property (nonatomic, assign) BOOL              lookStyle;

- (void)excptButtonSeleteBlock:(selectedBlock)ablock;

@end

//
//  XTOperationItemView.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//  具体资讯view

#import <UIKit/UIKit.h>

#define DEFAULTIMG @"home-zixunnormal"

@class XTOperationModelItem;
@class XTOperationItemView;
typedef void(^OperationItemCallBack)(XTOperationItemView* view);

@interface XTOperationItemView : UIView

- (instancetype)initWithCallBack:(OperationItemCallBack)callBack;

@property (nonatomic,strong)XTOperationModelItem* itemModel;

@property (nonatomic,copy)NSString* title;

@property (nonatomic,assign)BOOL hiddenNewTips;

@end

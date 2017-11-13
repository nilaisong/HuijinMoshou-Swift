//
//  XTWebNavigationControler.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/27.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class XTOperationModelItem;
@interface XTWebNavigationControler : BaseViewController

- (instancetype)initWithURLString:(NSString*)urlString;

- (instancetype)initWithURLString:(NSString *)urlString title:(NSString*)title;

/**
 *  运营数据
 */
@property (nonatomic,strong)XTOperationModelItem* itemModel;

@property (nonatomic,copy)NSString* titleString;

/**
 *  是否展示标题和更多
 */
@property (nonatomic,assign)BOOL showTitleAndMore;

/**
 *  是否是二级页面
 */
@property (nonatomic,assign)BOOL isSecondLoad;

@end

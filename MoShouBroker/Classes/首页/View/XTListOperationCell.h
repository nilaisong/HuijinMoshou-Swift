//
//  XTListOperationCell.h
//  MoShou2
//
//  Created by xiaotei's on 16/10/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTOperationModelItem;

@interface XTListOperationCell : UITableViewCell

@property (nonatomic,copy)NSString* titleStr;


/**
 *  推荐数据模型
 */
@property (nonatomic,strong)XTOperationModelItem* itemModel;

//下划线格式0顶部 1底部
@property (nonatomic,assign)NSInteger lineState;

@end

//
//  XTOperationModel.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XTOperationModelItem;

@interface XTOperationModel : NSObject

/**
 *  项目推荐
 */
@property (nonatomic,strong)XTOperationModelItem* recd_project;

/**
 *  头条经纪人
 */
@property (nonatomic,strong)XTOperationModelItem* recd_agency;

/**
 *  最新资讯
 */
@property (nonatomic,strong)XTOperationModelItem* recd_news;

/**
 *  新功能推荐
 */
@property (nonatomic,strong)XTOperationModelItem* recd_features;

@end

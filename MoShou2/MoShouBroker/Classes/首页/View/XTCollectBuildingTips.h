//
//  XTCollectBuildingTips.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XTBuildingTipsType) {
    XTBuildingTipsTypeHot,
    XTBuildingTipsTypeRecommend,
    XTBuildingTipsTypeNoResult,
};

@interface XTCollectBuildingTips : UIView

//标签标题
@property (nonatomic,copy)NSString* title;

@property (nonatomic,copy)NSString* imageName;

@property (nonatomic,assign)XTBuildingTipsType type;

@end

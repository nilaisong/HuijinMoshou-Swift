//
//  XTMapBuildView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import "XTMapBuildInfoModel.h"
#import "XTButton.h"
@class XTMapBuildView;
@protocol XTMapBuildViewDelegate <NSObject>

- (void)mapBuildView:(XTMapBuildView*)mapBuildView didSelected:(XTMapBuildInfoModel*)infoModel;

@end

@interface XTMapBuildView : BMKAnnotationView


@property (nonatomic,strong)XTMapBuildInfoModel* infoModel;


@property (nonatomic,assign)BOOL highted;
@property (nonatomic,weak)id<XTMapBuildViewDelegate> delegate;

@end

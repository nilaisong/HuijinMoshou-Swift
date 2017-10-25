//
//  MoreChooseView.h
//  MoShou2
//
//  Created by strongcoder on 16/8/3.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityFirstResult.h"
//CityFirstResult * _cityFirstResult;//楼盘页面初始化的数据

@class MoreChooseView;

@protocol MoreChooseViewDelegate <NSObject>

@optional
-(void)didcommintBtnWithMoreChooseDic:(NSDictionary *)moreDic;

@end


@interface MoreChooseView : UIView

-(id)initWithFrame:(CGRect)frame andCityFirstResult:(CityFirstResult*)CityFirstResult;

-(void)refreshBtnStyleWithChooseDic:(NSDictionary *)moreDic;


@property (nonatomic,weak)id<MoreChooseViewDelegate>delegate;

@end

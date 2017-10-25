//
//  DoorTypeView.h
//  MoShouBroker
//
//  Created by strongcoder on 15/7/16.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomLayout.h"

@class DoorTypeView;
@protocol DoorTypeViewTapActionDelegate <NSObject>

-(void)doorTypeViewTapACtion:(DoorTypeView *)view;

@end


@interface DoorTypeView : UIView

@property (nonatomic,weak)id<DoorTypeViewTapActionDelegate>delegate;
@property (nonatomic,strong)RoomLayout *roomLayoutMo;
@property (nonatomic,assign)NSInteger currentIndex;   //当前户型详情在总数组中的位置索引
@property (nonatomic,  copy)NSString *buildingId;

//竖着排列
-(id)initWithRoomlayout:(RoomLayout *)roomLauout;



//横着排列
-(id)initHorizontalStyleWithRoomlayout:(RoomLayout *)roomLauout;



@end

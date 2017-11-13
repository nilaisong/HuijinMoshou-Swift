//
//  ChooseCityViewController.h
//  MoShouBroker
//
//  Created by caotianyuan on 15/7/9.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^GetChooseCityNameAndId)(NSString *cityName,NSString *cityId,NSString *selectedLongitude,NSString *selectedLatitude);



@interface ChooseCityViewController : BaseViewController

@property (nonatomic,assign)BOOL hiddenLeftButton;
@property (nonatomic,copy)GetChooseCityNameAndId getChooseCityNameAndId;
@property (nonatomic,assign)BOOL NotShouldWriteToPlist;   //默认为 NO   写入   如有不需要写入的   需要手动设置为YES  这时候通过上面的block 老获取选择的城市id和name

@end

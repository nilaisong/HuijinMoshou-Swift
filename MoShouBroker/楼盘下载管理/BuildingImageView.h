//
//  BuildingImageView.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/8/7.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "MyImageView.h"

@interface BuildingImageView : MyImageView

@property(atomic,strong) NSString* buildingId;
-(id)initWithFrame:(CGRect)frame andBuildingId:(NSString*)bId;

@end

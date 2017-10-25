//
//  MapViewController.h
//  MoShouBroker
//
//  Created by admin on 15/6/10.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "Building.h"
@interface MapViewController : BaseViewController

@property (nonatomic, strong) Building *buileding;

@property (nonatomic,assign)BOOL isShouldCallOut;


@end

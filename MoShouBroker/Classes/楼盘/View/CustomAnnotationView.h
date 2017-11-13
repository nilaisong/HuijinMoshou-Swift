//
//  CustomAnnotationView.h
//  MoShouBroker
//
//  Created by admin on 15/7/13.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "CustomCalloutView.h"

@interface CustomAnnotationView : BMKAnnotationView


@property (nonatomic,copy)NSString *buildTitle;

@property (nonatomic,copy)NSString *buildLocationString;


@property (nonatomic,strong)UIView *contentView;

//@property (nonatomic,strong)


@end

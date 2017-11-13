//
//  SpecialHouseView.h
//  MoShou2
//
//  Created by Mac on 2016/12/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"
typedef void(^OpenAndCloseSpeciaHouseViewBlock)(CGFloat height, BOOL openStyle);


@interface SpecialHouseView : UIView

@property (nonatomic,strong)Building *building;

-(id)initWithFrame:(CGRect)frame WithSpeciaHouseArray:(NSArray *)array AndOpenStyle:(BOOL)openStyle;

@property (nonatomic,copy)OpenAndCloseSpeciaHouseViewBlock openAndCloseSpeciaHouseViewBlock;


@end

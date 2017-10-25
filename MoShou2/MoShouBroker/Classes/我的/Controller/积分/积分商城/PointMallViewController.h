//
//  PointMallViewController.h
//  MoShou2
//
//  Created by Aminly on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,POINTBTNTAG) {
    
    POINTMALLSIGNTAG=1000,
    
};
@interface PointMallViewController : BaseViewController
@property(nonatomic,assign)int page;
@property(nonatomic,assign)BOOL morePage;
@property(nonatomic, strong)NSMutableArray *goodsListArr;
@end

//
//  MineController.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,MINEBTNTAG) {
    SETTINGBTNTAG=1000,
    MSGBTNTAG,
    MINESIGNTAG,
    MINEHEADTAG,
    
};
@interface MineController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@end

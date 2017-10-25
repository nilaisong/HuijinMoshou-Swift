//
//  AboutUsViewController.h
//  MoShou2
//
//  Created by Aminly on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutUsViewController : BaseViewController
@property(nonatomic ,assign)BOOL needUpdate;
@property(nonatomic,assign)BOOL isNew;
@property(nonatomic,strong) NSString *updateMsg;
@property(nonatomic,strong) NSString *version;

@end

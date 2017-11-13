//
//  MessageCenterViewController.h
//  MoShou2
//
//  Created by Aminly on 15/12/1.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageCenterViewController : BaseViewController
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,assign)BOOL morePage;
@end

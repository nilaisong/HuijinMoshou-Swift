//
//  ChatViewController.h
//  MoShou2
//
//  Created by strongcoder on 16/9/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface ChatViewController : EaseMessageViewController<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>



@property (nonatomic,copy)NSString *buildingID;

@property (nonatomic,copy)NSString *nickName;

@end

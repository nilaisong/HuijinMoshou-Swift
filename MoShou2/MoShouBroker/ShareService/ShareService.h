//
//  ShareService.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/15.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
//#import "ShareModel.h"

@interface ShareService : NSObject

@property(atomic,strong) ShareModel* shareModel;

+(ShareService *)sharedService;
- (void)registerSharedApp;

-(void)showShareActionSheetWithView:(UIView*)sender andShareModel:(ShareModel*)model;

@end

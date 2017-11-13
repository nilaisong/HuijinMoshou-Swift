//
//  ShareActionSheet.h
//  MoShou2
//
//  Created by Aminly on 15/12/8.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShareModel.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "CustomIOSAlertView.h"

typedef NS_ENUM(NSInteger,SHARETYPE) {
    IMAGE=100,
    APP,
    BUILDING,
    WORKREPORT,
    CONTENTOPERATE,
    WEBOPERATE,//网页运营分享
};
@interface ShareActionSheet : UIView<UIGestureRecognizerDelegate,CustomIOSAlertViewDelegate>
@property(nonatomic,strong)ShareModel *model;
@property(nonatomic,assign)SHARETYPE type;
@property(nonatomic ,strong)UIView * parent;
//@property(nonatomic ,strong)AppDelegate *_appDelegate;

-(instancetype)initWithShareType:(SHARETYPE)type andModel:(ShareModel *)model;
//工作报表分享
-(instancetype)initWithWorkReportShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent;
//楼盘和app分享使用的方法
-(instancetype)initWithShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent;
//内容运营分享
- (instancetype)initContentOperateWithShareType:(SHARETYPE)type andModel:(ShareModel*)model andParent:(UIView*)parent;

//自动
-(instancetype)initAutoShareViewWithShareRange:(NSMutableArray *)shareArray ShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent;



@end

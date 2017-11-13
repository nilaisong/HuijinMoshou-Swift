//
//  ShareActionSheet.m
//  MoShou2
//
//  Created by Aminly on 15/12/8.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ShareActionSheet.h"
#import "HMTool.h"
#import "AppDelegate.h"
#import "UIImageHelper.h"
#import "UIImageExtras.h"
#define LOGO [[NSBundle mainBundle] pathForResource:@"sharelogo" ofType:@"png"]
#define CONTENT  @"魔售是新房经纪人的魔法工具。可供经纪人实时查看楼盘，快速报备客户，轻松获得佣金。"

@implementation ShareActionSheet{
    UIView *shareBG;
    UIView *maskView;
    UIView *actionSheetView;
    UIButton *cancelBtn ;
    NSArray *textArr;
    UIImage *publishImage;
    AppDelegate *_appDelegate;
    CGRect btnFrame;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithShareType:(SHARETYPE)type andModel:(ShareModel *)model{
    if (self= [super init]) {
        if (type) {
            self.type = type;
        }else{
            self.type = APP;
            
        }
        if (model) {
            
            self.model = model;
        }else{
            
            self.model = [[ShareModel alloc]init];
        }
        textArr = [NSArray arrayWithObjects:@"微信",@"朋友圈",@"微博",@"QQ",@"信息", nil];
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        maskView = [[UIView alloc]init];
        maskView.frame = self.frame;
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        [self addSubview:maskView];
        UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidActionSheet)];
        masktap.delegate = self;
        masktap. cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:masktap];
        
        
        actionSheetView = [[UIView alloc]init];
        //        [actionSheetView setBackgroundColor:[UIColor whiteColor]];
        [actionSheetView setFrame:CGRectMake(0,kMainScreenHeight-20-(140+10+58), kMainScreenWidth, 140+20+58)];
        [self addSubview:actionSheetView];
        
        cancelBtn =[[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"whitebtn"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"rectangle按下"] forState:UIControlStateHighlighted];
        [cancelBtn setFrame:CGRectMake(10,kFrame_Height(actionSheetView)-58-10, kMainScreenWidth-20,58)];
        [cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidActionSheet) forControlEvents:UIControlEventTouchUpInside];
        [actionSheetView   addSubview: cancelBtn];
        
        shareBG = [[UIView alloc]init];
        [shareBG setFrame:CGRectMake(0,kFrame_Y(cancelBtn)-10-140 , kMainScreenWidth, 140)];
        [shareBG setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
//        shareBG.layer.cornerRadius = 8;
//        shareBG.layer.masksToBounds = YES;
        [actionSheetView addSubview:shareBG];
        CGFloat width = ((kFrame_Width(shareBG)-10-25)-(10+25))/4;
        
        for (int i=0; i<5; i++) {
            UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
            [shareBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareicon_%d",i]] forState:UIControlStateNormal];
            shareBtn.centerX = 35+width*i;
            
            [shareBtn setTag:1000+i];
            [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareBG addSubview:shareBtn];
            
            UILabel *title = [[UILabel alloc]init];
            [title setText:[textArr objectForIndex:i]];
            [title setTextColor:NAVIGATIONTITLE];
            [title setFont:[UIFont systemFontOfSize:11]];
            CGSize textSize =[HMTool getTextSizeWithText:title.text andFontSize:11];
            [title setSize:textSize];
            [title setCenterY:kFrame_YHeight(shareBtn)+10+textSize.height/2];
            [title setCenterX:shareBtn.centerX];
            [shareBG addSubview:title];
        }
        [self showActionSheet];
    }
    
    return self;
}
-(instancetype)initWithWorkReportShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent{
    if (self= [super init]) {
        self.parent = parent;
        if (type) {
            self.type = type;
        }else{
            self.type = APP;
            
        }
        if (model) {
            
            self.model = model;
        }else{
            
            self.model = [[ShareModel alloc]init];
        }
        
        textArr = [NSArray arrayWithObjects:@"微信",@"QQ",@"信息", nil];
        
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        maskView = [[UIView alloc]init];
        maskView.frame = self.frame;
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        [self addSubview:maskView];
        UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidActionSheet)];
        masktap.delegate = self;
        masktap. cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:masktap];
        
        actionSheetView = [[UIView alloc]init];
        [actionSheetView setFrame:CGRectMake(0,kMainScreenHeight-224, kMainScreenWidth, 224)];
        actionSheetView.backgroundColor = [UIColor whiteColor];
        [self addSubview:actionSheetView];
        
        UILabel *titleLabel = [UILabel createLabelWithFrame:CGRectMake(0, 20, kMainScreenWidth, 16) text:@"分享" textAlignment:NSTextAlignmentCenter fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [actionSheetView addSubview:titleLabel];
        
//        UILabel *secontTitleLabel = [UILabel createLabelWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, 13) text:@"分享给客户不显示带看规则和佣金" textAlignment:NSTextAlignmentCenter fontSize:12.f textColor:UIColorFromRGB(0x888888)];
//        [actionSheetView addSubview:secontTitleLabel];
        
        
        cancelBtn =[[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [cancelBtn setFrame:CGRectMake((kMainScreenWidth-190*SCALE6)/2,kFrame_Height(actionSheetView)-35-20, 190*SCALE6,35)];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidActionSheet) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        cancelBtn.layer.borderWidth = 1.f;
        cancelBtn.layer.cornerRadius = 4;
        [actionSheetView   addSubview: cancelBtn];
        
        shareBG = [[UIView alloc]init];
        [shareBG setFrame:CGRectMake(0,50, kMainScreenWidth, actionSheetView.height-70-35-20)];
        [shareBG setBackgroundColor:[UIColor clearColor]];
        shareBG.layer.cornerRadius = 8;
        shareBG.layer.masksToBounds = YES;
        
        [actionSheetView addSubview:shareBG];
        CGFloat width = ((kMainScreenWidth-10-25)-(10+25))/4;
        //        @"微信",@"朋友圈",@"微博",@"QQ",@"信息",
        for (int i=0; i<3; i++) {
            
            UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
            int img = i;
            if (i > 0) {
                img += 2;
            }
            [shareBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareicon_%d",img]] forState:UIControlStateNormal];
            
            if (i == 1) {
                [shareBtn setBackgroundImage:[UIImage imageNamed:@"shareicon_2"] forState:UIControlStateNormal];
            }
            shareBtn.centerX = 35+width*i;
            
            if (i == 0) {
                [shareBtn setTag:1000];
                
            }else if (i== 1){
                [shareBtn setTag:1002];
                
            }else if (i== 2){
                [shareBtn setTag:1004];
                
            }

            [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareBG addSubview:shareBtn];
            
            UILabel *title = [[UILabel alloc]init];
            [title setText:[textArr objectForIndex:i]];
            [title setTextColor:NAVIGATIONTITLE];
            [title setFont:[UIFont systemFontOfSize:11]];
            CGSize textSize =[HMTool getTextSizeWithText:title.text andFontSize:11];
            [title setSize:textSize];
            [title setCenterY:kFrame_YHeight(shareBtn)+10+textSize.height/2];
            [title setCenterX:shareBtn.centerX];
            [shareBG addSubview:title];
        }
        self.parent = parent;
        [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        [self showActionSheet];
    }
    
    return self;
}
//显示actionSheet动画
-(void)showActionSheet{
    
    
    actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight+kFrame_Height(actionSheetView)/2);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        if (self.parent) {
//            for (UIView *view in [self.parent subviews]) {
//                view.userInteractionEnabled  = NO;
//            }
//        }
        self.userInteractionEnabled = NO;

        CGPoint center = actionSheetView.center;
        center.y -= actionSheetView.frame.size.height;
        actionSheetView.center = center;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.userInteractionEnabled = YES;
            
        });
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        } completion:^(BOOL finished) {
            
            actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight-kFrame_Height(actionSheetView)/2);

           

        }];
        
        
    }];
    
    
    
}
//actionsheet消失的时候的动画
-(void)hidActionSheet{
    if (actionSheetView.centerY >=kMainScreenHeight-kFrame_Height(actionSheetView)/2) {
        actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight-kFrame_Height(actionSheetView)/2);
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint center = actionSheetView.center;
            center.y += actionSheetView.frame.size.height;
            actionSheetView.center = center;
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            } completion:^(BOOL finished) {
                
                actionSheetView.center = CGPointMake(kMainScreenWidth/2, kMainScreenHeight+kFrame_Height(actionSheetView)/2);
//                if (self.parent) {
//                    for (UIView *view in [self.parent subviews]) {
//                        view.userInteractionEnabled  = YES;
//                    }
//                }

                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(removeSelf) userInfo:nil repeats:NO];
            }];
            
            
        }];

    }
    
    
    
}
-(void)removeSelf{
    [self removeAllSubviews];
    [self removeFromSuperview];
}
//各平台按钮点击点击后的事件
-(void)shareBtnAction:(UIButton *)btn{
    
    if (self.model.img.length>0) {
        if ([self.model.img.lowercaseString hasPrefix:@"http:"]) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.img]]];
            if (image) {
                //                NSLog(@"hhhhhvvvvvvvvvvvvvvvhhhhhh%@",self.model.img);
               
//                publishImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.img]]];
                publishImage = [image rescaleImageToSize:CGSizeMake(240, 180)];
              
            }else{
                if(self.type == IMAGE){
                    publishImage = [UIImage imageNamed:@"默认图片@3x.png"];
       
                    
                }else{
       
                    publishImage = [UIImage imageNamed:@"默认图片@2x.png"];
                    
                }
            }
            
        }else
        {
            
            NSString *imagePath = kPathOfMainBundle(self.model.img);
            publishImage = [[UIImage alloc]initWithContentsOfFile:imagePath];
            
        }
    }else if (self.model.imgPath.length>0){
        
        publishImage = [[UIImage alloc]initWithContentsOfFile:self.model.imgPath];
        
    }else{
        
        publishImage = [[UIImage alloc]initWithContentsOfFile:LOGO];
        
    }
    
    
    NSString *title = nil;
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];

    switch (btn.tag-1000) {
            /**
             *  微信
             */
        case 0:
        {
//            a)	【楼盘名称】#区县-商圈#，均价#xxxx元/平#，#面积区间#平，#户型区间#，#xx#万起。
//            例句：【国风美唐三期】昌平-回龙观，均价8900元/平，70-90平，1-3居，234万起。


   
            if (self.type == BUILDING) {
                [MobClick event:@"lpxq_weixin"];
//                if (self.model.housePrice.intValue<=0) {
//                    title = [NSString stringWithFormat:@"[%@] %@-%@  售价待定",self.model.buildingName,self.model.district,self.model.plate];
//                    
//                }else{
//                    title = [NSString stringWithFormat:@"[%@]%@元/平米",self.model.buildingName,self.model.housePrice];
//                }
                
                title = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice];
                
                if(self.model.content.length>140){
                    self.model.content =  [self.model.content substringWithRange:NSMakeRange(0, 140)];
                    
                }else if (self.model.content.length==0){
                    
                    self.model.content = @".";
                }
            }
            DLog(@">>>>>>>>-------====>>>>   %@    %@   %@   %@  ",self.model.content,title,self.model.img,self.model.title);
            
            [shareParams SSDKSetupShareParamsByText:self.model.content
                                             images:self.type == WORKREPORT?publishImage:((self.type == IMAGE || self.type == CONTENTOPERATE || self.type == WEBOPERATE)?[self changeImageUrlWithUrl:self.model.img]:self.type == BUILDING?self.model.img:[UIImage imageNamed:@"sharelogo.png" ])
                                                url:self.type == IMAGE?nil:[NSURL URLWithString:self.model.linkUrl]
                                                title:self.type == BUILDING?title:self.model.title
                                               type:(self.type == IMAGE||self.type == WORKREPORT)?SSDKContentTypeImage:SSDKContentTypeWebPage];
            
            
            
            [ShareSDK share:SSDKPlatformSubTypeWechatSession
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [MobClick event:@"lpxq_wxfxcg"];

//                         [alertView show];
                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
//                         [alertView show];
                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
//                         [alertView show];
                         [self hidActionSheet];

                         break;
                     }
                     default:
                         break;
                 }
             }];
            
            
            
        }
            break;
            /**
             *  朋友圈
             */
        case 1:
        {
            if (self.type == BUILDING) {
                [MobClick event:@"lpxq_wxquan"];
                
                if (self.model.buildingSellPoint.length > 0) {
                    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc]init];
                    [alertView setContainerView:[self alertContentView]];
                    [alertView setButtonTitles:@[@"不分享了",@"去粘贴"]];
                    [alertView setDelegate:self];
                    [alertView show];
                    
                    [self hidActionSheet];

                    return;
                    
                }
//                1.	朋友圈，分享格式：
//                a)	【楼盘名称】#区县-商圈#，均价#xxxx元/平#，#面积区间#平，#户型区间#，#xx#万起。例句：【国风美唐三期】昌平-回龙观，均价8900元/平，70-90平，1-3居，234万起。

//                if (self.model.housePrice.intValue<=0) {
//                    title = [NSString stringWithFormat:@"[%@]售价待定",self.model.buildingName];
//                    
//                }else{
//                    title = [NSString stringWithFormat:@"[%@]%@元/平米",self.model.buildingName,self.model.housePrice];
//                    
//                }
                title = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice];

                
                
                if(self.model.content.length>140){
                    self.model.content =  [self.model.content substringWithRange:NSMakeRange(0, 140)];
                    
                }
                
            }
            
            [shareParams SSDKSetupShareParamsByText:self.model.content
                                             images:(self.type == IMAGE || self.type == CONTENTOPERATE || self.type == WEBOPERATE)?[self changeImageUrlWithUrl:self.model.img]:self.type == BUILDING?self.model.img:[UIImage imageNamed:@"sharelogo.png" ]
                                                url:self.type == IMAGE?nil:[NSURL URLWithString:self.model.linkUrl]
                                              title:self.type == BUILDING?title:self.model.title
                                               type:self.type == IMAGE?SSDKContentTypeImage:SSDKContentTypeWebPage];
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [MobClick event:@"lpxq_wxqfxcg"];
                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         
                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     default:
                         break;
                 }
             }];
            
            
            
            
            
        }
            break;
        case 3:
        {///微博
            NSString *content = nil;
            if (self.type == BUILDING) {
                [MobClick event:@"lpxq_weibo"];
//
                BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://wb788869518"]];
//                1.	新浪微博，分享格式：
//                a)	【楼盘名称】 #区县-商圈#，均价#xxxx元/平#，#面积区间#平，#户型区间#供选择，#xx#万起。感兴趣请联系#经纪人姓名#，电话#经纪人电话# 【魔售出品】#楼盘地址#
//                b)	例：【国风美唐二期】昌平-回龙观，均价8600元/平，90-150平，1-3居供选择，269万起。感兴趣请联系张懿儿，电话：137 3737 3737 【魔售出品】http://xxxx

                if (hadInstalledWeibo) {

                    content = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@ 感兴趣请联系%@ 电话:%@ 【魔售出品】",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice,self.model.agencyName,self.model.mobile];

                    
//                    AlertShow(@"安装微博了");
//                    if (self.model.housePrice.intValue<=0) {
//                        
//                        content = [NSString stringWithFormat:@"给您推荐一套好房，%@，位于%@-%@，售价待定，%@，多种户型选择。感兴趣请联系%@，电话%@ 【魔售出品】",self.model.buildingName,self.model.district,self.model.plate,self.model.acreageType,self.model.agencyName,self.model.mobile];
//                        
//                    }else{
//                        content = [NSString stringWithFormat:@"给您推荐一套好房，%@，位于%@-%@，均价%@元/平起，%@，多种户型选择。感兴趣请联系%@，电话%@ 【魔售出品】",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.agencyName,self.model.mobile];
//                    }

                }else{
                    
                      content = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@ 感兴趣请联系%@ 电话:%@ 【魔售出品",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice,self.model.agencyName,self.model.mobile];
////                    AlertShow(@"没有安装微博");
//                    if (self.model.housePrice.intValue<=0) {
//                        
//                        content = [NSString stringWithFormat:@"给您推荐一套好房，%@，位于%@-%@，售价待定，%@，多种户型选择。感兴趣请联系%@，电话%@ 【魔售出品】%@",self.model.buildingName,self.model.district,self.model.plate,self.model.acreageType,self.model.agencyName,self.model.mobile,self.model.linkUrl];
//                        
//                    }else{
//                        content = [NSString stringWithFormat:@"给您推荐一套好房，%@，位于%@-%@，均价%@元/平起，%@，多种户型选择。感兴趣请联系%@，电话%@ 【魔售出品】%@",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.agencyName,self.model.mobile,self.model.linkUrl];
//                    }

                }
                
                
            }else if (self.type == APP){
                content = @"我发现了一款不错的应用，分享给大家一起看看!";
            }else if (self.type == IMAGE){
                
                content = @"我发现了一个不错的楼盘，分享给大家一起看看!";
            }else if(self.type == CONTENTOPERATE){
                content = [self.model.title stringByAppendingString:self.model.linkUrl];
                self.model.title = @"";
            }else if (self.type == WEBOPERATE){
                content =_model.content.length <= 0?self.model.title:self.model.content;
                
            }
            
            BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://wb788869518"]];

            
            DLog(@"......>>>>>>>>______------>>>>>  %@    %@ %@",self.model.title,self.model.img,self.model.linkUrl);
            
            [shareParams SSDKSetupShareParamsByText:self.type != IMAGE?[NSString stringWithFormat:@"%@",content]:content
                                             images:(self.type == IMAGE || self.type == CONTENTOPERATE || self.type == BUILDING || (self.type == WEBOPERATE && _model.img.length > 0))?self.model.img:[UIImage imageNamed:@"sharelogo.png"]
                                                url:self.type == IMAGE?nil:[NSURL URLWithString:self.model.linkUrl]
                                              title:self.type == BUILDING?content:self.model.title
                                               type:(self.type == CONTENTOPERATE)?SSDKContentTypeImage:(self.type == IMAGE?SSDKContentTypeImage:hadInstalledWeibo?SSDKContentTypeWebPage:SSDKContentTypeText)];
            [ShareSDK share:SSDKPlatformTypeSinaWeibo
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [MobClick event:@"lpxq_wbfxcg"];

                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     default:
                         break;
                 }
             }];
            
        }
            break;
            /**
             *  QQ
             */
        case 2:
        {
            //             NSString* title = nil;
//            1.	QQ好友，分享格式：
//            a)	【楼盘名称】区域-商圈 户型（室厅） 面积（面积区间，直接取最小值和最大值，不要多个区间） 最低总价（x万起） ，例：【国风美唐三期】昌平-回龙观 2室2厅88-120平 269万起

            if (self.type == BUILDING) {
                [MobClick event:@"lpxq_qqfx"];
                
//                if (self.model.housePrice.intValue<=0) {
//                    title = [NSString stringWithFormat:@"[%@]售价待定",self.model.buildingName];
//                    
//                }else{
//                    title = [NSString stringWithFormat:@"[%@]%@元/平米",self.model.buildingName,self.model.housePrice];
//                    
//                }
                title = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice];

                
                if(self.model.content.length>140){
                    self.model.content =  [self.model.content substringWithRange:NSMakeRange(0, 140)];
                    
                }
                
            }
            
            if (self.type == CONTENTOPERATE) {
                if (_model.content.length > 140) {
                    _model.content = [self.model.content substringWithRange:NSMakeRange(0, 140)];
                }
            }
            
            
            [shareParams SSDKSetupShareParamsByText:self.model.content
                                             images:self.type ==WORKREPORT?publishImage: ((self.type == IMAGE || self.type == CONTENTOPERATE)?publishImage:(self.type == BUILDING)?[self changeImageUrlWithUrl:self.model.img]:[UIImage imageNamed:@"sharelogo.png" ])
                                                url:self.type == IMAGE?nil:[NSURL URLWithString:self.model.linkUrl]
                                              title:self.type == BUILDING?title:self.model.title
                                               type:(self.type == IMAGE||self.type == WORKREPORT)?SSDKContentTypeImage:SSDKContentTypeWebPage];
            [ShareSDK share:SSDKPlatformSubTypeQQFriend
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [MobClick event:@"lpxq_qqfxcg"];
//                         [alertView show];

                         [self hidActionSheet];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
//                         [alertView show];

                         [self hidActionSheet];

                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
//                         [alertView show];
                         [self hidActionSheet];

                         break;
                     }
                     default:
                         break;
                 }
             }];
            
            
        }
            break;
            /**
             *  信息
             */
        case 4:
            
        {
            
            [self hidActionSheet];
            NSString* content = nil;
            if(self.type == IMAGE){
                content = self.model.img;
                //                content = self.model.content;
            }else if (self.type == BUILDING){
                [MobClick event:@"lpxq_duanxin"];

//                a)	【楼盘名称】 #区县-商圈#，均价#xxxx元/平#，#面积区间#平，#户型区间#供选择，#xx#万起。【魔售出品】#楼盘地址#

                content = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@【魔售出品】%@",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice,self.model.linkUrl];

//                if (self.model.housePrice.intValue<=0) {
//                    
//                    content = [NSString stringWithFormat:@"%@，位于%@-%@，售价待定，%@，多种户型选择。【魔售出品】 %@。",self.model.buildingName,self.model.district,self.model.plate,self.model.acreageType,self.model.linkUrl];
//                }else{
//                    
//                    content = [NSString stringWithFormat:@"%@，位于%@-%@，均价%@元/平起，%@，多种户型选择。【魔售出品】%@。",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.linkUrl];
//                }
                
            }else if(self.type == WORKREPORT){
                content = self.model.content;
            }
            else if(self.type == CONTENTOPERATE)
            {
               
                 content = [NSString stringWithFormat:@"[%@]%@ ",self.model.title,self.model.linkUrl];
                
            }else{
            
             content = self.model.content&&self.model.linkUrl.length>0?[NSString stringWithFormat:@"%@,点击链接即可加入%@",self.model.content,self.model.linkUrl]: [NSString stringWithFormat:@"%@,%@",CONTENT,@""];
            
            }
            
            if (self.type == WEBOPERATE) {
                self.model.title = [NSString stringWithFormat:@"%@ %@",_model.title,_model.linkUrl];
            }
            
            
            //显示分享菜单
            [shareParams SSDKSetupShareParamsByText:content
                                             images:nil
                                                url:nil
                                              title:self.model.title
                                               type:SSDKContentTypeText];
            [ShareSDK share:SSDKPlatformTypeSMS
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];

                         [self hidActionSheet];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];

                         [self hidActionSheet];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];

                         [self hidActionSheet];
                         break;
                     }
                     default:
                         break;
                 }
             }];
            
            
        }
            break;
        default:
            break;
    }
    
}
-(instancetype)initWithShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent{
    
    if (self= [super init]) {
        if (type) {
            self.type = type;
        }else{
            self.type = APP;
            
        }
        if (model) {
            
            self.model = model;
        }else{
            
            self.model = [[ShareModel alloc]init];
        }
        textArr = [NSArray arrayWithObjects:@"微信",@"朋友圈",@"QQ",@"微博",@"信息", nil];
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        maskView = [[UIView alloc]init];
        maskView.frame = self.frame;
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        [self addSubview:maskView];
        UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidActionSheet)];
        masktap.delegate = self;
        masktap. cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:masktap];
        
        actionSheetView = [[UIView alloc]init];
        [actionSheetView setFrame:CGRectMake(0,kMainScreenHeight-224, kMainScreenWidth, 224)];
        actionSheetView.backgroundColor = [UIColor whiteColor];
        [self addSubview:actionSheetView];
        
        UILabel *titleLabel = [UILabel createLabelWithFrame:CGRectMake(0, 20, kMainScreenWidth, 16) text:@"分享" textAlignment:NSTextAlignmentCenter fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [actionSheetView addSubview:titleLabel];
        
//        UILabel *secontTitleLabel = [UILabel createLabelWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, 13) text:@"分享给客户不显示带看规则和佣金" textAlignment:NSTextAlignmentCenter fontSize:12.f textColor:UIColorFromRGB(0x888888)];
//        [actionSheetView addSubview:secontTitleLabel];
        
        
        cancelBtn =[[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [cancelBtn setFrame:CGRectMake((kMainScreenWidth-190*SCALE6)/2,kFrame_Height(actionSheetView)-35-20, 190*SCALE6,35)];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidActionSheet) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        cancelBtn.layer.borderWidth = 1.f;
        cancelBtn.layer.cornerRadius = 4;
        [actionSheetView   addSubview: cancelBtn];
        
        shareBG = [[UIView alloc]init];
        [shareBG setFrame:CGRectMake(0,50, kMainScreenWidth, actionSheetView.height-70-35-20)];
        [shareBG setBackgroundColor:[UIColor clearColor]];
        shareBG.layer.cornerRadius = 8;
        shareBG.layer.masksToBounds = YES;
        
        [actionSheetView addSubview:shareBG];
        CGFloat width = ((kMainScreenWidth-10-25)-(10+25))/4;
        UILabel *title = nil;
        for (int i=0; i<5; i++) {
            UIButton *shareBtn = nil;
            if (self.type == BUILDING) {
               shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];

            }else{
                shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];

            }
            [shareBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareicon_%d",i]] forState:UIControlStateNormal];
            shareBtn.centerX = 35+width*i;
            
            [shareBtn setTag:1000+i];
            [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareBG addSubview:shareBtn];
            
            title = [[UILabel alloc]init];
            [title setText:[textArr objectForIndex:i]];
            [title setTextColor:NAVIGATIONTITLE];
            [title setFont:[UIFont systemFontOfSize:11]];
            CGSize textSize =[HMTool getTextSizeWithText:title.text andFontSize:11];
            [title setSize:textSize];
            [title setCenterY:kFrame_YHeight(shareBtn)+10+textSize.height/2];
            [title setCenterX:shareBtn.centerX];
            [shareBG addSubview:title];
        }
        
       
        if (self.type == BUILDING) {
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(title), kFrame_Width(shareBG), kFrame_Height(shareBG)-kFrame_YHeight(title))];
            [tip  setFont:[UIFont systemFontOfSize:11]];
            [tip setText:@"楼盘分享到微信、朋友圈，可直接粘贴楼盘卖点"];
            tip.textAlignment = NSTextAlignmentCenter;
            CGSize tipSize =[HMTool getTextSizeWithText:tip.text andFontSize:11];
            [tip setFrame:CGRectMake(0, kFrame_YHeight(title)+10, kFrame_Width(shareBG), tipSize.height)];
            [shareBG addSubview:tip];
        }
        
        self.parent = parent;
        [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        [self showActionSheet];
    }
    
    return self;
    
}

- (instancetype)initContentOperateWithShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent{
    if (self= [super init]) {
        if (model) {
            self.type = type;
            self.model = model;
        }else{
            
            self.model = [[ShareModel alloc]init];
        }
        textArr = [NSArray arrayWithObjects:@"微信",@"朋友圈",@"QQ",@"微博", nil];
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        maskView = [[UIView alloc]init];
        maskView.frame = self.frame;
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        [self addSubview:maskView];
        UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidActionSheet)];
        masktap.delegate = self;
        masktap. cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:masktap];
        
        actionSheetView = [[UIView alloc]init];
        [actionSheetView setFrame:CGRectMake(0,kMainScreenHeight-224, kMainScreenWidth, 224)];
        actionSheetView.backgroundColor = [UIColor whiteColor];
        [self addSubview:actionSheetView];
        
        UILabel *titleLabel = [UILabel createLabelWithFrame:CGRectMake(0, 20, kMainScreenWidth, 16) text:@"分享" textAlignment:NSTextAlignmentCenter fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [actionSheetView addSubview:titleLabel];
        
//        UILabel *secontTitleLabel = [UILabel createLabelWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, 13) text:@"分享给客户不显示带看规则和佣金" textAlignment:NSTextAlignmentCenter fontSize:12.f textColor:UIColorFromRGB(0x888888)];
//        [actionSheetView addSubview:secontTitleLabel];
//        
        
        cancelBtn =[[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [cancelBtn setFrame:CGRectMake((kMainScreenWidth-190*SCALE6)/2,kFrame_Height(actionSheetView)-35-20, 190*SCALE6,35)];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidActionSheet) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        cancelBtn.layer.borderWidth = 1.f;
        cancelBtn.layer.cornerRadius = 4;
        [actionSheetView   addSubview: cancelBtn];
        
        shareBG = [[UIView alloc]init];
        [shareBG setFrame:CGRectMake(0,50, kMainScreenWidth, actionSheetView.height-70-35-20)];
        [shareBG setBackgroundColor:[UIColor clearColor]];
        shareBG.layer.cornerRadius = 8;
        shareBG.layer.masksToBounds = YES;
        
        [actionSheetView addSubview:shareBG];
        CGFloat width = ((kMainScreenWidth-10-25)-(10+25))/4;
        UILabel *title = nil;
        for (int i=0; i<4; i++) {
            UIButton *shareBtn = nil;
            shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
            [shareBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"shareicon_%d",i]] forState:UIControlStateNormal];
            shareBtn.centerX = 35+width*i;
            
            [shareBtn setTag:1000+i];
            [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareBG addSubview:shareBtn];
            
            title = [[UILabel alloc]init];
            [title setText:[textArr objectForIndex:i]];
            [title setTextColor:NAVIGATIONTITLE];
            [title setFont:[UIFont systemFontOfSize:11]];
            CGSize textSize =[HMTool getTextSizeWithText:title.text andFontSize:11];
            [title setSize:textSize];
            [title setCenterY:kFrame_YHeight(shareBtn)+10+textSize.height/2];
            [title setCenterX:shareBtn.centerX];
            [shareBG addSubview:title];
        }
        
        self.parent = parent;
        [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        [self showActionSheet];
    }
    
    return self;
    
}


-(NSString*)changeImageUrlWithUrl:(NSString*)url{
    NSString *changedUrl =[[NSString alloc]init];
    NSArray *array = [url componentsSeparatedByString:@"_"];
    NSString *lastStr=[url pathExtension];
    changedUrl = [NSString stringWithFormat:@"%@_240x180.%@",array[0],lastStr];
    
    return changedUrl;
}


-(instancetype)initAutoShareViewWithShareRange:(NSMutableArray *)shareArray ShareType:(SHARETYPE)type andModel:(ShareModel *)model andParent:(UIView *)parent;
{
    
    self = [super init];
    if (self) {
        
        if (type) {
            self.type = type;
        }else{
            self.type = APP;
            
        }
        if (model) {
            
            self.model = model;
        }else{
            
            self.model = [[ShareModel alloc]init];
        }

        textArr = shareArray;
        self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        maskView = [[UIView alloc]init];
        maskView.frame = self.frame;
        [maskView setBackgroundColor:[UIColor blackColor]];
        [maskView setAlpha:0.2];
        [self addSubview:maskView];
        UITapGestureRecognizer *masktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidActionSheet)];
        masktap.delegate = self;
        masktap. cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:masktap];
        
        actionSheetView = [[UIView alloc]init];
        [actionSheetView setFrame:CGRectMake(0,kMainScreenHeight-224, kMainScreenWidth, 224)];
        actionSheetView.backgroundColor = [UIColor whiteColor];
        [self addSubview:actionSheetView];
        
        UILabel *titleLabel = [UILabel createLabelWithFrame:CGRectMake(0, 20, kMainScreenWidth, 16) text:@"分享" textAlignment:NSTextAlignmentCenter fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [actionSheetView addSubview:titleLabel];
        
        if (self.type == BUILDING) {
            UILabel *secontTitleLabel = [UILabel createLabelWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, 13) text:@"分享给客户不显示带看规则和佣金" textAlignment:NSTextAlignmentCenter fontSize:12.f textColor:UIColorFromRGB(0x888888)];
            [actionSheetView addSubview:secontTitleLabel];

        }
        
        
        cancelBtn =[[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [cancelBtn setFrame:CGRectMake((kMainScreenWidth-190*SCALE6)/2,kFrame_Height(actionSheetView)-35-20, 190*SCALE6,35)];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hidActionSheet) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        cancelBtn.layer.borderWidth = 1.f;
        cancelBtn.layer.cornerRadius = 4;
        [actionSheetView   addSubview: cancelBtn];
        
        shareBG = [[UIView alloc]init];
        [shareBG setFrame:CGRectMake(0,50, kMainScreenWidth, actionSheetView.height-70-35-20)];
        [shareBG setBackgroundColor:[UIColor clearColor]];
        shareBG.layer.cornerRadius = 8;
        shareBG.layer.masksToBounds = YES;
        
        [actionSheetView addSubview:shareBG];
        
        CGFloat width = ((kMainScreenWidth-10-25)-(10+25))/4;
        UILabel *title = nil;
        for (int i=0; i<textArr.count; i++) {
            UIButton *shareBtn = nil;
            if (self.type == BUILDING) {
                shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
            }else{
                shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 50, 50)];
            }
            NSString *imageName;
            if ([textArr[i] isEqualToString:@"微信"]) {
                
                imageName = @"shareicon_0.png";
                
                [shareBtn setTag:1000];

            }else if ([textArr[i] isEqualToString:@"朋友圈"]){
                imageName = @"shareicon_1.png";
                [shareBtn setTag:1001];


            }else if ([textArr[i] isEqualToString:@"QQ"]){
                
                imageName = @"shareicon_2.png";
                [shareBtn setTag:1002];

            }else if ([textArr[i] isEqualToString:@"微博"]){
                imageName = @"shareicon_3.png";
                [shareBtn setTag:1003];

                
            }else if ([textArr[i] isEqualToString:@"信息"]){
                [shareBtn setTag:1004];

                imageName = @"shareicon_4.png";
            }
            
            [shareBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            shareBtn.centerX = 35+width*i;
            
            [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [shareBG addSubview:shareBtn];
            
            title = [[UILabel alloc]init];
            [title setText:[textArr objectForIndex:i]];
            [title setTextColor:NAVIGATIONTITLE];
            [title setFont:[UIFont systemFontOfSize:11]];
            CGSize textSize =[HMTool getTextSizeWithText:title.text andFontSize:11];
            [title setSize:textSize];
            [title setCenterY:kFrame_YHeight(shareBtn)+10+textSize.height/2];
            [title setCenterX:shareBtn.centerX];
            [shareBG addSubview:title];
        }
        
        self.parent = parent;
        [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
        [self showActionSheet];
        
    }
    
    
    return self;
    
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if (buttonIndex==1) {
       
        NSString *title = nil;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];

        //  a)	【楼盘名称】区域-商圈 户型（室厅） 面积（面积区间，直接取最小值和最大值，不要多个区间） 最低总价（x万起） ，例：【国风美唐三期】昌平-回龙观 2室2厅88-120平 269万起
//        if (self.model.housePrice.intValue<=0) {
//            title = [NSString stringWithFormat:@"[%@]售价待定",self.model.buildingName];
//        }else{
//            title = [NSString stringWithFormat:@"[%@]%@元/平米",self.model.buildingName,self.model.housePrice];
//        }
        title = [NSString stringWithFormat:@"[%@] %@-%@,均价:%@ %@ %@ %@ ",self.model.buildingName,self.model.district,self.model.plate,self.model.housePrice,self.model.acreageType,self.model.houseType,self.model.AllPrice];

        if(self.model.content.length>140){
            self.model.content =  [self.model.content substringWithRange:NSMakeRange(0, 140)];
        }
        
    [shareParams SSDKSetupShareParamsByText:self.model.content
                                     images:(self.type == IMAGE || self.type == CONTENTOPERATE || self.type == WEBOPERATE)?[self changeImageUrlWithUrl:self.model.img]:self.type == BUILDING?self.model.img:[UIImage imageNamed:@"sharelogo.png" ]
                                        url:self.type == IMAGE?nil:[NSURL URLWithString:self.model.linkUrl]
                                      title:self.type == BUILDING?title:self.model.title
                                       type:self.type == IMAGE?SSDKContentTypeImage:SSDKContentTypeWebPage];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [MobClick event:@"lpxq_wxqfxcg"];
                 [alertView show];
                 
                 [self hidActionSheet];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 
                 [alertView show];
                 
                 [self hidActionSheet];
                 
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 
                 [self hidActionSheet];
                 
                 break;
             }
             default:
                 break;
         }
     }];
    

    
    }

    [alertView close];


}


-(UIView *)alertContentView
{
    
    UIView *alertContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-80, 60)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertContentView.width, 44)];
    titleLabel.text = @"文案已帮你写好,粘贴分享";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x888888);
    titleLabel.font = FONT(16.f);
    
    [alertContentView addSubview:titleLabel];
    
    UILabel *messageOne = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom, alertContentView.width-40, 40)];
    messageOne.text = self.model.buildingSellPoint;
    messageOne.textAlignment = NSTextAlignmentCenter;
    messageOne.font = FONT(14.f);
    messageOne.numberOfLines = 0;
    messageOne.textColor = UIColorFromRGB(0x333333);
    
    [alertContentView addSubview:messageOne];
    
    CGSize size = [messageOne boundingRectWithSize:CGSizeMake(alertContentView.width, 0)];
    
    messageOne.height = size.height;
    
    alertContentView.height = messageOne.height+titleLabel.height;
    if (alertContentView.height<=60+20) {
        alertContentView.height = 60+20;
    }
    
    return alertContentView;
    
}





@end

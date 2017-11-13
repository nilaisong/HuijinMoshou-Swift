//
//  CustomerBaseBuildView.h
//  MoShouBroker
//  创建带有指示箭头的view
//  Created by wangzz on 15/7/10.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerBaseBuildView : UIView

@property (nonatomic,copy) NSString *buildTitle;//功能名称
@property (nonatomic,copy) NSString *imageName;//功能图片
@property (nonatomic,copy) NSString *btnImgName;//箭头图片

-(id)initWithFrame:(CGRect)frame Title:(NSString *)Title AndImageName:(NSString *)ImageName AndBtnImgView:(NSString*)BtnImgView WithToBeUsed:(NSInteger)BToBeUsed;
-(void)changeBtnImage:(NSString*)BtnImg;

@end

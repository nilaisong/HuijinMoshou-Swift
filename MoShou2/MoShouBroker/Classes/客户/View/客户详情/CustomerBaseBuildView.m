//
//  CustomerBaseBuildView.m
//  MoShouBroker
//
//  Created by wangzz on 15/7/10.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "CustomerBaseBuildView.h"

@interface CustomerBaseBuildView ()

@property (nonatomic, retain) UIImageView *btnImgView;
@property (nonatomic, assign) CGRect      imgViewFrame;
@property (nonatomic, assign) CGRect      btnImgViewFrame;
@property (nonatomic, assign) CGRect      titleFrame;
@property (nonatomic, assign) NSInteger   labelFontSize;
@property (nonatomic, retain) UIColor     *textColor;

@end

@implementation CustomerBaseBuildView
@synthesize btnImgView;
@synthesize imgViewFrame;
@synthesize btnImgViewFrame;
@synthesize titleFrame;
@synthesize textColor;

-(id)initWithFrame:(CGRect)frame Title:(NSString *)Title AndImageName:(NSString *)ImageName AndBtnImgView:(NSString*)BtnImgView WithToBeUsed:(NSInteger)BToBeUsed
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.buildTitle = Title;
        self.imageName = ImageName;
        self.btnImgName = BtnImgView;
        self.labelFontSize = 17.f;
        textColor = stringColor;
        switch (BToBeUsed) {
            case 0://增加、报备新客户按钮，向右指示箭头
            {
                imgViewFrame = CGRectMake(10, 12, 20, 20);
                btnImgViewFrame = CGRectMake(kMainScreenWidth - 20, 15, 8, 14);
                titleFrame = CGRectMake(CGRectGetMaxX(imgViewFrame)+5, 7, kMainScreenWidth - 150, 30);
            }
                break;
            case 1://客户详情页的报备楼盘按钮和从通讯录添加按钮，向右指示箭头，功能图片比0状态缩进8像素
            {
                imgViewFrame = CGRectMake(15, 12, 20, 20);
                btnImgViewFrame = CGRectMake(kMainScreenWidth - 28, 15, 9, 14);
                titleFrame = CGRectMake(CGRectGetMaxX(imgViewFrame)+5, 7, kMainScreenWidth - 150, 30);
            }
                break;
            case 2://客户详情页的客户跟进信息按钮，向下指示箭头
            {
                imgViewFrame = CGRectMake(15, 12, 14, 20);
                btnImgViewFrame = CGRectMake(kMainScreenWidth - 32, 18, 16, 8);
                titleFrame = CGRectMake(CGRectGetMaxX(imgViewFrame)+5, 7, kMainScreenWidth - 150, 30);
                textColor = [UIColor colorWithHexString:@"4c4b4b"];
            }
                break;
            case 3://客户详情页的报备跟进信息，向下指示箭头，图片和字体比3状态小
            {
//                imgViewFrame = CGRectMake(15, 7, 12, 16);
                btnImgViewFrame = CGRectMake(kMainScreenWidth - 10-10, 19, 10, 16);
                titleFrame = CGRectMake(10, 12, kMainScreenWidth - 150, 30);
                self.labelFontSize = 15.f;
                textColor = NAVIGATIONTITLE;
            }
                break;
            case 4://客户详情页的报备跟进信息，向下指示箭头，图片和字体比3状态小
            {
//                imgViewFrame = CGRectMake(15, 7, 12, 16);
                btnImgViewFrame = CGRectMake(kMainScreenWidth - 15-8, 15, 8, 14);
                titleFrame = CGRectMake(15, 7, kMainScreenWidth - 150, 30);
                self.labelFontSize = 16.f;
                textColor = [UIColor colorWithHexString:@"4c4b4b"];
            }
                break;
            case 5://客户详情页的报备跟进信息，向下指示箭头，图片和字体比3状态小
            {
                //                imgViewFrame = CGRectMake(15, 7, 12, 16);
                btnImgViewFrame = CGRectMake(kMainScreenWidth - 15-8, 15, 8, 14);
                titleFrame = CGRectMake(15, 7, kMainScreenWidth - 100, 30);
                self.labelFontSize = 16.f;
                textColor = NAVIGATIONTITLE;
            }
                break;
            default:
                break;
        }
        [self loadFirstUI];
    }
    return self;
}

-(void)loadFirstUI
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imgViewFrame];
    imageView.image = [UIImage imageNamed:self.imageName];
    [self addSubview:imageView];
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:titleFrame];
    titlelabel.text = self.buildTitle;
    titlelabel.font = [UIFont systemFontOfSize:self.labelFontSize];
    titlelabel.textColor = textColor;
    [self addSubview:titlelabel];
    
    btnImgView = [[UIImageView alloc] initWithFrame:btnImgViewFrame];
    [btnImgView setImage:[UIImage imageNamed:self.btnImgName]];
    [self addSubview:btnImgView];
    
}

-(void)changeBtnImage:(NSString*)BtnImg
{
    [btnImgView setImage:[UIImage imageNamed:BtnImg]];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

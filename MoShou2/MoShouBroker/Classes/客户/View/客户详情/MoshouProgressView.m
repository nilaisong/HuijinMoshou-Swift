//
//  MoshouProgressView.m
//  MoShouBroker
//
//  Created by wangzz on 15/6/24.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "MoshouProgressView.h"
#import "OptionData.h"

@interface MoshouProgressView ()

//@property (nonatomic, assign) NSInteger lastStatus;
@property (nonatomic, assign) CGSize         size;//当前视图的宽高
@property (nonatomic, strong) UILabel        *statusLabel;//楼盘步骤名称
@property (nonatomic, strong) UILabel        *redBgLabel;//步骤红线
@property (nonatomic, strong) UIImageView    *imageView;//步骤节点
@property (nonatomic, strong) UILabel        *typeLabel;//状态名

@end
@implementation MoshouProgressView
//@synthesize lastStatus;
@synthesize size;
@synthesize statusLabel;
@synthesize redBgLabel;
@synthesize imageView;
@synthesize typeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        size = self.frame.size;
//        NSArray *statusTypeArray = @[@"确客",@"带看",@"成交",@"结佣"];
        UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(32, 40, size.width - 64, 4)];
        progressView.backgroundColor = CustomerBorderColor;
        [self addSubview:progressView];
        for (int i = 0; i<4; i++) {
            statusLabel = [[UILabel alloc]init];
            statusLabel.tag = 3131+i;
            statusLabel.textAlignment = NSTextAlignmentCenter;
            statusLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
            statusLabel.textColor = NAVIGATIONTITLE;
            [self addSubview:statusLabel];
            
            redBgLabel = [[UILabel alloc]init];
            redBgLabel.backgroundColor = [UIColor clearColor];
            redBgLabel.tag = 3101+i;
            [redBgLabel.layer setMasksToBounds:YES];
            [redBgLabel.layer setCornerRadius:4];
            [progressView addSubview:redBgLabel];
            
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25+i*(size.width - 64)/3, 35, 14, 14)];
            imageView.tag = 3111+i;
            [self addSubview:imageView];
            
            typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.left-10 , 59, size.width-(imageView.left-10), 21)];//[[UILabel alloc]initWithFrame:CGRectMake(10+i*(size.width - 60)/3, 59, (size.width - 60)/4, 21)];
            typeLabel.tag = 3121+i;
            typeLabel.backgroundColor = [UIColor clearColor];
            typeLabel.textAlignment = NSTextAlignmentLeft;
            typeLabel.font = [UIFont systemFontOfSize:12];
            [self addSubview:typeLabel];
            
            [statusLabel setFrame:CGRectMake(imageView.centerX-(size.width - 64)/4/2, 0, (size.width - 64)/4, 30)];
        }
        
    }
    return self;
}

- (void)setProgressDataSource:(ProgressStatus *)progressDataSource
{
    if (_progressDataSource != progressDataSource) {
        _progressDataSource = progressDataSource;
    }
    [self createProgressWithDataSource:(ProgressStatus*)progressDataSource];
}

- (void)createProgressWithDataSource:(ProgressStatus*)imgTypeInfo
{
    for (int i=0; i<4; i++) {
        statusLabel = (UILabel *)[self viewWithTag:3131+i];
        if (i==0) {
            statusLabel.text = imgTypeInfo.confirmText;
        }else if (i==1){
            statusLabel.text = imgTypeInfo.guideText;
        }else if (i==2){
            statusLabel.text = imgTypeInfo.successText;
        }else if (i==3){
            statusLabel.text = imgTypeInfo.commissionText;
        }
        redBgLabel = (UILabel *)[self viewWithTag:3101+i];
        imageView = (UIImageView *)[self viewWithTag:3111+i];
        typeLabel = (UILabel *)[self viewWithTag:3121+i];
        if ([imgTypeInfo.status integerValue]>i) {
            imageView.image  = [UIImage imageNamed:@"bluecircle-copy-2"];
            //全部显示
            //                if (i<3) {
            typeLabel.text = imgTypeInfo.statusText;
            typeLabel.textColor = BLUEBTBCOLOR;
            //                }
            if (i>0) {
                typeLabel = (UILabel *)[self viewWithTag:3121+i-1];
                typeLabel.text = @"";
            }
            redBgLabel.frame = CGRectMake(0, 0, (size.width - 60)/3*i, 4);
            redBgLabel.backgroundColor = BLUEBTBCOLOR;
        }else
        {
            imageView.image  = [UIImage imageNamed:@"gray-circle-6"];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

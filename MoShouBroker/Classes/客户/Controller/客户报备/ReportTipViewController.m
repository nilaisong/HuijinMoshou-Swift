//
//  ReportTipViewController.m
//  MoShou2
//
//  Created by wangzz on 15/12/9.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ReportTipViewController.h"
#import "FailListData.h"
#import "Customer.h"
#import "MobileVisible.h"
#import "CustomerBuilding.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BuildingDetailViewController.h"
#import "MyBuildingViewController.h"
#import "CompleteNumViewController.h"

@interface ReportTipViewController ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView   *scrollView;
@property (nonatomic, strong) UILabel *succLabel;
@property (nonatomic, strong) UILabel *failLabel;
@property (nonatomic, assign) BOOL    bIsShow;
@property (nonatomic, strong) NSMutableArray *completeArray;

@end

@implementation ReportTipViewController
@synthesize scrollView;
@synthesize succLabel;
@synthesize failLabel;
@synthesize completeArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"报备提示";
    _bIsShow = NO;
    completeArray = [[NSMutableArray alloc] init];
    [self reloadView];
    // Do any additional setup after loading the view.
}

- (void)reloadView
{
    NSArray *failArray = [[NSArray alloc] init];
    switch (_reportFailType) {
        case kfailCustomer:
        {
            failArray = _reportData.failCustomerList;
        }
            break;
        case kfailBuilding:
        {
            failArray = _reportData.failBuildingList;
        }
            break;
            
        default:
            break;
    }
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height - viewTopY)];
    scrollView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:scrollView];
    
    succLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 7, kMainScreenWidth-32, 30)];
    succLabel.text = [NSString stringWithFormat:@"%@ 个报备成功，请等待审核!",_reportData.successCount];
    succLabel.textColor = LABELCOLOR;
    succLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [scrollView addSubview:succLabel];
    
    [scrollView addSubview:[self createLineView:succLabel.bottom+7]];
    
    failLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, succLabel.bottom+14, kMainScreenWidth-32, 30)];
    failLabel.text = [NSString stringWithFormat:@"%ld 个报备失败，原因如下:",(long)failArray.count];
    failLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    failLabel.textColor = LABELCOLOR;
    [scrollView addSubview:failLabel];
    CGFloat height = failLabel.bottom+5;
    for (int i=0; i<failArray.count; i++) {
        FailListData *option = (FailListData*)[failArray objectForIndex:i];
        if ([option.reasonCode isEqualToString:@"7"]) {
            _bIsShow = YES;
            [completeArray appendObject:option];
        }
        CGSize strSize = [self textSize:@"楼盘名称" withConstraintWidth:120];
        UILabel *buildNameL = [[UILabel alloc] initWithFrame:CGRectMake(16, height, 120, strSize.height)];//failLabel.bottom+i*30
        buildNameL.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
        buildNameL.textColor = LABELCOLOR;
        [scrollView addSubview:buildNameL];
        
        UILabel *buildTelL = [[UILabel alloc] initWithFrame:CGRectMake(16, buildNameL.bottom, 120, strSize.height)];
        buildTelL.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
        buildTelL.textColor = LABELCOLOR;
        
        CGSize str2Size = [self textSize:option.reason withConstraintWidth:kMainScreenWidth-16-buildNameL.right];
        
        UILabel *failDesL = [[UILabel alloc] initWithFrame:CGRectMake(buildNameL.right, buildNameL.top, kMainScreenWidth-16-buildNameL.right, str2Size.height)];//failLabel.bottom+i*30
        failDesL.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
        failDesL.textColor = [UIColor colorWithHexString:@"f11718"];
        failDesL.text = option.reason;
        failDesL.adjustsFontSizeToFitWidth = YES;
        [failDesL setLineBreakMode:NSLineBreakByWordWrapping];
        [failDesL setNumberOfLines:0];
        [scrollView addSubview:failDesL];
        if (_reportFailType == kfailCustomer) {
            [scrollView addSubview:buildTelL];
            height+=MAX(failDesL.height, buildNameL.height+buildTelL.height)+8;
        }else
        {
            height+=MAX(failDesL.height, buildNameL.height)+8;
        }
        switch (_reportFailType) {
            case kfailCustomer:
            {
                if (_dataArray.count>0) {
                    for (Customer *cust in _dataArray) {
                        if ([cust.customerId isEqualToString:option.customerId]) {
                            buildNameL.text = cust.name;
                            buildTelL.text = cust.listPhone;
                        }
                    }
                }else
                {
                    buildNameL.text = option.name;
                    MobileVisible *mobile = (MobileVisible*)[option.phoneList objectForIndex:0];
                    buildTelL.text = mobile.hidingPhone;
                }
                
            }
                break;
            case kfailBuilding:
            {
                for (CustomerBuilding *build in _dataArray) {
                    if ([build.buildingId isEqualToString:option.buildingId]) {
                        buildNameL.text = build.buildingName;
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    [scrollView addSubview:[self createLineView:height]];
    
    UIButton *completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-70, height+50, 140, 40)];
    completeBtn.hidden = YES;
    [completeBtn setBackgroundColor:BLUEBTBCOLOR];
    [completeBtn.titleLabel setFont:FONT(14)];
    [completeBtn setTitle:@"去补全号码" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeBtn.layer setMasksToBounds:YES];
    [completeBtn.layer setCornerRadius:4.0];
    [completeBtn addTarget:self action:@selector(toggleCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:completeBtn];
    CGFloat closeHeight = height+50;
    if (_bIsShow) {
        completeBtn.hidden = NO;
        closeHeight = completeBtn.bottom+20;
    }
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-70, closeHeight, 140, 40)];
    [closeBtn setBackgroundColor:[UIColor whiteColor]];
    [closeBtn.titleLabel setFont:FONT(14)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:LABELCOLOR forState:UIControlStateNormal];
    [closeBtn.layer setMasksToBounds:YES];
    [closeBtn.layer setCornerRadius:4.0];
    [closeBtn.layer setBorderWidth:0.5];
    [closeBtn.layer setBorderColor:CustomerBorderColor.CGColor];
    [closeBtn addTarget:self action:@selector(toggleCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:closeBtn];
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, y, kMainScreenWidth-32, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    CGSize result;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGFloat width = contraintWidth;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        result = size;
        result.width = ceilf(result.width);
        result.height = ceilf(result.height);
    }
    else
    {
        result = [text sizeWithFont: font constrainedToSize: constraint];
    }
    return result;
}

- (void)toggleCompleteButton:(UIButton*)sender
{
    CompleteNumViewController *complete = [[CompleteNumViewController alloc] init];
    complete.completeData = completeArray;
    complete.buildingId = self.buildingId;
    complete.type = self.type;
    complete.custVisitDic = _custVisitDic;
    complete.confirmDic = _confirmDic;
    if (self.reportFailType == kfailBuilding) {
        complete.reportFailCompleteType = kfailCompleteBuilding;
    }else if (self.reportFailType == kfailCustomer)
    {
        complete.reportFailCompleteType = kfailCompleteCustomer;
    }
    
    [self.navigationController pushViewController:complete animated:YES];
}

- (void)toggleCloseButton:(UIButton *)sender
{
    switch (self.type) {
        case 1://楼盘列表
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 2://楼盘详情
        {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[BuildingDetailViewController class]]) {
                    // || [temp isKindOfClass:[XTUserScheduleViewController class]]
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
            break;
        case 3://我的收藏
        {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyBuildingViewController class]]) {
                    // || [temp isKindOfClass:[XTUserScheduleViewController class]]
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
            break;
            
        default:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PointMallViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "PointMallViewController.h"
#import "GoodsViewController.h"
#import "HMTool.h"
#import "ExchangeRecordsViewController.h"
#import "PointDetailsViewController.h"
#import "PointRulesViewController.h"
#import "UserData.h"
#import "DataFactory+User.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "ExchangeGoods.h"
#import "CustomerReportViewController.h"
#import "BaseNavigationController.h"
#import "MyImageView.h"
#import "ChangeShopViewController.h"
#import "DataFactory+Customer.h"
#import "NewAddressViewController.h"
@interface PointMallViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_signBtn;
    UILabel *_signedLabel;
    UITableView *_goodsTableView;
    UILabel *_plusLabel;
    UIView *_headView;
    UIButton *_detailBtn;
    UIButton *_ruleBtn;
    UIButton *_exchangBtn;
    UILabel *_point;
    UILabel *_title;
    MyImageView *_headImage;
    float _beginPosition;
    UIButton *selectedBtn;
    UITableView *selectedTableView;
    NSArray  *selectedArr;
    NSInteger seqType;
    UIView *_tableviewHeader;
    BOOL isfirstSelect;
    UIImageView *ruleIcon;
    NSString *addressId;

}

@property (nonatomic, assign) NSInteger  buttonTag;
@property(nonatomic,strong) UIView *blankView;
@end

@implementation PointMallViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    seqType = 0;
    [self getFirstPageData];

}
-(void)initUI{
    isfirstSelect = YES;
    self.navigationBar.barBackgroundImageView.hidden = NO;
    self.navigationBar.titleLabel.text = @"积分商城";
    self.navigationBar.leftBarButton.hidden = NO;
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 42)];
    [_headView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_headView];
    
    _title = [[UILabel alloc]init];
    [_title setText:@"我的积分"];
    [_title setFont:[UIFont systemFontOfSize:14]];
    CGSize nameSize = [HMTool getTextSizeWithText:_title.text andFontSize:14];
    [_title setFrame:CGRectMake(16,15, nameSize.width, nameSize.height)];
    _title.textColor = LABELCOLOR;
    [_title setCenterY:21.0];
    [_headView addSubview:_title];
    
    _point = [[UILabel alloc]init];
    [_point setFont:[UIFont systemFontOfSize:14]];
    [_point setText:[UserData sharedUserData].points];
    _point.textAlignment = NSTextAlignmentLeft;
    CGSize pointS = [HMTool getTextSizeWithText:_point.text andFontSize:14];
    _point.textColor = BLUEBTBCOLOR;
    [_headView addSubview:_point];

    
    UILabel *ruleTile = [[UILabel alloc]init];
    [ruleTile setText:@"积分规则"];
    [ruleTile setFont:[UIFont systemFontOfSize:14]];
    [ruleTile setTextColor:LABELCOLOR];
    ruleTile.userInteractionEnabled = YES;
    
    CGSize ruleS = [HMTool getTextSizeWithText:ruleTile.text andFontSize:14];
    [ruleTile setFrame:CGRectMake(kMainScreenWidth-16-ruleS.width, kFrame_Y(_title), ruleS.width, ruleS.height)];
    [_headView addSubview:ruleTile];
    
    ruleIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kFrame_X(ruleTile)-5-15, 21-7.5, 15, 15)];
    [ruleIcon setImage:[UIImage imageNamed:@"icon-wenhao"]];
    ruleIcon.userInteractionEnabled = YES;
    [_headView addSubview:ruleIcon];
    
        [_point setFrame:CGRectMake(_title.right+5, _title.top,ruleIcon.left-_title.right-10, pointS.height)];


    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapAction)];
    [ruleIcon addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTapAction)];
    [ruleTile addGestureRecognizer:tap2];

    _detailBtn = [self createRectBtnWithFrame:CGRectMake(0, kFrame_YHeight(_headView), kMainScreenWidth/3, 76) andBtnTag:1000];
    
    _ruleBtn =[self createRectBtnWithFrame:CGRectMake(kFrame_XWidth(_detailBtn), kFrame_Y(_detailBtn), kFrame_Width(_detailBtn), kFrame_Height(_detailBtn)) andBtnTag:1001];

    _signBtn =[self createRectBtnWithFrame:CGRectMake(kFrame_XWidth(_ruleBtn), kFrame_Y(_detailBtn), kFrame_Width(_detailBtn), kFrame_Height(_detailBtn)) andBtnTag:1002];
    selectedArr =[[NSArray alloc]initWithObjects:@"默认排序",@"积分由高到低",@"积分由低到高",@"我能兑换的商品", nil];

   _tableviewHeader  = [[UIView alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(_signBtn)+10, kMainScreenWidth, 44)];
    [self.view addSubview:_tableviewHeader];
        [_tableviewHeader setBackgroundColor:[UIColor whiteColor]];
        UILabel *title = [[UILabel alloc]init];
        [title setText: @"全部商品"];
        [title setFont:[UIFont systemFontOfSize:14]];
        CGSize titlesize = [title.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [title setFrame:CGRectMake(16, 15, titlesize.width, titlesize.height)];
        [title setTextColor:LABELCOLOR];
        [_tableviewHeader addSubview:title];
        
        CGSize btnsize = [@"默认排序" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        selectedBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-13-btnsize.width,15, btnsize.width, btnsize.height)];
        [selectedBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [selectedBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [selectedBtn setTitle:@"默认排序"forState:UIControlStateNormal];
        [selectedBtn addTarget:self action:@selector(selectedBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kFrame_Width(selectedBtn)+5,5, 13, 7)];
        [arrow setTag: 500];
        [arrow setImage:[UIImage imageNamed:@"blue_arrow_down"]];
        [selectedBtn addSubview:arrow];
    
        [_tableviewHeader addSubview:selectedBtn];
        
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    [line setBackgroundColor:LINECOLOR];
    [_tableviewHeader addSubview:line];
    UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(_tableviewHeader)-0.5, kMainScreenWidth, 0.5)];
    [line2 setBackgroundColor:LINECOLOR];
    [_tableviewHeader addSubview:line2];
    
    
    _goodsTableView = [[UITableView alloc]init];
    [_goodsTableView setFrame:CGRectMake(0, kFrame_YHeight(_tableviewHeader), kMainScreenWidth, self.view.bounds.size.height-(kFrame_YHeight(_detailBtn)+1))];
    [_goodsTableView setDelegate:self];
    [_goodsTableView setDataSource:self];
    [_goodsTableView setTag:1000];
    _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_goodsTableView];
    [self tempView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPoint) name:@"REFREShPOINT" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadListData) name:@"ReloadJifenList" object:nil];
    
    UIView *maskview = [[UIView alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(_tableviewHeader), kMainScreenWidth, kMainScreenHeight-kFrame_YHeight(_tableviewHeader))];
    [maskview setBackgroundColor:[UIColor blackColor]];
    maskview.alpha = 0.5;
    [maskview setTag: 5000];
    maskview.userInteractionEnabled = YES;
    [self.view addSubview:maskview];
    
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewDidClick)];
    [maskview addGestureRecognizer:tap3];
    [maskview setHidden:YES];
    
    
    selectedTableView = [[UITableView alloc]init];
    [selectedTableView setFrame:CGRectMake(0, kFrame_Y(_goodsTableView), kMainScreenWidth, 45*4)];
    [selectedTableView setDelegate:self];
    [selectedTableView setDataSource:self];
    [selectedTableView setTag:2000];
    [self.view addSubview:selectedTableView];
    [selectedTableView setHidden:YES];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1000) {
        float currentPostion = scrollView.contentOffset.y;
        if (currentPostion - _beginPosition > 10) {
            NSLog(@"ScrollUp now");
            //        _goodsTableView
            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_tableviewHeader setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth,44)];

                [_goodsTableView setFrame:CGRectMake(0, kFrame_YHeight(_tableviewHeader), kMainScreenWidth, kMainScreenHeight-kFrame_Height(self.navigationBar)-44)];
            } completion:^(BOOL finished) {
                [selectedTableView setFrame:CGRectMake(0, kFrame_Y(_goodsTableView), kMainScreenWidth, 45*4)];

            }];
            
            
        }
        
        else if (_beginPosition - currentPostion > 10)
        {
            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_tableviewHeader setFrame:CGRectMake(0, kFrame_YHeight(_detailBtn)+10, kMainScreenWidth,44)];

                [_goodsTableView setFrame:CGRectMake(0, kFrame_YHeight(_tableviewHeader), kMainScreenWidth, kMainScreenHeight-kFrame_Height(self.navigationBar))];
            } completion:^(BOOL finished) {
                [selectedTableView setFrame:CGRectMake(0, kFrame_Y(_goodsTableView), kMainScreenWidth, 45*4)];

            }];
            
        }

    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _beginPosition = scrollView.contentOffset.y;
    
    NSLog(@"scrollViewWillBeginDragging");
    
}
#pragma mark - 积分商城
-(void)refreshPoint{
    [_point setText:[UserData sharedUserData].points];
    
}
-(void)reloadListData
{

    [self getFirstPageData];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [_goodsTableView addLegendFooterWithRefreshingBlock:^{
        vc.page ++;
        [vc getMorePageDate];
    }];
}

-(void)segmentChange:(UIButton *)btn{
    
    if (btn.tag == 1000 ) {
        
        PointDetailsViewController *po =[[PointDetailsViewController alloc]init];
        [self.navigationController pushViewController:po animated:YES];
        
    }else if (btn.tag == 1001){
        ExchangeRecordsViewController *exc =[[ExchangeRecordsViewController alloc]init];
        [self.navigationController pushViewController:exc animated:YES];
//        PointRulesViewController *Poin =[[PointRulesViewController alloc]init];
//        [self.navigationController pushViewController:Poin animated:YES];
        
    }else if (btn.tag == 1002){
      
        _signBtn.userInteractionEnabled = NO;
        
        if (![self isBlankString:[UserData sharedUserData].storeNum]) {
            if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
                [[DataFactory sharedDataFactory]signWithCallback:^(ActionResult *result) {
                    if (result.success) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                        
                        [self signedAnimation];
                        _signBtn.userInteractionEnabled = YES;
                        
                    }else{
                        [TipsView showTips:result.message inView:self.view];
                        _signBtn.userInteractionEnabled = YES;
                        
                    }
                }];
                
            }
            
        }else{
            
            UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"对不起，您还没有绑定门店，请先到【个人信息】绑定门店。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定门店", nil];
            [av show];
            _signBtn.userInteractionEnabled = YES;
            
        }

    }
}
-(void)headViewTapAction{
    PointRulesViewController *po =[[PointRulesViewController alloc]init];
    [self.navigationController pushViewController:po animated:YES];


}
-(void)pointAllBtnClickedAction:(UIButton *)btn{
    if (btn.tag == POINTMALLSIGNTAG ) {
        _signBtn.userInteractionEnabled = NO;

        if (![self isBlankString:[UserData sharedUserData].storeNum]) {
            if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
                [[DataFactory sharedDataFactory]signWithCallback:^(ActionResult *result) {
                    if (result.success) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                        
                        [self signedAnimation];
                        _signBtn.userInteractionEnabled = YES;

                    }else{
                        [TipsView showTips:result.message inView:self.view];
                        _signBtn.userInteractionEnabled = YES;

                    }
                }];

            }
           
        }else{
        
            UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"对不起，您还没有绑定门店，请先到【个人信息】绑定门店。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定门店", nil];
            [av show];
            _signBtn.userInteractionEnabled = YES;

        }
           }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3001) {
        if (buttonIndex == 1) {
            ExchangeGoods *good =(ExchangeGoods*)[self.goodsListArr objectForIndex:_buttonTag];
            if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
                [[DataFactory sharedDataFactory]exchangeGoodsWith:good withAddress:addressId andCallback:^(ActionResult *result) {
                    if (result.success) {
                        [TipsView showTipsCantClick:@"申请兑换成功，请等待管理员操作。" inView:self.view];
                        [_point setText:[UserData sharedUserData].points];
                        [_goodsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_buttonTag inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
                        
                    }else{
                        [TipsView showTipsCantClick:result.message inView:self.view];
                    }
                }];
            }
        }
    }else if (alertView.tag == 3002)
    {
        if (buttonIndex == 1) {
            NewAddressViewController *newAddVC = [[NewAddressViewController alloc] init];
            newAddVC.addressType = kNewAddress;
//            __weak typeof(self) weakSelf = self;
            [newAddVC saveModifyAddressBlock:^{
                
            }];
            [self.navigationController pushViewController:newAddVC animated:YES];
        }
    }
    else {
        if (buttonIndex == 1) {
            ChangeShopViewController *changname =[[ChangeShopViewController alloc]init];
            [self.navigationController pushViewController:changname animated:YES];
        }
    }
}
//签到动画
-(void)signedAnimation{
    if(_plusLabel){
        [_plusLabel removeFromSuperview];
    }
    _plusLabel = [[UILabel alloc]init];
    [_plusLabel setText:@"+3"];
    [_plusLabel setFont:[UIFont systemFontOfSize:20]];
    [_plusLabel setTextColor:[UIColor colorWithHexString:@"fc6c33"]];
    CGSize size = [HMTool getTextSizeWithText:_plusLabel.text andFontSize:20];
    [_plusLabel setFrame:CGRectMake(_signBtn.centerX, _signBtn.centerY-size.height/2, size.width, size.height)];
    [self.view addSubview:_plusLabel];
    [UIView animateWithDuration:5 animations:^{
        CABasicAnimation *anima=[CABasicAnimation animation];
        anima.keyPath=@"position";
        anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(kFrame_X(_plusLabel) ,kFrame_Y(_plusLabel))];
    
        anima.toValue=[NSValue valueWithCGPoint:CGPointMake(kFrame_X(_plusLabel) ,kFrame_Y(_signBtn)-kFrame_Height(_signBtn)/2+20)];
        //1.2设置动画执行完毕之后不删除动画
        anima.removedOnCompletion=NO;
        //1.3设置保存动画的最新状态
        anima.fillMode=kCAFillModeForwards;
        
        //2.添加核心动画到layer
        [_plusLabel.layer addAnimation:anima forKey:nil];
    } completion:^(BOOL finished) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        _plusLabel.alpha =0.0;
        
        [UIView commitAnimations];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion:^(BOOL finished) {
            
            for (UILabel *title  in [_signBtn subviews]) {
                if (title.tag == 200) {
                    [title setHidden:YES];

                }
                if (title.tag == 300) {
                    [title setHidden:NO];

                }
            }
            _signBtn.userInteractionEnabled = NO;
            [_point setText:[UserData sharedUserData].points];


        }];
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        return self.goodsListArr.count;

    }else if (tableView.tag == 2000){
        return selectedArr.count;

    
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag ==1000) {
         return 105;
    }else if (tableView.tag == 2000){
        return 45;

    }
    return 1;

}


-(void)selectedBtnClickAction:(UIButton*)button{

    if (!button.selected) {
        button.selected = YES;
        for (UIView *view in [self.view subviews]) {
            if (view.tag == 5000) {
                [self.view bringSubviewToFront:view];
                [view setHidden:NO];
                [self.view bringSubviewToFront:selectedTableView];
                
            }
        }
        
        //    [self.view bringSubviewToFront:selectedTableView];
        [selectedTableView setHidden:NO];
        
        for (UIImageView *image in [button subviews]) {
            if (image.tag == 500) {
                [image setImage:[UIImage imageNamed:@"blue_arrow_up"]];
            }
        }
    }else
    {
        button.selected = NO;
        [selectedTableView setHidden:YES];
        
        for (UIImageView *image in [button subviews]) {
            if (image.tag == 500) {
                [image setImage:[UIImage imageNamed:@"blue_arrow_down"]];
//                [image setFrame:CGRectMake(kFrame_Width(selectedBtn)+5,5, 13, 7)];
            }
        }
        for (UIView *view in [self.view subviews]) {
            if (view.tag ==5000) {
                
                [view setHidden:YES];
                
            }
        }
    }

}
-(void)maskViewDidClick{
    for (UIView *view in [self.view subviews]) {
        if (view.tag ==5000) {
            selectedBtn.selected = NO;//add by wangzz 160721
            [selectedTableView setHidden:YES];
            for (UIImageView *image in [selectedBtn subviews]) {
                if (image.tag == 500) {
                    [image setImage:[UIImage imageNamed:@"blue_arrow_down"]];
                    [image setFrame:CGRectMake(kFrame_Width(selectedBtn)+5,5, 13, 7)];
                }
            }
            [view setHidden:YES];
            
        }
    }
}
//列表信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(tableView.tag ==1000){
        ExchangeGoods *goods =(ExchangeGoods *)[self.goodsListArr objectForIndex:indexPath.row];
        if (goods) {
            MyImageView *goodImage =[[MyImageView alloc]initWithFrame:CGRectMake(10, 15, 100, 75)];
            [goodImage setImageWithUrlString:goods.thmUrl placeholderImage:[UIImage imageNamed:@"默认图片"]];
            [cell addSubview:goodImage];
            
            UILabel *title = [[UILabel alloc]init];
            [title setFont:[UIFont systemFontOfSize:16]];
            [title setTextColor:NAVIGATIONTITLE];
            [title setText:goods.goodsName];
            CGSize titleSize =[HMTool getTextSizeWithText:title.text andFontSize:16];
            [title setFrame:CGRectMake(kFrame_XWidth(goodImage)+15, 15, titleSize.width, titleSize.height)];
            [cell addSubview:title];
            
            if(titleSize.width>kMainScreenWidth-kFrame_X(title)-10){
                [title setFrame:CGRectMake(kFrame_XWidth(goodImage)+15, 15, kMainScreenWidth-kFrame_X(title)-10, titleSize.height)];
                
            }
            UILabel *numLabel = [[UILabel alloc]init];
            NSString *num = goods.convertPoints;
            if ([self isBlankString:num]) {
                num = @"0";
            }
            
            NSString *attriStr =[NSString stringWithFormat:@"%@ 积分",num];
            NSMutableAttributedString *attributeStr =[[NSMutableAttributedString alloc]initWithString:attriStr];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc6d33"] range:NSMakeRange(0,num.length)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8f8e93"] range:NSMakeRange(num.length, 3)];    //@"20000";
            [numLabel setFont:[UIFont systemFontOfSize:16]];
            CGSize numSize = [HMTool getTextSizeWithText:attriStr andFontSize:16];
            [numLabel setFrame:CGRectMake(kFrame_X(title), 105/2-numSize.height/2, numSize.width, numSize.height)];
            [numLabel setAttributedText:attributeStr];
            [cell addSubview:numLabel];
            
            UILabel *remainNumLB =[[UILabel alloc]init];
            NSString *remainNum =goods.availableNum;
            if ([self isBlankString:remainNum]) {
                remainNum = @"0";
            }
            NSString *remainStr =[NSString stringWithFormat:@"剩余 %@ 件",remainNum];
            NSMutableAttributedString *remainAttributeStr =[[NSMutableAttributedString alloc]initWithString:remainStr];
            [remainAttributeStr addAttribute:NSForegroundColorAttributeName value:POINTMALLGRAYLABELCOLOR range:NSMakeRange(0,2)];
            [remainAttributeStr addAttribute:NSForegroundColorAttributeName value:NAVIGATIONTITLE range:NSMakeRange(2, remainNum.length+3)];    //@"20000";
            [remainAttributeStr addAttribute:NSForegroundColorAttributeName value:POINTMALLGRAYLABELCOLOR range:NSMakeRange(remainNum.length+4, 1)];
            [remainNumLB setFont:[UIFont systemFontOfSize:14]];
            
            CGSize remainNumSize = [HMTool getTextSizeWithText:remainStr andFontSize:14];
            [remainNumLB setFrame:CGRectMake(kFrame_X(title), kFrame_YHeight(goodImage)-remainNumSize.height, remainNumSize.width, remainNumSize.height)];
            [remainNumLB setAttributedText:remainAttributeStr];
            [cell addSubview:remainNumLB];
            
            UIButton *getBtn =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-64, 105/2-25.5/2, 64, 25.5)];
            
            if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]<[[self timeToTimestampWithTimeStr:goods.activityTime]longLongValue]){
                [getBtn setBackgroundColor:LINECOLOR];
                
            }else if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]>[[self timeToTimestampWithTimeStr:goods.endTime]longLongValue]){
                [getBtn setBackgroundColor:LINECOLOR];
                
            }else if (goods.availableNum.intValue>0&&([UserData sharedUserData].points.integerValue < goods.convertPoints.intValue)) {
                
                [getBtn setBackgroundColor:LINECOLOR];
                
            }else if(goods.availableNum.intValue<=0&&([UserData sharedUserData].points.integerValue > goods.convertPoints.intValue)){
                [getBtn setBackgroundColor:LINECOLOR];
                
            }else{
                
                [getBtn setBackgroundColor:BLUEBTBCOLOR];
                
            }
            [getBtn setTitle:@"马上抢" forState:UIControlStateNormal];
            getBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            getBtn.layer.cornerRadius = 4;
            getBtn.layer.masksToBounds= YES;
            [getBtn setTag:indexPath.row];
            [getBtn addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:getBtn];
            UIView *line = [HMTool getLineWithFrame:CGRectMake(10, 104, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
            [cell addSubview:line];
            
            
        }

    
    }else if (tableView.tag == 2000){
        if (isfirstSelect) {
            if (indexPath.row == 0) {
                cell.textLabel.text = [selectedArr objectForIndex:indexPath.row];
                [cell.textLabel setTextColor:BLUEBTBCOLOR];
                [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                [cell setBackgroundColor:BACKGROUNDCOLOR];
            }else{
                cell.textLabel.text = [selectedArr objectForIndex:indexPath.row];
                [cell.textLabel setTextColor:LABELCOLOR];
                [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            }
            
        }else{
            cell.textLabel.text = [selectedArr objectForIndex:indexPath.row];
            [cell.textLabel setTextColor:LABELCOLOR];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        }
        
        　　tableView.separatorStyle = NO;
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5)];
        [line setBackgroundColor:LINECOLOR];
        [cell addSubview:line];

    }
    
    
    return cell;
    

}
-(NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];

    return locationString;

}
-(NSString *)timeToTimestampWithTimeStr:(NSString*)timeStr{

    NSString *timeSp =[[[timeStr stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@":" withString:@""];

    return  timeSp;
}
//兑换按钮
-(void)exchangeAction:(UIButton *)btn{
    //modify by wangzz 160729
    _buttonTag = btn.tag;
    ExchangeGoods *good =(ExchangeGoods*)[self.goodsListArr objectForIndex:_buttonTag];
    if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]<[[self timeToTimestampWithTimeStr:good.activityTime]longLongValue]){
        [TipsView showTipsCantClick:@"很抱歉活动未开始" inView:self.view];
        
    }else if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]>[[self timeToTimestampWithTimeStr:good.endTime]longLongValue]){
        [TipsView showTipsCantClick:@"很抱歉活动已结束" inView:self.view];
        
    }else if (good.availableNum.intValue>0&&([UserData sharedUserData].points.intValue < good.convertPoints.intValue)) {
        [TipsView showTipsCantClick:@"很抱歉积分不足" inView:self.view];
        
        
    }else if(good.availableNum.intValue<=0&&([UserData sharedUserData].points.intValue > good.convertPoints.intValue)){
        [TipsView showTipsCantClick:@"很抱歉库存不足" inView:self.view];
        
    }else {
        if (![self isBlankString:[UserData sharedUserData].addressId] && ![[UserData sharedUserData].addressId isEqualToString:@"0"]) {
            addressId = [UserData sharedUserData].addressId;
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"兑换提示" message:@"是否确认兑换该商品？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 3001;
            [alert show];
        }else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"兑换提示" message:@"请先到“我的→个人资料页”去填写收货地址，否则无法完成兑换。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去填写", nil];
            alert.tag = 3002;
            [alert show];

        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        GoodsViewController *good = [[GoodsViewController alloc]init];
        good.goods = (ExchangeGoods *)[self.goodsListArr objectForIndex:indexPath.row];
        [self.navigationController pushViewController:good animated:YES];
    }else if (tableView.tag == 2000){
        isfirstSelect = NO;
        selectedBtn.selected = NO;//add by wangzz 160721
        [selectedTableView setHidden:YES];
        for (UITableViewCell *cell in [tableView visibleCells]) {
            if ([cell isSelected]) {
                cell.textLabel.textColor = BLUEBTBCOLOR;
                [cell setBackgroundColor:BACKGROUNDCOLOR];
            }else{
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.textLabel.textColor = LABELCOLOR;

            }
        }
        CGSize btnsize = [[selectedArr objectForIndex:indexPath.row] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [selectedBtn setFrame:CGRectMake(kMainScreenWidth-16-13-btnsize.width,15, btnsize.width, btnsize.height)];
        [selectedBtn setTitle:[selectedArr objectForIndex:indexPath.row] forState:UIControlStateNormal];
        for (UIImageView *image in [selectedBtn subviews]) {
            if (image.tag == 500) {
                [image setImage:[UIImage imageNamed:@"blue_arrow_down"]];
                [image setFrame:CGRectMake(kFrame_Width(selectedBtn)+5,5, 13, 7)];
            }
        }
        for (UIView *view in [self.view subviews]) {
            if (view.tag ==5000) {
                
                [view setHidden:YES];
                
            }
        }
        seqType = indexPath.row;
        [self getFirstPageData];

    
    }
 
}
//创建中间三个按钮
-(UIButton *)createRectBtnWithFrame:(CGRect)rect andBtnTag:(NSInteger)tag{
    UIButton *view =[[UIButton alloc]initWithFrame:rect];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [LINECOLOR CGColor];
    view.layer.borderWidth = 0.5;
    
    [self.view addSubview:view];
     UILabel *title = [[UILabel alloc]init];
    [title setFont:[UIFont systemFontOfSize:12]];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    if (tag == 1000) {
        [image setImage:[UIImage imageNamed:@"icon-wenjian-"]];
        [title setText:@"积分明细"];

    }else if (tag == 1001){
        [image setImage:[UIImage imageNamed:@"icon-history"]];
        [title setText:@"兑换记录"];

    }else if (tag ==1002 ){
        if ([UserData sharedUserData].isSignIn) {
            [title setText:@"今日已签"];
                }else{
                    [title setText:@"签到"];
                    view.userInteractionEnabled = YES;

                }

        
        [image setImage:[UIImage imageNamed:@"iconfont-qiandao"]];
        UILabel *signedLabel =[[UILabel alloc]init];
        [signedLabel setText:@"今日已签"];
        [signedLabel setFont:[UIFont systemFontOfSize:12]];
        CGSize size = [HMTool getTextSizeWithText:signedLabel.text andFontSize:12];
        [signedLabel setFrame:CGRectMake(0, 0, size.width, size.height)];
        [signedLabel setCenter:CGPointMake(rect.size.width/2, rect.size.height/2+size.height/2+5)];
        [signedLabel setTextColor:LABELCOLOR];
        [signedLabel setTag:300];
        [signedLabel setHidden: YES];
        
        [view addSubview:signedLabel];
    }
    
    [image setCenter:CGPointMake(rect.size.width/2, rect.size.height/2-17/2)];
    [view addSubview:image];
    CGSize size = [HMTool getTextSizeWithText:title.text andFontSize:12];
    [title setFrame:CGRectMake(0, 0, size.width, size.height)];
    [title setCenter:CGPointMake(rect.size.width/2, rect.size.height/2+size.height/2+5)];
    [title setTextColor:LABELCOLOR];
    [title setTag:200];
    [view addSubview:title];

    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [view addSubview:btn];
    [btn setTag:tag];
    [btn addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventTouchUpInside];
    if (tag ==1002 ){
        
        if ([UserData sharedUserData].isSignIn) {
            btn.userInteractionEnabled = NO;
        }else{
            btn.userInteractionEnabled = YES;

        }
    }
   

    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)getFirstPageData{

    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView *loading = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]getPointMallByPage:[NSString stringWithFormat:@"%d",1] andSequenceType:            seqType andWithCallBack:^(GoodsResult *result) {

            self.page = 1;
            self.morePage = result.morePage;
            [self addFooter];

            if (!self.morePage) {
                _goodsTableView.legendFooter.hidden = YES;
            }else{
                _goodsTableView.legendFooter.hidden = NO;
                
            }
            if (result.dataArray.count>0) {
                [_goodsTableView setHidden:NO];
                [self.blankView setHidden:YES];
                self.goodsListArr = [NSMutableArray arrayWithArray:result.dataArray];
                [_goodsTableView.legendFooter endRefreshing];
                [_goodsTableView.legendHeader endRefreshing];
                [_goodsTableView reloadData];
            }else{
                [_goodsTableView.legendFooter endRefreshing];
                [_goodsTableView.legendHeader endRefreshing];
                [_goodsTableView setHidden:YES];
                [self.blankView setHidden:NO];
            }

            [self removeRotationAnimationView:loading];
        }];

    }
    

}
-(void)getMorePageDate{
    [[DataFactory sharedDataFactory]getPointMallByPage:[NSString stringWithFormat:@"%d",self.page] andSequenceType:            seqType andWithCallBack:^(GoodsResult *result) {
        if (result.dataArray.count>0) {
            self.morePage = result.morePage;
            [self.goodsListArr addObjectsFromArray:result.dataArray];
            if (self.morePage) {
                _goodsTableView.legendFooter.hidden = NO;
            }else{
                _goodsTableView.legendFooter.hidden = YES;
            }
            [_goodsTableView reloadData];
            [_goodsTableView.legendFooter endRefreshing];
            
        }else{
            [_goodsTableView.legendFooter endRefreshing];
            _goodsTableView.legendFooter.hidden = YES;
            
            
        }
        

    }];

}

#pragma mark 空白没有数据
-(void)tempView{

    self.blankView = [[UIView alloc]initWithFrame:_goodsTableView.frame];
    [self.view addSubview:self.blankView];
    
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, 100, 98, 111)];
        [self.blankView addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    CGSize ss = [@"没有数据" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    if (iPhone4) {
        [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, kFrame_YHeight(_tableviewHeader)+50, 98, 111)];
        [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    }
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setText:@"没有数据"];
    [self.blankView addSubview:tip];
    [self.blankView setHidden:YES];
}

-(void)leftBarButtonItemClick{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEPOINTS" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)baseNavigationController:(BaseNavigationController*)controller didReturn:(NSString*)className{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEPOINTS" object:self];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

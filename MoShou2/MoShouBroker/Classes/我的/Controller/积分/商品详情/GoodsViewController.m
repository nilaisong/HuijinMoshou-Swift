//
//  GoodsViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/27.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "GoodsViewController.h"
#import "HMTool.h"
#import "UILabel+StringFrame.h"
#import "DataFactory+User.h"
#import "DataFactory+Customer.h"
#import "UserData.h"
#import "MyImageView.h"
#import "NewAddressViewController.h"
@interface GoodsViewController ()<UIAlertViewDelegate>

@end

@implementation GoodsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
-(void)initUI{
    self.navigationBar.titleLabel.text = self.goods.goodsName;
    UIScrollView *detailSCV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, self.view.bounds.size.height-50)];
    [detailSCV setBackgroundColor:BACKGROUNDCOLOR];
    [self.view addSubview:detailSCV];
    
    UIView *goodsView =[[UIView alloc]initWithFrame:CGRectMake(0,0, kMainScreenWidth, kMainScreenWidth*0.75)];
    [detailSCV addSubview:goodsView];
    
    MyImageView *goodsImage =[[MyImageView alloc]initWithFrame:CGRectMake(0, 0,kMainScreenWidth, kMainScreenWidth*0.75)];
    [goodsImage setImageWithUrlString:self.goods.imgUrl placeholderImage:[UIImage imageNamed:@"默认图片"]];
    goodsImage.center = CGPointMake(goodsView.centerX, goodsView.centerY);
    [goodsView addSubview:goodsImage];
    
    
    UIView *descView = [[UIView alloc]init];
    [descView setFrame:CGRectMake(0, kFrame_YHeight(goodsView), kMainScreenWidth,200)];
    [descView setBackgroundColor:[UIColor whiteColor]];
    [detailSCV addSubview:descView];
//    CGRectMake(0, kFrame_YHeight(goodsView), kMainScreenWidth,  kFrame_YHeight(process)+150+kFrame_Height(goodsDescContent)))
    UIView *line= [HMTool getLineWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [descView addSubview:line];
    
    UILabel *important = [[UILabel alloc]init];
    [important setFont:[UIFont systemFontOfSize:14]];
    [important setTextColor:NAVIGATIONTITLE];
    [important setText:@"商品简介:"];
    CGSize titleSize=[HMTool getTextSizeWithText:important.text andFontSize:14];
    [important setFrame:CGRectMake(16, kFrame_YHeight(line)+20, titleSize.width, titleSize.height)];
    [descView addSubview:important];
    UILabel *content =[[UILabel alloc]init];
    [content setText:[self isBlankString:self.goods.goodsInfo]?@"暂无数据":self.goods.goodsInfo];
    [content setTextColor:POINTMALLGRAYLABELCOLOR];
    [content autoWithFrame:CGRectMake(16, kFrame_YHeight(important)+12, kMainScreenWidth-32, 40) andFontSize:14];
    [descView addSubview:content];
    UILabel *exchangRules = [[UILabel alloc]init];
    [exchangRules setTextColor:NAVIGATIONTITLE];
    [exchangRules setText:@"商品描述："];
    [exchangRules setFont:[UIFont systemFontOfSize:14]];
    CGSize exchangSize =[HMTool getTextSizeWithText:exchangRules.text andFontSize:14];
    [exchangRules setFrame:CGRectMake(16, kFrame_YHeight(content)+20, exchangSize.width, exchangSize.height)];
    [descView addSubview:exchangRules];
    
    UILabel *rules =[[UILabel alloc]init];
    [rules setText:[NSString stringWithFormat:@"%@", [self isBlankString:self.goods.goodsDescription]?@"暂无数据":self.goods.goodsDescription]];
    [rules setTextColor:POINTMALLGRAYLABELCOLOR];
    [rules autoWithFrame:CGRectMake(16, kFrame_YHeight(exchangRules)+12, kMainScreenWidth-32, 80) andFontSize:14];
    [descView addSubview:rules];
    
    UILabel *useProcess = [[UILabel alloc]init];
    [useProcess setTextColor:NAVIGATIONTITLE];
    [useProcess setText:@"兑换有效期："];
    [useProcess setFont:[UIFont systemFontOfSize:14]];
    CGSize useSize =[HMTool getTextSizeWithText:useProcess.text andFontSize:14];
    [useProcess setFrame:CGRectMake(16, kFrame_YHeight(rules)+20, useSize.width, useSize.height)];
//    [useProcess setFrame:CGRectMake(16, kFrame_YHeight(rules)+20, kMainScreenWidth-32, 20)];
    [descView addSubview:useProcess];
    
    UILabel *process = [[UILabel alloc]init];
    [process setText:[NSString stringWithFormat:@"开始时间：%@\n结束时间：%@",self.goods.activityTime ,self.goods.endTime]];
    [process setTextColor:POINTMALLGRAYLABELCOLOR];
    [process autoWithFrame:CGRectMake(16, kFrame_YHeight(useProcess)+12, kMainScreenWidth-32, 20) andFontSize:14];
    [descView addSubview:process];
    
    UILabel *goodsDesc = [[UILabel alloc]init];
    [goodsDesc setTextColor:NAVIGATIONTITLE];
    [goodsDesc setText:@"活动信息："];
    [goodsDesc setFont:[UIFont systemFontOfSize:14]];
    CGSize goodsDescSize =[HMTool getTextSizeWithText:goodsDesc.text andFontSize:14];
    [goodsDesc setFrame:CGRectMake(16, kFrame_YHeight(process)+20, goodsDescSize.width, goodsDescSize.height)];
    //    [useProcess setFrame:CGRectMake(16, kFrame_YHeight(rules)+20, kMainScreenWidth-32, 20)];
    [descView addSubview:goodsDesc];
    
    UILabel *goodsDescContent = [[UILabel alloc]init];
    [goodsDescContent setText:[NSString stringWithFormat:@"兑换流程：%@\n重要说明：%@\n",[self isBlankString:self.goods.convertFlow]?@"暂无数据":self.goods.convertFlow,[self isBlankString:self.goods.remarks]?@"暂无数据":self.goods.remarks]];
    [goodsDescContent setTextColor:POINTMALLGRAYLABELCOLOR];
    [goodsDescContent autoWithFrame:CGRectMake(16, kFrame_YHeight(goodsDesc)+12, kMainScreenWidth-32, 20) andFontSize:14];
    [descView addSubview:goodsDescContent];
   
    [descView setFrame:CGRectMake(0, kFrame_YHeight(goodsView), kMainScreenWidth,  kFrame_YHeight(goodsDesc)+kFrame_Height(goodsDescContent)+20)];
    UIView *line2 = [HMTool getLineWithFrame:CGRectMake(0, kFrame_Height(descView)-0.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [descView addSubview:line2];
    
    UIView *friendView =[[UIView alloc]initWithFrame:CGRectMake(0, kFrame_YHeight(descView)+10, kMainScreenWidth, 80)];
    [friendView setBackgroundColor:[UIColor whiteColor]];
    [detailSCV addSubview:friendView];
    
  
    
    
    UILabel *friend = [[UILabel alloc]init];
    [friend setTextColor:NAVIGATIONTITLE];
    [friend setText:@"友情提示："];
    [friend setFont:[UIFont systemFontOfSize:12]];
    CGSize friendSize =[HMTool getTextSizeWithText:useProcess.text andFontSize:12];
    [friend setFrame:CGRectMake(16, 15, friendSize.width, friendSize.height)];
    [friendView addSubview:friend];
    
    UILabel *friendContent = [[UILabel alloc]init];
    [friendContent setFont:[UIFont systemFontOfSize:12]];
    [friendContent setText:@"1、请在有效期内使用，过期无效\n2、产品一旦兑换不予以退换\n3、此活动最终解释权归汇金行所有，和苹果公司无关"];
    [friendContent setTextColor:POINTMALLGRAYLABELCOLOR];
    [friendContent autoWithFrame:CGRectMake(16, kFrame_YHeight(friend)+10, kMainScreenWidth-32,80) andFontSize:12];
    [friendView addSubview:friendContent];
    [friendView setFrame:CGRectMake(0, kFrame_YHeight(descView)+10, kMainScreenWidth, kFrame_Height(friendContent)+kFrame_Height(friend)+45)];
    
    UIView *line3 = [HMTool getLineWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [friendView addSubview:line3];
    UIView *line4 = [HMTool getLineWithFrame:CGRectMake(0, kFrame_Height(friendView)-0.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [friendView addSubview:line4];
    
    [detailSCV setContentSize:CGSizeMake(kMainScreenWidth, kFrame_Height(descView)+kFrame_Height(goodsView)+kFrame_Height(friendView)+kFrame_Height(friendView)+10)];

    
    

    
    UIView *bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, kMainScreenWidth, 50)];
    [bottomView setBackgroundColor:BACKGROUNDCOLOR];
    [self.view addSubview:bottomView];
    UIView *line5 = [HMTool getLineWithFrame:CGRectMake(0, 0.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [bottomView addSubview:line5];

    UILabel *costLabe =[[UILabel alloc]init];
    NSString *num = self.goods.convertPoints;
    NSString *str =[NSString stringWithFormat:@"%@ 积分",num];

   NSMutableAttributedString *abStr = [[NSMutableAttributedString alloc]initWithString:str];
    
   [abStr addAttribute:NSForegroundColorAttributeName value:ORIGCOLOR range:NSMakeRange(0, num.length)];
    [abStr addAttribute:NSForegroundColorAttributeName value:POINTMALLGRAYLABELCOLOR range:NSMakeRange(num.length, 3)];
    [costLabe setFont:[UIFont systemFontOfSize:20]];
    [costLabe setAttributedText:abStr];
    CGSize costSize =[HMTool getTextSizeWithText:str andFontSize:20];
    [costLabe setFrame:CGRectMake(16, 25-costSize.height/2, costSize.width, costSize.height)];
    [bottomView addSubview:costLabe];
    
    UIButton *getBtn =[[UIButton alloc]initWithFrame:CGRectMake(kFrame_XWidth(costLabe)+16, 0.5, kMainScreenWidth-(kFrame_XWidth(costLabe)+16), kFrame_Height(bottomView)-0.5)];
    [getBtn  addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]<[[self timeToTimestampWithTimeStr: self.goods.activityTime]longLongValue]){
        [getBtn setBackgroundColor:LINECOLOR];
        
    }else if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]>[[self timeToTimestampWithTimeStr: self.goods.endTime]longLongValue]){
        [getBtn setBackgroundColor:LINECOLOR];
        
    }else if (self.goods.availableNum.intValue>0&&([UserData sharedUserData].points.intValue < self.goods.convertPoints.intValue)) {
        [getBtn setBackgroundColor:LINECOLOR];

    }else if (self.goods.availableNum.intValue <= 0&&([UserData sharedUserData].points.intValue > self.goods.convertPoints.intValue)){
        [getBtn setBackgroundColor:LINECOLOR];

    }else{
        [getBtn setBackgroundColor:BLUEBTBCOLOR];
    }
    [getBtn setTitle:@"马上抢" forState:UIControlStateNormal];
    [bottomView addSubview:getBtn];
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

-(void)exchangeAction:(UIButton *)btn{
    btn.userInteractionEnabled = NO;

    if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]<[[self timeToTimestampWithTimeStr:self.goods.activityTime]longLongValue]){
        btn.userInteractionEnabled = YES;
        [TipsView showTipsCantClick:@"很抱歉活动未开始" inView:self.view];
    }else if ([[self timeToTimestampWithTimeStr:[self getCurrentTime]] longLongValue]>[[self timeToTimestampWithTimeStr:self.goods.endTime]longLongValue]){
        btn.userInteractionEnabled = YES;
        [TipsView showTipsCantClick:@"很抱歉活动已结束" inView:self.view];
    }else if (self.goods.availableNum.intValue>0&&([UserData sharedUserData].points.integerValue < self.goods.convertPoints.intValue)) {
        btn.userInteractionEnabled = YES;
        [TipsView showTipsCantClick:@"很抱歉积分不足" inView:self.view];
    }else if(self.goods.availableNum.intValue<=0&&([UserData sharedUserData].points.integerValue > self.goods.convertPoints.intValue)){
        btn.userInteractionEnabled = YES;
        [TipsView showTipsCantClick:@"很抱歉库存不足" inView:self.view];
    }else{
        if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
            if (![[UserData sharedUserData].addressId isEqualToString:@"0"]) {
                UIImageView *loading = [self setRotationAnimationWithView];
                [[DataFactory sharedDataFactory]exchangeGoodsWith:self.goods withAddress:[UserData sharedUserData].addressId andCallback:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.success) {
                            [self removeRotationAnimationView:loading];
                            [TipsView showTipsCantClick:@"申请兑换成功，请等待管理员操作！" inView:self.view];
                            if (self.goods.availableNum<=0) {
                                [btn setBackgroundColor:LINECOLOR];
                                btn.userInteractionEnabled = NO;
                            }else{
                                btn.userInteractionEnabled = YES;
                                
                            }
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFREShPOINT" object:self];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadJifenList" object:self];
                        }else{
                            [TipsView showTipsCantClick:result.message inView:self.view];
                            btn.userInteractionEnabled = YES;
                        }
                    });
                }];
            }else
            {
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"兑换提示" message:@"请先到“我的→个人资料页”去填写收货地址，否则无法完成兑换。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去填写", nil];
                [alert show];
                btn.userInteractionEnabled = YES;
            }
            
        }
    }
    
//    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NewAddressViewController *newAddVC = [[NewAddressViewController alloc] init];
        newAddVC.addressType = kNewAddress;
        newAddVC.addressType = kNewAddress;
//        __weak typeof(self) weakSelf = self;
        [newAddVC saveModifyAddressBlock:^{
            
        }];
        [self.navigationController pushViewController:newAddVC animated:YES];
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

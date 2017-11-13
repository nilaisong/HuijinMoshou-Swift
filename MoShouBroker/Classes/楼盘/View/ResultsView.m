//
//  ResultsView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ResultsView.h"
#import "PNChart.h"
#import "ResultData.h"
@implementation ResultsView

{
    
    
    PNPieChart * _pieChart;
    UILabel *_yueGongLabel;
    UILabel *_monelyLabel;
    
    
    UIView * _firstBottomView;

    UIView * _lastBottomView;
    
    UILabel * _lineLabel;
    
    ResultData *_benJinData;
    ResultData *_benXiData;
    
    BOOL _isZongjia;

    UIView *blackView;
    
    double interest;
}

-(id)initWithFrame:(CGRect)frame andResultData:(ResultData *)benJinData andResultData:(ResultData *)benXiData andIsZongjia:(BOOL)isZongjia;

{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        _benJinData = benJinData;
        _benXiData = benXiData;
        _isZongjia = isZongjia;
        
        DLog(@"%@     %@",_benXiData.lastYearsMonthMeanTitle,_benXiData.lastYearsMonthMean)

        
        
        [self loadUI];
    }

    return self;
    
}

-(void)loadUI

{
    NSArray *titleArray =@[@"等额本息",@"等额本金"];
    
    for (NSInteger i  = 0; i < 2 ; i ++)
    {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake(i*kMainScreenWidth/2, 0, kMainScreenWidth/2, 44);
        button.titleLabel.font = FONT(15.f);
        if (i==0)
        {
            button.selected = YES;
        }
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"iconfont-zhuyiyemian-bai.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"iconfont-zhuyiyemian-lan.png"] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeCenter];
        [button.titleLabel setContentMode:UIViewContentModeCenter];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -45-5*SCALE, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-20, 155+5*SCALE, 0, 0)];
        
        button.tag = 9000+i;
        if (button.selected)
        {
            [button setBackgroundColor:BLUEBTBCOLOR];
        }else
        {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailButton.frame = CGRectMake(button.bounds.size.width*3/4, 0, button.bounds.size.width/4, button.bounds.size.height);
        detailButton.tag = i;
        detailButton.backgroundColor = [UIColor clearColor];
        [detailButton addTarget:self action:@selector(detailButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:detailButton];
    }

    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kMainScreenWidth, 200)];
    blackView.backgroundColor = BACKGROUNDCOLOR;
    [self addSubview:blackView];
    
    if (_isZongjia) {
        _firstBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.bottom, kMainScreenWidth, 25*3)];

    }else{
        _firstBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.bottom, kMainScreenWidth, 25*4)];

    }
    [self addSubview:_firstBottomView];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, _firstBottomView.bottom+5, kMainScreenWidth-32, 1)];
    _lineLabel.backgroundColor = LINECOLOR;
    [self addSubview:_lineLabel];
    
    _lastBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _lineLabel.bottom+5, kMainScreenWidth, 25*5)];
    [self addSubview:_lastBottomView];
    
    [self addTitleView];
    
    [self setPieChartWithBtnTag:9000];
    [self setLastBottomViewWithBtnTag:9000];

    
}

-(void)detailButtonPress:(UIButton *)sender
{
    [self promptBoxShow:sender.tag];
}

-(void)promptBoxShow:(NSInteger)buttonTag
{
    if (_resultsDelegate && [_resultsDelegate respondsToSelector:@selector(promptBoxShow:)]) {
        [self.resultsDelegate promptBoxShow:buttonTag];
    }
}

//下面显示三种颜色状态的View
-(void)addTitleView
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-160)/2, 44+10+140+10, 160, 20)];
    [self addSubview:titleView];
    for (NSInteger i = 0; i < 3; i ++)
    {
        CGFloat viewWith = titleView.width/3;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i*viewWith, 0, viewWith, titleView.height)];
        [titleView addSubview:bgView];
        switch (i) {
            case 0:
            {
                UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (titleView.height-9)/2, 9, 9)];
                colorLabel.backgroundColor =UIColorFromRGB(0x1b9fea);
                [bgView addSubview:colorLabel];
                
                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(colorLabel.right, 0, bgView.width-colorLabel.width, bgView.height)];
                titlelabel.text = @"  首付";
                titlelabel.textColor = LABELCOLOR;
                titlelabel.font = FONT(8.f);
                titlelabel.textAlignment = NSTextAlignmentLeft;
                [bgView addSubview:titlelabel];
            }
                break;
            case 1:
            {
                UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (titleView.height-9)/2, 9, 9)];
                colorLabel.backgroundColor =UIColorFromRGB(0x88c7fd);
                [bgView addSubview:colorLabel];
                
                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(colorLabel.right, 0, bgView.width-colorLabel.width, bgView.height)];
                titlelabel.text = @"贷款总额";
                titlelabel.textColor = LABELCOLOR;
                titlelabel.font = FONT(8.f);
                titlelabel.textAlignment = NSTextAlignmentCenter;
                [bgView addSubview:titlelabel];
            }
                break;
            case 2:
            {
                UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (titleView.height-9)/2, 9, 9)];
                colorLabel.backgroundColor =UIColorFromRGB(0xcbe7ff);
                [bgView addSubview:colorLabel];
                
                UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(colorLabel.right, 0, bgView.width-colorLabel.width, bgView.height)];
                titlelabel.text = @"利息总计";
                titlelabel.textColor = LABELCOLOR;
                titlelabel.font = FONT(8.f);
                titlelabel.textAlignment = NSTextAlignmentCenter;
                [bgView addSubview:titlelabel];
            }
                break;
            default:
                break;
        }
    }

}

-(void)btnClick:(UIButton *)sender
{
    DLog(@"tag===%zd",sender.tag);
    if (sender.tag==9000)  //等额本金
    {
        UIButton *btn = (UIButton *)[self viewWithTag:9001];
        btn.selected = NO;
        btn.backgroundColor = [UIColor whiteColor];
        sender.selected = YES;
        sender.backgroundColor = BLUEBTBCOLOR;
        
        
        
    }else if (sender.tag == 9001)  //等额本息
    {
        UIButton *btn = (UIButton *)[self viewWithTag:9000];
        btn.selected = NO;
        btn.backgroundColor = [UIColor whiteColor];
        sender.selected = YES;
        sender.backgroundColor = BLUEBTBCOLOR;
        
    }

    [self setPieChartWithBtnTag:sender.tag];
    [self setLastBottomViewWithBtnTag:sender.tag];

}


//设置最后几项钱数的UI 效果
-(void)setLastBottomViewWithBtnTag:(NSInteger)btnTag;
{
    
    [_lastBottomView removeFromSuperview];
    [_firstBottomView removeFromSuperview];
    
    _firstBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.bottom, kMainScreenWidth, 25*4)];
    [self addSubview:_firstBottomView];
    _lastBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _lineLabel.bottom+5, kMainScreenWidth, 25*5)];
    [self addSubview:_lastBottomView];
   
    NSArray *titleArr;
    NSArray *titleContentArr;
    
    NSArray *titleArr1 ;
    NSArray *titleContentArr1;
    
    if (btnTag == 9001)
    {
        
        if (_isZongjia) {
            titleArr = @[@"贷款总额",@"还款总额",@"支付利息"];
            titleContentArr = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benJinData.daiKuanAllPrice doubleValue]*10000],[NSString stringWithFormat:@"%.2f元",[_benJinData.huanKuanAllPrice doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benJinData.ziFuLixi doubleValue]], nil];
            
        }else{
            titleArr = @[@"房屋总价",@"贷款总额",@"还款总额",@"支付利息"];
            titleContentArr = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benJinData.houseAllPrice doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benJinData.daiKuanAllPrice doubleValue]*10000],[NSString stringWithFormat:@"%.2f元",[_benJinData.huanKuanAllPrice doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benJinData.ziFuLixi doubleValue]], nil];
        }
        
        DLog(@"%f",[_benJinData.houseAllPrice doubleValue]);
        titleArr1 = @[@"首期付款",@"按揭年数",@"首月还款",@"末月还款",@"每月递减"];
        titleContentArr1 =[NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benJinData.firstPay doubleValue]*10000],[NSString stringWithFormat:@"%zd年(%@期)",[_benJinData.nianShu integerValue]/12,_benJinData.nianShu ],[NSString stringWithFormat:@"%.2f元",[_benJinData.firstYuePay doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benJinData.lastYuePay doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benJinData.everyMonthDiminish doubleValue]], nil];
    }
    else if (btnTag == 9000)
    {
        
        if (_isZongjia) {
            titleArr = @[@"贷款总额",@"还款总额",@"支付利息"];
            titleContentArr = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benXiData.daiKuanAllPrice doubleValue]*10000],[NSString stringWithFormat:@"%.2f元",[_benXiData.huanKuanAllPrice doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benXiData.ziFuLixi doubleValue]], nil];
        }else{
            titleArr = @[@"房屋总价",@"贷款总额",@"还款总额",@"支付利息"];
            titleContentArr = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benXiData.houseAllPrice doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benXiData.daiKuanAllPrice doubleValue]*10000],[NSString stringWithFormat:@"%.2f元",[_benXiData.huanKuanAllPrice doubleValue]],[NSString stringWithFormat:@"%.2f元",[_benXiData.ziFuLixi doubleValue]], nil];
        }
       
        DLog(@"%f",[_benXiData.houseAllPrice doubleValue]);
      
        
        if (_benXiData.lastYearsMonthMeanTitle.length>0 && _benXiData.lastYearsMonthMean.length > 0) {
            
            titleArr1 = @[@"首期付款",@"按揭年数",@"月均还款",_benXiData.lastYearsMonthMeanTitle];
            titleContentArr1 = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benXiData.firstPay doubleValue]*10000],[NSString stringWithFormat:@"%zd年(%@期)",[_benXiData.nianShu integerValue]/12,_benXiData.nianShu],[NSString stringWithFormat:@"%.2f元",[_benXiData.everyMonthMean doubleValue]],_benXiData.lastYearsMonthMean, nil];
        }else{
            titleArr1 = @[@"首期付款",@"按揭年数",@"月均还款"];
            titleContentArr1 = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%.2f元",[_benXiData.firstPay doubleValue]*10000],[NSString stringWithFormat:@"%zd年(%@期)",[_benXiData.nianShu integerValue]/12,_benXiData.nianShu],[NSString stringWithFormat:@"%.2f元",[_benXiData.everyMonthMean doubleValue]], nil];
        }
       
    }
    for (NSInteger i = 0; i < titleArr.count; i ++)
    {
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, i*25, kMainScreenWidth, 25)];
        [_firstBottomView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kMainScreenWidth*0.3, titleView.height)];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = LABELCOLOR;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = FONT(14.f);
        [titleView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth*0.3, 0, (kMainScreenWidth*0.7)-16, titleView.height)];
        contentLabel.text = titleContentArr[i];
       
        if (_isZongjia) {
            if (i==2) {
                interest = [[contentLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""] doubleValue]/10000;
                [self setPieChartWithBtnTag:btnTag];
            }
        }else{
            if (i==3) {
                interest = [[contentLabel.text stringByReplacingOccurrencesOfString:@"元" withString:@""] doubleValue]/10000;
                [self setPieChartWithBtnTag:btnTag];
            }
        }
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.textColor = BLUEBTBCOLOR;
        contentLabel.font = FONT(14.f);
        [titleView addSubview:contentLabel];
        
    }
    for (NSInteger i = 0; i < titleArr1.count; i ++)
    {
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, i*25, kMainScreenWidth, 25)];
        titleView.tag = 9700+i;
        [_lastBottomView addSubview:titleView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kMainScreenWidth*0.3, titleView.height)];
        titleLabel.text = titleArr1[i];
        titleLabel.textColor = LABELCOLOR;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = FONT(14.f);
        [titleView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth*0.3, 0, (kMainScreenWidth*0.7)-16, titleView.height)];
        contentLabel.text = titleContentArr1[i];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.textColor = BLUEBTBCOLOR;
        contentLabel.font = FONT(14.f);
        [titleView addSubview:contentLabel];
    }
}

-(void)setPieChartWithBtnTag:(NSInteger)btntag;
{
    [_pieChart removeFromSuperview];
    [_yueGongLabel removeFromSuperview];
    [_monelyLabel removeFromSuperview];
    
    NSArray *items;
    if (btntag == 9001)
    {
        if ([_benJinData.firstPay doubleValue]!=0 ||[_benJinData.daiKuanAllPrice doubleValue]!=0 || [_benJinData.ziFuLixi doubleValue]!=0)
        {
//            CGFloat  shoufuNum = 10000*[_benJinData.firstPay doubleValue]/(10000*[_benJinData.firstPay doubleValue]+[_benJinData.daiKuanAllPrice doubleValue]+[_benJinData.ziFuLixi doubleValue])*100;
//            CGFloat  daikuanNum = [_benJinData.daiKuanAllPrice doubleValue]/(10000*[_benJinData.firstPay doubleValue]+[_benJinData.daiKuanAllPrice doubleValue]+[_benJinData.ziFuLixi doubleValue])*100;
//            CGFloat  lixiNum = [_benJinData.ziFuLixi doubleValue]/(10000*[_benJinData.firstPay doubleValue]+[_benJinData.daiKuanAllPrice doubleValue]+[_benJinData.ziFuLixi doubleValue])*100;
            
//            items = @[[PNPieChartDataItem dataItemWithValue:shoufuNum color:UIColorFromRGB(0x1b9fea)],
//                      [PNPieChartDataItem dataItemWithValue:daikuanNum color:UIColorFromRGB(0x88c7fd) ],
//                      [PNPieChartDataItem dataItemWithValue:lixiNum color:UIColorFromRGB(0xcbe7ff)],
//                      ];
            items = @[[PNPieChartDataItem dataItemWithValue:[_benJinData.firstPay doubleValue] color:UIColorFromRGB(0x1b9fea)],
                      [PNPieChartDataItem dataItemWithValue:[_benJinData.daiKuanAllPrice doubleValue] color:UIColorFromRGB(0x88c7fd) ],
                      [PNPieChartDataItem dataItemWithValue:interest color:UIColorFromRGB(0xcbe7ff)],
                      ];
            NSLog(@"\nshoufuNum:%f \ndaikuanNum:%f,\nlixiNum:%f",[_benJinData.firstPay doubleValue],[_benJinData.daiKuanAllPrice doubleValue],interest);
            _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((kMainScreenWidth-140)/2, 44+10, 140, 140) items:items];
            _pieChart.descriptionTextColor = [UIColor whiteColor];
            _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
            [_pieChart strokeChart];
            
            [self addSubview:_pieChart];
            
           _yueGongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, _pieChart.width, 15)];
            _yueGongLabel.text = @"首月月供";
            _yueGongLabel.font = FONT(10.f);
            _yueGongLabel.textColor = TFPLEASEHOLDERCOLOR;
            _yueGongLabel.textAlignment = NSTextAlignmentCenter;
            [_pieChart addSubview:_yueGongLabel];
            
            _monelyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _yueGongLabel.bottom, _pieChart.width, 25)];
            _monelyLabel.textAlignment = NSTextAlignmentCenter;
            _monelyLabel.text =[NSString stringWithFormat:@"%.2f",[_benJinData.firstYuePay doubleValue]];
            _monelyLabel.textColor = ORIGCOLOR;
            _monelyLabel.font = FONT(16.f);
            [_pieChart addSubview:_monelyLabel];
        }else{
            
            _yueGongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44+10+60, kMainScreenWidth, 15)];
            _yueGongLabel.text = @"首月月供";
            _yueGongLabel.font = FONT(10.f);
            _yueGongLabel.textColor = TFPLEASEHOLDERCOLOR;
            _yueGongLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_yueGongLabel];
            
            _monelyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _yueGongLabel.bottom,kMainScreenWidth, 25)];
            _monelyLabel.textAlignment = NSTextAlignmentCenter;
            _monelyLabel.text =[NSString stringWithFormat:@"%.2f",[_benJinData.firstYuePay doubleValue]];
            _monelyLabel.textColor = ORIGCOLOR;
            _monelyLabel.font = FONT(16.f);
            [self addSubview:_monelyLabel];

            
        }

    }else if (btntag == 9000)
    {
        if ([_benXiData.everyMonthMean doubleValue]!=0 ||[_benXiData.daiKuanAllPrice doubleValue]!=0 || [_benXiData.ziFuLixi doubleValue]!=0)
        {
//            CGFloat  shoufuNum = [_benXiData.everyMonthMean doubleValue]/([_benXiData.everyMonthMean doubleValue]+[_benXiData.daiKuanAllPrice doubleValue]+[_benXiData.ziFuLixi doubleValue])*100;
//            CGFloat  daikuanNum = [_benXiData.daiKuanAllPrice doubleValue]/([_benXiData.everyMonthMean doubleValue]+[_benXiData.daiKuanAllPrice doubleValue]+[_benXiData.ziFuLixi doubleValue])*100;
//            CGFloat  lixiNum = [_benXiData.ziFuLixi doubleValue]/([_benXiData.everyMonthMean doubleValue]+[_benXiData.daiKuanAllPrice doubleValue]+[_benXiData.ziFuLixi doubleValue])*100;
            
            
//            items = @[[PNPieChartDataItem dataItemWithValue:shoufuNum c (0x1b9fea)],
//                      [PNPieChartDataItem dataItemWithValue:daikuanNum color:UIColorFromRGB(0x88c7fd) ],
//                      [PNPieChartDataItem dataItemWithValue:lixiNum color:UIColorFromRGB(0xcbe7ff)],
//                      ];
            items = @[[PNPieChartDataItem dataItemWithValue:[_benJinData.firstPay doubleValue] color:UIColorFromRGB(0x1b9fea)],
                      [PNPieChartDataItem dataItemWithValue:[_benJinData.daiKuanAllPrice doubleValue] color:UIColorFromRGB(0x88c7fd) ],
                      [PNPieChartDataItem dataItemWithValue:interest color:UIColorFromRGB(0xcbe7ff)],
                      ];
            NSLog(@"\nshoufuNum:%f \ndaikuanNum:%f,\nlixiNum:%f",[_benJinData.firstPay doubleValue],[_benJinData.daiKuanAllPrice doubleValue],interest);
            _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((kMainScreenWidth-140)/2, 44+10, 140, 140) items:items];
            _pieChart.descriptionTextColor = [UIColor whiteColor];
            _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
            [_pieChart strokeChart];
            [self addSubview:_pieChart];
            
            _yueGongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, _pieChart.width, 15)];
            _yueGongLabel.text = @"首月月供";
            _yueGongLabel.font = FONT(10.f);
            _yueGongLabel.textColor = TFPLEASEHOLDERCOLOR;
            _yueGongLabel.textAlignment = NSTextAlignmentCenter;
            [_pieChart addSubview:_yueGongLabel];
            
            _monelyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _yueGongLabel.bottom, _pieChart.width, 25)];
            _monelyLabel.textAlignment = NSTextAlignmentCenter;
           
            _monelyLabel.text = [NSString stringWithFormat:@"%.2f",[_benXiData.everyMonthMean doubleValue]];
            _monelyLabel.textColor = ORIGCOLOR;
            _monelyLabel.font = FONT(16.f);
            [_pieChart addSubview:_monelyLabel];
            
        }else{
            _yueGongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44+10+60, kMainScreenWidth, 15)];
            _yueGongLabel.text = @"首月月供";
            _yueGongLabel.font = FONT(10.f);
            _yueGongLabel.textColor = TFPLEASEHOLDERCOLOR;
            _yueGongLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_yueGongLabel];
            
            _monelyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _yueGongLabel.bottom,kMainScreenWidth, 25)];
            _monelyLabel.textAlignment = NSTextAlignmentCenter;
            _monelyLabel.text = [NSString stringWithFormat:@"%.2f",[_benXiData.everyMonthMean doubleValue]];
            _monelyLabel.textColor = ORIGCOLOR;
            _monelyLabel.font = FONT(16.f);
            [self addSubview:_monelyLabel];
            
        }
        
    }
   
    
}

@end

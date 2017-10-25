//
//  MortgageCalculatorView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MortgageCalculatorView.h"
#import "NSString+Extension.h"
#import "ResultData.h"
#import "CaCheData.h"
@interface MortgageCalculatorView ()
{
    
    
    ResultData *_resultBenJinData;   //等额本金
    ResultData *_resultBenXiData;    //等额本息
    
    
    NSString * _unitPriceTFtext; //单价
    
    NSString *_allPriceTFtext;   //总价计算的  总价
    
    NSString * _areaTFtext;  //面积
    NSString * _firstPayTFtext;  //首付
    NSString * _provideAllMonelytext;  //贷款总额
    
    NSString *_firstPayProportionLabelText;  //首付比比例数字
    
    CaCheData * _gongJiCaCheData; //公积金缓存数据
    CaCheData *_shangYeCaCheData;  //商业贷款缓存数据
    
    UIButton *layerButton;
    UIImageView *promptImageView;
    UILabel *contenLabel;
}
@end

@implementation MortgageCalculatorView
{
    NSInteger selectProvideViewTag;
    NSInteger defaultsSectionNum;
}

typedef NS_ENUM(NSInteger, PriceStyle)
{
    
    allPriceStyle,   //总价
    unitPriceStyle ,   //单价
    areaStyle,        //面积
    firstPayStyle,    //首付
    provideAllMonelyStyle,  //贷款总额
};

-(id)initWithFrame:(CGRect)frame AndViewStyle:(MortgageCalculatorViewStyle) mortgageCalculatorViewStyle;

{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.mortgageCalculatorViewStyle = mortgageCalculatorViewStyle;
        defaultsSectionNum = 5;
        
        
        DLog(@"%@      %@",_housePrise,_area);
        
  
        
        [self loadUI];
        
    }
    return self;
}
-(void)loadUI
{
    
   
    
    _resultBenXiData = [[ResultData alloc]init];
    _resultBenJinData = [[ResultData alloc]init];
    
    _gongJiCaCheData = [[CaCheData alloc]init]; //公积金缓存数据
    _gongJiCaCheData.monely = @"0";
    _gongJiCaCheData.lilv = @"3.25";
    _shangYeCaCheData = [[CaCheData alloc]init];  //商业贷款缓存数据
    _shangYeCaCheData.monely = @"0";
    _shangYeCaCheData.lilv = @"5.15";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollsToTop = YES;
    [self addSubview:self.tableView];
    
    _unitPriceTFtext = self.housePrise;
    _areaTFtext = self.area;
    if (self.housePrise.length>0 && self.area.length>0) {
        _provideAllMonelytext = [NSString stringWithFormat:@"%.2f",[self.housePrise doubleValue]*[self.area doubleValue]];
        [_tableView reloadData];
    }
  
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (self.mortgageCalculatorViewStyle == danJiaStyle)
            {
                return 3;
            }else if (self.mortgageCalculatorViewStyle == zongJiaStyle)
            {
                return 2;
            }
            break;
            
            case 1:
            return 1;
            break;
        
            case 2:
            return 1;
            break;
            
            case 3:
            return 1;
            break;
            
            case 4:
            return 1;
            break;
          
            case 5:   //结果页面
            return 1;
            break;
            
            case 6:   //重新计算
            return 1;
            break;
            
        default:
            break;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return defaultsSectionNum;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==2 || indexPath.section==3) {
        return 88;
    }else if (indexPath.section==4 ) {
        
        return 140;
    }else if (indexPath.section == 5)
    {
        
        return 500;
    }else if (indexPath.section == 6)
    {
        return 100;
    
    }else
    {
        return 44;

        
    }
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
           return 44;
            break;
            
            case 1:
            return 10;
            break;
            
            case 2:
            return 0.1;
            break;
            
            
            case 3:
            return 0.1;
            break;
            
            case 4:
            return 0.1;
            break;
        case 5:
            return 0.1;
            break;
        case 6:
            return 0.1;
            break;
            
        default:
            break;
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    return 0.1;
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (self.mortgageCalculatorViewStyle == danJiaStyle)
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
            view.backgroundColor = [UIColor clearColor];
            NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"单价计算",@"总价计算",nil];
            UISegmentedControl *_segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
            _segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, 8, 200*SCALE, 30);
            _segment.tintColor = BLUEBTBCOLOR;
            _segment.selectedSegmentIndex = 0;
            _segment.userInteractionEnabled = NO;
            
            [view addSubview:_segment];

            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth/2, 0, kMainScreenWidth/2, view.height)];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 9100;
            [view addSubview:button];
            return view;
        
        }else if (self.mortgageCalculatorViewStyle == zongJiaStyle){
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
            view.backgroundColor = [UIColor clearColor];
            NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"单价计算",@"总价计算",nil];
            
            UISegmentedControl *_segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
            _segment.frame =CGRectMake((kMainScreenWidth-200*SCALE)/2, 8, 200*SCALE, 30);
            _segment.tintColor = BLUEBTBCOLOR;
            _segment.selectedSegmentIndex = 1;
            _segment.userInteractionEnabled = NO;
            [view addSubview:_segment];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/2, view.height)];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 9101;
            [view addSubview:button];
            return view;
        }
       
    }else{
    
        UIView *view;
        return view;
    }
    UIView *view;
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (self.mortgageCalculatorViewStyle == danJiaStyle)
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UILabel *danjiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, cell.height)];
                        danjiaLabel.text = @"单价";
                        danjiaLabel.font = FONT(16.f);
                        danjiaLabel.textAlignment = NSTextAlignmentCenter;
                        danjiaLabel.textColor = LABELCOLOR;
                        [cell.contentView addSubview:danjiaLabel];
                        
                        self.unitPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(danjiaLabel.right, 0, kMainScreenWidth-40-50, cell.height)];
                        self.unitPriceTF.placeholder = @"请输入房子单价";
                        self.unitPriceTF.delegate = self;
                        if (_unitPriceTFtext.length > 0) {
                            self.unitPriceTF.text =_unitPriceTFtext;
                        }else{
                            if (self.housePrise.length>0) {
                            self.unitPriceTF.text =[NSString stringWithFormat:@"%@",self.housePrise];
                            }
                        }
                        self.unitPriceTF.tag =unitPriceStyle;
                        self.unitPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
                        [self.unitPriceTF addTarget:self action:@selector(textFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
                        self.unitPriceTF.font = FONT(15.f);
                        self.unitPriceTF.textColor = NAVIGATIONTITLE;
                        [cell.contentView addSubview:self.unitPriceTF];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-80, 0, 60, 44)];
                        label.text = @"元/平米";
                        label.textAlignment = NSTextAlignmentRight;
                        label.textColor = LABELCOLOR;
                        label.font = FONT(16.f);
                        [cell.contentView addSubview:label];
                        
                        return cell;
                    }
                        break;
                    case 1:
                    {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UILabel *mianjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, cell.height)];
                        mianjiLabel.text = @"面积";
                        mianjiLabel.font = FONT(16.f);
                        mianjiLabel.textAlignment = NSTextAlignmentCenter;
                        mianjiLabel.textColor = LABELCOLOR;
                        [cell.contentView addSubview:mianjiLabel];
                        
                        self.areaTF = [[UITextField alloc]initWithFrame:CGRectMake(mianjiLabel.right, 0, kMainScreenWidth-40-50, cell.height)];
                        self.areaTF.placeholder = @"请输入房子面积";
                        self.areaTF.delegate = self;
                        self.areaTF.keyboardType = UIKeyboardTypeDecimalPad;
                        self.areaTF.font = FONT(15.f);
                        self.areaTF.delegate = self;
                        if (_areaTFtext.length > 0) {
                            self.areaTF.text =_areaTFtext;
                        }else{
                            if (self.area.length>0) {
                                self.areaTF.text = [NSString stringWithFormat:@"%@",self.area];
                            }
                        }
                        [self.areaTF addTarget:self action:@selector(textFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
                        self.areaTF.tag = areaStyle;
                        self.areaTF.textColor = NAVIGATIONTITLE;
                        [cell.contentView addSubview:self.areaTF];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-80, 0, 60, 44)];
                        label.text = @"平米";
                        label.textAlignment = NSTextAlignmentRight;
                        label.textColor = LABELCOLOR;
                        label.font = FONT(16.f);
                        
                        [cell.contentView addSubview:label];
                        
                        return cell;
                        
                    }
                        break;
                        
                    case 2:
                    {
                        //   fangdaiarrow.png
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UILabel *shouFuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, cell.height)];
                        shouFuLabel.text = @"首付";
                        shouFuLabel.font = FONT(16.f);
                        shouFuLabel.textAlignment = NSTextAlignmentCenter;
                        shouFuLabel.textColor = LABELCOLOR;
                        [cell.contentView addSubview:shouFuLabel];
                        
                        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(shouFuLabel.right+10, 5, 80, 30)];
                        bgView.backgroundColor = UIColorFromRGB(0xf7f7f7);
                        bgView.layer.cornerRadius = 5;
                        [bgView.layer setBorderWidth:1.f];
                        [bgView.layer setBorderColor:[UIColorFromRGB(0xdcdcdc) CGColor]];
                        
                        self.firstPayProportionLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 60, 30)];
                        self.firstPayProportionLabel.text = @"首付比";
                        self.firstPayProportionLabel.textColor = NAVIGATIONTITLE;
                        if (_firstPayProportionLabelText.length >0) {
                            self.firstPayProportionLabel.text = _firstPayProportionLabelText;
                        }
                        self.firstPayProportionLabel.textAlignment = NSTextAlignmentCenter;
                        self.firstPayProportionLabel.font = FONT(15.f);
                        [bgView addSubview:self.firstPayProportionLabel];
                        
                        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-20, 0, 20, 30)];
                        arrowImage.image = [UIImage imageNamed:@"fangdaiarrow.png"];
                        [bgView addSubview:arrowImage];
                        [cell.contentView addSubview:bgView];
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstPayProportionAction)];
                        
                        [bgView addGestureRecognizer:tap];

                        self.firstPayTF = [[UITextField alloc]initWithFrame:CGRectMake(bgView.right+5, 0, kMainScreenWidth-bgView.right-5-60, cell.height)];
                        self.firstPayTF.placeholder = @"";
                        self.firstPayTF.keyboardType = UIKeyboardTypeDecimalPad;
                        self.firstPayTF.textAlignment = NSTextAlignmentRight;
                        self.firstPayTF.font = FONT(15.f);
                        self.firstPayTF.delegate =self;
                        if (_firstPayTFtext.length > 0) {
                            self.firstPayTF.text =_firstPayTFtext;
                        }
                        [self.firstPayTF addTarget:self action:@selector(textFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
                        self.firstPayTF.tag = firstPayStyle;
                        self.firstPayTF.userInteractionEnabled = NO;
                        self.firstPayTF.textColor = NAVIGATIONTITLE;
                        [cell.contentView addSubview:self.firstPayTF];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-60, 0, 40, 44)];
                        label.text = @"万元";
                        label.textAlignment = NSTextAlignmentRight;
                        label.textColor = LABELCOLOR;
                        label.font = FONT(16.f);
                        [cell.contentView addSubview:label];
                        
                        return cell;
                    }
                        break;
                        
                    default:
                        break;
                }
            }else if (self.mortgageCalculatorViewStyle == zongJiaStyle)
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UILabel *danjiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, cell.height)];
                        danjiaLabel.text = @"总价";
                        danjiaLabel.font = FONT(16.f);
                        danjiaLabel.textAlignment = NSTextAlignmentCenter;
                        danjiaLabel.textColor = LABELCOLOR;
                        [cell.contentView addSubview:danjiaLabel];
                        
                        self.allPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(danjiaLabel.right, 0, kMainScreenWidth-40-50, cell.height)];
                        self.allPriceTF.placeholder = @"请输入房子总价";
                        self.allPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
                        self.allPriceTF.delegate =self;
                        self.allPriceTF.font = FONT(15.f);
                        if (_allPriceTFtext.length>0) {
                            self.allPriceTF.text = _allPriceTFtext;
                        }
                        self.allPriceTF.tag = allPriceStyle;
                        [self.allPriceTF addTarget:self action:@selector(textFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
                        self.allPriceTF.textColor = NAVIGATIONTITLE;
                        [cell.contentView addSubview:self.allPriceTF];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-80, 0, 60, 44)];
                        label.text = @"万元";
                        label.textAlignment = NSTextAlignmentRight;
                        label.textColor = LABELCOLOR;
                        label.font = FONT(16.f);
                        [cell.contentView addSubview:label];
                        return cell;
                    }
                        break;
                        case 1:
                    {
                        //   fangdaiarrow.png
                        UITableViewCell *cell = [[UITableViewCell alloc]init];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UILabel *shouFuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, cell.height)];
                        shouFuLabel.text = @"首付";
                        shouFuLabel.font = FONT(16.f);
                        shouFuLabel.textAlignment = NSTextAlignmentCenter;
                        shouFuLabel.textColor = LABELCOLOR;
                        [cell.contentView addSubview:shouFuLabel];
                        
                        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(shouFuLabel.right+10, 5, 80, 30)];
                        bgView.backgroundColor = UIColorFromRGB(0xf7f7f7);
                        bgView.layer.cornerRadius = 5;
                        [bgView.layer setBorderWidth:1.f];
                        [bgView.layer setBorderColor:[UIColorFromRGB(0xdcdcdc) CGColor]];
                        
                        self.firstPayProportionLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 60, 30)];
                        self.firstPayProportionLabel.text = @"首付比";
                        self.firstPayProportionLabel.textColor = NAVIGATIONTITLE;
                        if (_firstPayProportionLabelText.length >0) {
                            self.firstPayProportionLabel.text = _firstPayProportionLabelText;
                        }
                        self.firstPayProportionLabel.textAlignment = NSTextAlignmentCenter;
                        self.firstPayProportionLabel.font = FONT(15.f);
                        [bgView addSubview:self.firstPayProportionLabel];
                        
                        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-20, 0, 20, 30)];
                        arrowImage.image = [UIImage imageNamed:@"fangdaiarrow.png"];
                        [bgView addSubview:arrowImage];
                        [cell.contentView addSubview:bgView];
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstPayProportionAction)];
                        
                        [bgView addGestureRecognizer:tap];
                        
                        self.firstPayTF = [[UITextField alloc]initWithFrame:CGRectMake(bgView.right+5, 0, kMainScreenWidth-bgView.right-5-60, cell.height)];
                        self.firstPayTF.placeholder = @"";
                        self.firstPayTF.keyboardType = UIKeyboardTypeDecimalPad;
                        self.firstPayTF.textAlignment = NSTextAlignmentRight;
                        self.firstPayTF.font = FONT(15.f);
                        self.firstPayTF.delegate =self;
                        if (_firstPayTFtext.length > 0) {
                            self.firstPayTF.text =_firstPayTFtext;
                        }
                        [self.firstPayTF addTarget:self action:@selector(textFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
                        self.firstPayTF.tag = firstPayStyle;
                        self.firstPayTF.userInteractionEnabled = NO;
                        self.firstPayTF.textColor = NAVIGATIONTITLE;
                        [cell.contentView addSubview:self.firstPayTF];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-60, 0, 40, 44)];
                        label.text = @"万元";
                        label.textAlignment = NSTextAlignmentRight;
                        label.textColor = LABELCOLOR;
                        label.font = FONT(16.f);
                        [cell.contentView addSubview:label];
                        
                        return cell;
                    }
                        break;
                        
                    default:
                        break;
                }
            
            }
            
        }
            break;
            
            case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *daiKuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, cell.height)];
            daiKuanLabel.text = @"贷款总额";
            daiKuanLabel.font = FONT(16.f);
            daiKuanLabel.textAlignment = NSTextAlignmentCenter;
            daiKuanLabel.textColor = LABELCOLOR;
            [cell.contentView addSubview:daiKuanLabel];
            
            self.provideAllMonely = [[UITextField alloc]initWithFrame:CGRectMake(daiKuanLabel.right, 0, kMainScreenWidth-70-50, cell.height)];
            self.provideAllMonely.placeholder = @"0";
            self.provideAllMonely.userInteractionEnabled = NO;
            self.provideAllMonely.delegate = self;
            self.provideAllMonely.keyboardType = UIKeyboardTypeDecimalPad;
            [self.provideAllMonely addTarget:self action:@selector(textFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
            self.provideAllMonely.textAlignment = NSTextAlignmentRight;
            self.provideAllMonely.font = FONT(16.f);
            if (self.housePrise.length>0 && self.area.length>0) {
                self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.housePrise doubleValue]*[self.area doubleValue]];
            }
            
            if (_provideAllMonelytext.length>0) {
                self.provideAllMonely.text = _provideAllMonelytext;
            }
            self.provideAllMonely.tag = provideAllMonelyStyle;
            self.provideAllMonely.textColor = NAVIGATIONTITLE;
            [cell.contentView addSubview:self.provideAllMonely];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-40, 0, 40, 44)];
            label.text = @"元";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = LABELCOLOR;
            label.font = FONT(16.f);
            [cell.contentView addSubview:label];
            
            return cell;
        }
            
            break;
            
        case 2:  //公积金贷款
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, kMainScreenWidth, 43)];
            label.backgroundColor = BACKGROUNDCOLOR;
            label.text = @"     公积金贷款";
            label.font =FONT(12.f);
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = LABELCOLOR;
            [cell.contentView addSubview:label];
      
            
            ProvideView * gongJiCellView = [[ProvideView alloc]initWithFrame:CGRectMake(0, label.bottom, kMainScreenWidth, 44) AndProvideViewStyle:gongjiStyle];
            
            gongJiCellView.delegate = self;
            gongJiCellView.tag = 8800;
            [gongJiCellView.monelyTF addTarget:self action:@selector(cellTextFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
            gongJiCellView.monelyTF.delegate =self;
            gongJiCellView.lilvTF.delegate = self;

            if (_gongJiCaCheData.monely.length>0) {
                gongJiCellView.monelyTF.text = _gongJiCaCheData.monely;
            }
            if (_gongJiCaCheData.years.length>0) {
                [gongJiCellView.yearBtn setTitle:_gongJiCaCheData.years forState:UIControlStateNormal];

            }
            if (_gongJiCaCheData.lilv.length>0) {
                gongJiCellView.lilvTF.text = _gongJiCaCheData.lilv;
            }
            
            [cell.contentView addSubview:gongJiCellView];
            return cell;
        }
            break;
            case 3:  //商业贷款
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 43)];
            label.backgroundColor = BACKGROUNDCOLOR;
            label.text = @"     商业贷款";
            label.font =FONT(12.f);
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = LABELCOLOR;
            [cell.contentView addSubview:label];
            
            ProvideView * shangYeCellView = [[ProvideView alloc]initWithFrame:CGRectMake(0, label.bottom, kMainScreenWidth, 44) AndProvideViewStyle:shangyeStyle];
            shangYeCellView.delegate = self;
            shangYeCellView.tag = 8801;
            [shangYeCellView.monelyTF addTarget:self action:@selector(cellTextFiledEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
            shangYeCellView.monelyTF.delegate =self;
            shangYeCellView.lilvTF.delegate = self;
            if (_shangYeCaCheData.monely.length>0) {
                shangYeCellView.monelyTF.text = _shangYeCaCheData.monely;
            }
            if (_shangYeCaCheData.years.length>0) {
                [shangYeCellView.yearBtn setTitle:_shangYeCaCheData.years forState:UIControlStateNormal];
            }
            if (_shangYeCaCheData.lilv.length>0) {
                shangYeCellView.lilvTF.text = _shangYeCaCheData.lilv;
            }

            [cell.contentView addSubview:shangYeCellView];
            return cell;
        }
            break;
            case 4:  //开始计算
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(10, 40, kMainScreenWidth-20, 50);
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.backgroundColor = BLUEBTBCOLOR;
            [button setTitle:@"开始计算" forState:UIControlStateNormal];
            button.titleLabel.font = FONT(20.f);
            [button addTarget:self action:@selector(startToCalculate:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            DLog(@"%f   %f     ",_tableView.contentSize.height,_tableView.contentOffset.y);

            
            return cell;
            
        }
            break;
            
        case 5:  //计算结果
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ResultsView *view;
            if (self.mortgageCalculatorViewStyle == danJiaStyle) {
                view = [[ResultsView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 500) andResultData:_resultBenJinData andResultData:_resultBenXiData andIsZongjia:NO];

            }else if (self.mortgageCalculatorViewStyle == zongJiaStyle){
                view = [[ResultsView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 500) andResultData:_resultBenJinData andResultData:_resultBenXiData andIsZongjia:YES];
 
            }
            view.resultsDelegate = self;
            [cell.contentView addSubview:view];
            
            layerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            layerButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight*2);
            layerButton.backgroundColor = [UIColor clearColor];
            [layerButton addTarget:self action:@selector(layerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            layerButton.hidden = YES;
            [tableView addSubview:layerButton];
            
            promptImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 44, 193, 50)];
            promptImageView.image = [UIImage imageNamed:@"promptBoxImage"];
            promptImageView.hidden = YES;
            [cell.contentView addSubview:promptImageView];
            
            
            contenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 193, 47)];
            contenLabel.text = @"月还款额固定，所以总利息较多，适合收入稳定者。";
            contenLabel.textColor = [UIColor whiteColor];
            contenLabel.textAlignment = NSTextAlignmentCenter;
            contenLabel.font = [UIFont systemFontOfSize:13];
            contenLabel.numberOfLines = 0;
            [promptImageView addSubview:contenLabel];
            
            return cell;
        }
            break;

            case 6:
        {
            
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(10, 40, kMainScreenWidth-20, 50);
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.backgroundColor = BLUEBTBCOLOR;
            [button setTitle:@"重新计算" forState:UIControlStateNormal];
            button.titleLabel.font = FONT(20.f);
            [button addTarget:self action:@selector(restartToCalculate:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            return cell;
        }
            break;
            
            
        default:
            break;
    }
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    return cell;

}

-(void)promptBoxShow:(NSInteger)buttonTag
{
    if (buttonTag == 0) {
        promptImageView.frame = CGRectMake(15, 44, 193, 50);
        contenLabel.text = @"月还款额固定，所还总利息较多，适合收入稳定者。";
    }
    else{
        promptImageView.frame = CGRectMake(kMainScreenWidth - 193 - 15, 44, 193, 50);
        contenLabel.text = @"每月还款额递减，所还总利息较低，前期还款额较大。";
    }
    promptImageView.hidden = NO;
    layerButton.hidden = NO;
    self.tableView.scrollEnabled = NO;
}

-(void)layerButtonPress:(UIButton *)sender
{
    promptImageView.hidden = YES;
    sender.hidden = YES;
    self.tableView.scrollEnabled = YES;
}

-(void)firstPayProportionAction
{
    [self resignAllTextFiledFirstResponder];
    
    DLog(@"首付比");
    MyPickerView *pickerView = [[MyPickerView alloc]initWithpickerStyle:MyPickerViewShouFuBiStyle];
    pickerView.delegate = self;
    [self.window addSubview:pickerView];

}

#pragma mark - ProvideViewDelegate

-(void)yearBtnClickWithSelf:(ProvideView *)provideView;
{
    [self resignAllTextFiledFirstResponder];

   if (provideView.yearBtn.selected)
   {
       DLog(@"展开");
       MyPickerView *pickerView = [[MyPickerView alloc]initWithpickerStyle:MyPickerViewYearsStyle];
       pickerView.delegate = self;
       [self.window addSubview:pickerView];
       
   }else
   {
       DLog(@"关闭");
//       provideView.yearBtn.selected = NO;
       
   }
    
    if (provideView.tag==8800) {
        
        DLog(@"公积金");
        
    }else if (provideView.tag == 8801)
    {
        DLog(@"商业贷款");

    }
    selectProvideViewTag = provideView.tag;

    
}


#pragma mark - MyPickerViewDelegate  首付比和年限的选项

-(void)determineBtnClick:(MyPickerView *)PickerView WithChooseString:(NSString *)chooseString;
{
 
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];
    
    if (PickerView.pickerViewStyle == MyPickerViewYearsStyle)
        {
            ProvideView *view = [self viewWithTag:selectProvideViewTag];
            
            view.yearBtn.selected = NO;
            NSString *string = [chooseString stringByReplacingOccurrencesOfString:@"年限" withString:@""];
            [view.yearBtn setTitle:[NSString stringWithFormat:@"%@",string] forState:UIControlStateNormal];
            [self ayncData];
            
        }else if (PickerView.pickerViewStyle == MyPickerViewShouFuBiStyle) //设置首付比的选项
        {
            self.firstPayProportionLabel.text =[NSString stringWithFormat:@"%@",chooseString];
            
            if ([chooseString isEqualToString:@"首付比"])
            {
                if (self.mortgageCalculatorViewStyle == danJiaStyle) {
                    NSInteger indexNum = 0;
                    if ([self isPureFloat:self.provideAllMonely.text]) {
                        
                        CGFloat PercenNumber = [[NSString stringWithFormat:@"0.%zd",indexNum] doubleValue];
                        self.firstPayTF.text =  [NSString stringWithFormat:@"%.4f",PercenNumber*[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]/10000];
                        self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",(1-PercenNumber)*[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
                    }
                    [self ayncData];
   
                }else if(self.mortgageCalculatorViewStyle == zongJiaStyle){
                     self.firstPayTF.text =@"0";
                    self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.allPriceTF.text doubleValue]*10000];
                    DLog(@"");
                    
                    [self ayncData];
                }
            }else{
                if (self.mortgageCalculatorViewStyle == danJiaStyle) {
                    NSString *indexString = [chooseString stringByReplacingOccurrencesOfString:@"成" withString:@""];
                    
                    NSInteger indexNum = [indexString integerValue];
                    if ([self isPureFloat:self.provideAllMonely.text]) {
                        
                        CGFloat PercenNumber = [[NSString stringWithFormat:@"0.%zd",indexNum] doubleValue];
                        
                        self.firstPayTF.text =  [NSString stringWithFormat:@"%.4f",PercenNumber*[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]/10000];
                        self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",(1-PercenNumber)*[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
                    }
                    [self ayncData];
                }else if (self.mortgageCalculatorViewStyle == zongJiaStyle){
                    NSString *indexString = [chooseString stringByReplacingOccurrencesOfString:@"成" withString:@""];
                    NSInteger indexNum = [indexString integerValue];
                    if ([self isPureFloat:self.allPriceTF.text])
                    {
                        CGFloat PercenNumber = [[NSString stringWithFormat:@"0.%zd",indexNum] doubleValue];
                        self.firstPayTF.text = [NSString stringWithFormat:@"%.4f",PercenNumber*[self.allPriceTF.text doubleValue]];
                        self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",(1-PercenNumber)*[self.allPriceTF.text doubleValue]*10000];

                    }
                }
                
            }
            
            if ([self.provideAllMonely.text doubleValue]/10000 > 50) {
                
                gongjiView.monelyTF.text = @"50";
                shangView.monelyTF.text = [NSString stringWithFormat:@"%.2f",(([self.provideAllMonely.text doubleValue]/10000)-50) ];
                shangView.monelyTF.text = [self changeDoubleValeStringToInt:shangView.monelyTF.text];
                
            }else{
                
                gongjiView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000];
                gongjiView.monelyTF.text = [self changeDoubleValeStringToInt:gongjiView.monelyTF.text];
                shangView.monelyTF.text = @"0";
            }

        }
    [self ayncData];
    
}
-(void)tapBgViewAndCancel:(MyPickerView *)PickerView;

{
    if (PickerView.pickerViewStyle == MyPickerViewYearsStyle)
    {
        ProvideView *view = [self viewWithTag:selectProvideViewTag];
        
        view.yearBtn.selected = NO;
        
        
    }else if (PickerView.pickerViewStyle == MyPickerViewShouFuBiStyle)
    {

        
    }
    
}

#pragma mark - 开始计算

-(void)startToCalculate:(UIButton *)sender
{
    DLog(@"计算");
    
    
    if (self.unitPriceTF.text.length==0) {
        self.unitPriceTF.text = @"0";
    }
    if (self.areaTF.text.length == 0) {
        self.areaTF.text = @"0";
    }
    if (self.allPriceTF.text.length == 0) {
        self.allPriceTF.text = @"0";
    }
    
//    [self resignAllTextFiledFirstResponder];
    
    //判断负数的情况
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];
    

    if ([gongjiView.lilvTF.text doubleValue]>100 || [shangView.lilvTF.text doubleValue] > 100 || [gongjiView.lilvTF.text doubleValue]==0 || [shangView.lilvTF.text doubleValue]==0) {
     
        [TipsView showTips:@"请输入正确利率" inView:self.superview];
        return;
    }
    
    if (defaultsSectionNum == 7) {
        
        if ([self.provideAllMonely.text doubleValue] >0) {
            
            gongjiView.monelyTF.text = _gongJiCaCheData.monely;
            gongjiView.lilvTF.text = _gongJiCaCheData.lilv;
            
            shangView.monelyTF.text = _shangYeCaCheData.monely;
            shangView.lilvTF.text = _shangYeCaCheData.lilv;
            
            
             DLog(@"%@    %@    %@   %@ ",gongjiView.monelyTF.text,gongjiView.lilvTF,gongjiView.yearBtn.titleLabel.text,shangView.yearBtn.titleLabel.text);
            
            DLog(@"%@    %@    %@   %@ ",_gongJiCaCheData.monely,_shangYeCaCheData.monely,_gongJiCaCheData.lilv,_shangYeCaCheData.years);
        }
    }
    
    if ([self.firstPayTF.text doubleValue] > [self.provideAllMonely.text doubleValue]) {
        
        [TipsView showTips:@"首付不能大于贷款总额" inView:self.superview];
        
        return;
    }
    
        CGFloat gongjiYueShu = [[_gongJiCaCheData.years stringByReplacingOccurrencesOfString:@"年" withString:@""] doubleValue]*12;
        CGFloat shangyeYueShu = [[_shangYeCaCheData.years stringByReplacingOccurrencesOfString:@"年" withString:@""] doubleValue]*12;
        CGFloat gongjiMoneley = [_gongJiCaCheData.monely doubleValue]*10000;  //公积金贷款总额
        CGFloat shangyeMonely = [_shangYeCaCheData.monely doubleValue]*10000;  //商业贷款总额
            double gongLilv;
            double shangLilv;
            if ([self isPureFloat:_gongJiCaCheData.lilv]) {
                gongLilv = [[NSString stringWithFormat:@"%@%@",_gongJiCaCheData.lilv,@"%"] doubleValue]/100/12;//公积金贷款利率
            }else{
                gongLilv = [[NSString stringWithFormat:@"%@%@",@"3.25",@"%"] doubleValue]/100/12;//公积金贷款利率
            }
            if ([self isPureFloat:_shangYeCaCheData.lilv]) {
                shangLilv = [[NSString stringWithFormat:@"%@%@",_shangYeCaCheData.lilv,@"%"] doubleValue]/100/12;//公积金贷款利率
            }else{
                shangLilv = [[NSString stringWithFormat:@"%@%@",@"5.15",@"%"] doubleValue]/100/12;//公积金贷款利率
            }
            
        CGFloat gongJun = gongjiMoneley/gongjiYueShu;//公积金贷款每月所还本金
        CGFloat shangJun = shangyeMonely/shangyeYueShu;//商业贷款每月所还本金
            
        double gongJiZongHuan = 0.0;//公积金还款还款总额
        NSMutableArray *gongjiYueArr = [NSMutableArray array];
        for (NSInteger i = 0; i < gongjiYueShu; i ++) {
            //等额本金月还款
            // 月还 =   每月所还本金+(公积金贷款总额 -每月所还本金*(月数-1))*公积金月利率
            double gongjiYueHuan = gongJun+(gongjiMoneley-gongJun*i)*gongLilv;
            DLog(@"gongjiYueHuan==%f",gongjiYueHuan);
            DLog(@"gongjiYueHuan==%f",gongjiYueHuan);


            [gongjiYueArr appendObject:[NSString stringWithFormat:@"%f",gongjiYueHuan]];
            gongJiZongHuan+=gongjiYueHuan;
            
        }
        double shangYeZongHuan = 0.0; //商业还款总额
        NSMutableArray *shangYeYueArr = [NSMutableArray array];
        for (NSInteger n = 0; n<shangyeYueShu; n++) {
            double shangYeYueHuan = shangJun+(shangyeMonely-shangJun*n)*shangLilv;
            [shangYeYueArr appendObject:[NSString stringWithFormat:@"%f",shangYeYueHuan]];
          
            shangYeZongHuan+=shangYeYueHuan;
        }
            double allHuanKuan =gongJiZongHuan+shangYeZongHuan;
            //支付总利息
            double zhiFuLixi = allHuanKuan - gongjiMoneley - shangyeMonely;
            //首月还款
            double firstYueHuanKuan;
            //末月还款
            double lastYueHuanKuan;
            double secondYueHuanKuan;
           
            if (gongjiYueArr.count >0 && shangYeYueArr.count >0 )
            {
                firstYueHuanKuan = [gongjiYueArr[0] doubleValue]+[shangYeYueArr[0] doubleValue];
                secondYueHuanKuan =[gongjiYueArr[1] doubleValue]+[shangYeYueArr[1] doubleValue];
               
                lastYueHuanKuan = [[gongjiYueArr lastObject] doubleValue]+[[shangYeYueArr lastObject] doubleValue];

                if (gongjiYueArr.count > shangYeYueArr.count)
                {
                    lastYueHuanKuan = [[gongjiYueArr lastObject] doubleValue];
                }else if(gongjiYueArr.count == shangYeYueArr.count)
                {
                    lastYueHuanKuan = [[gongjiYueArr lastObject] doubleValue]+[[shangYeYueArr lastObject] doubleValue];
                }else{
                    lastYueHuanKuan = [[shangYeYueArr lastObject] doubleValue];
                }
            }else if(gongjiYueArr.count>0 && shangYeYueArr.count == 0){

                firstYueHuanKuan = [gongjiYueArr[0] doubleValue];
                secondYueHuanKuan =[gongjiYueArr[1] doubleValue];
                lastYueHuanKuan = [[gongjiYueArr lastObject] doubleValue];

            }else if(gongjiYueArr.count==0 && shangYeYueArr.count>0){
                
                firstYueHuanKuan = [shangYeYueArr[0] doubleValue];
                secondYueHuanKuan =[shangYeYueArr[1] doubleValue];
                lastYueHuanKuan = [[shangYeYueArr lastObject] doubleValue];
            }else if (gongjiYueArr.count == 0 && shangYeYueArr.count==0){
                
                firstYueHuanKuan = 0;
                secondYueHuanKuan =0;
                lastYueHuanKuan = 0;
            }
    
            DLog(@"总还款  ====%.10f   支付利息zhiFuLixi====%.10f",allHuanKuan,zhiFuLixi);
            DLog(@"总还款  ====%e   支付利息zhiFuLixi====%e",allHuanKuan,zhiFuLixi);
            DLog(@"总还款  ====%f   支付利息zhiFuLixi====%f",allHuanKuan,zhiFuLixi);

    
        if (self.mortgageCalculatorViewStyle == danJiaStyle) {
             _resultBenJinData.houseAllPrice =[NSString stringWithFormat:@"%f",[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
            
        }else if(self.mortgageCalculatorViewStyle  == zongJiaStyle){
             _resultBenJinData.houseAllPrice =[NSString stringWithFormat:@"%f",[self.allPriceTF.text doubleValue]*10000];
            
        }
    
            _resultBenJinData.daiKuanAllPrice = [NSString stringWithFormat:@"%f",[_gongJiCaCheData.monely doubleValue]+[_shangYeCaCheData.monely doubleValue]];
            _resultBenJinData.huanKuanAllPrice = [NSString stringWithFormat:@"%f",allHuanKuan];
            _resultBenJinData.ziFuLixi = [NSString stringWithFormat:@"%f",zhiFuLixi];
            _resultBenJinData.firstPay = self.firstPayTF.text;
    
    
        if ([_gongJiCaCheData.monely doubleValue]>0 && [_shangYeCaCheData.monely doubleValue]>0) {
            _resultBenJinData.nianShu =[NSString stringWithFormat:@"%g",gongjiYueShu > shangyeYueShu ?gongjiYueShu:shangyeYueShu];
        }else if ([_gongJiCaCheData.monely doubleValue]>0 && [_shangYeCaCheData.monely doubleValue] == 0){
            _resultBenJinData.nianShu =[NSString stringWithFormat:@"%g",gongjiYueShu];
            
        }else if ([_gongJiCaCheData.monely doubleValue] == 0 && [_shangYeCaCheData.monely doubleValue]> 0){
            _resultBenJinData.nianShu =[NSString stringWithFormat:@"%g",shangyeYueShu];
        }else{
            _resultBenJinData.nianShu =@"0";

        }
            _resultBenJinData.firstYuePay = [NSString stringWithFormat:@"%f",firstYueHuanKuan];
            _resultBenJinData.lastYuePay = [NSString stringWithFormat:@"%f",lastYueHuanKuan];
            _resultBenJinData.everyMonthDiminish = [NSString stringWithFormat:@"%f",firstYueHuanKuan - secondYueHuanKuan];
            
            //计算等额本息   //每月还款
    
                    //本息公积金月还款 =  公积金总钱数*公积金利率*powf(1+公积金利率,公积金月数)/(powf(1+公积金利率),公积金月数)-1)
            CGFloat benXiGongjiYueHuan = gongjiMoneley*gongLilv*powf(1+gongLilv, gongjiYueShu)/(powf(1+gongLilv, gongjiYueShu)-1);
            
            CGFloat benXiShangYeYueHuan = shangyeMonely*shangLilv*powf(1+shangLilv, shangyeYueShu)/(powf(1+shangLilv, shangyeYueShu)-1);
    
            CGFloat hehehe = benXiGongjiYueHuan + benXiShangYeYueHuan;
    
            DLog(@"等额本息=======%f   %f    %f",benXiGongjiYueHuan,benXiShangYeYueHuan,hehehe);
    
            if (self.mortgageCalculatorViewStyle == danJiaStyle) {
                _resultBenXiData.houseAllPrice =[NSString stringWithFormat:@"%f",[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
                
            }else if(self.mortgageCalculatorViewStyle  == zongJiaStyle){
                _resultBenXiData.houseAllPrice =[NSString stringWithFormat:@"%f",[self.allPriceTF.text doubleValue]*10000];
            }
            _resultBenXiData.daiKuanAllPrice = [NSString stringWithFormat:@"%f",[_gongJiCaCheData.monely doubleValue]+[_shangYeCaCheData.monely doubleValue]];
            
            _resultBenXiData.huanKuanAllPrice =[NSString stringWithFormat:@"%f",benXiGongjiYueHuan*gongjiYueShu+benXiShangYeYueHuan*shangyeYueShu];
            
            _resultBenXiData.ziFuLixi =[NSString stringWithFormat:@"%f",(benXiGongjiYueHuan*gongjiYueShu+benXiShangYeYueHuan*shangyeYueShu)-shangyeMonely-gongjiMoneley];
            _resultBenXiData.firstPay = self.firstPayTF.text;
    
            if ([_gongJiCaCheData.monely doubleValue]>0 && [_shangYeCaCheData.monely doubleValue]>0) {
                _resultBenXiData.nianShu =[NSString stringWithFormat:@"%g",gongjiYueShu > shangyeYueShu ?gongjiYueShu:shangyeYueShu];
                if (gongjiYueShu !=shangyeYueShu) {
                    
                    _resultBenXiData.lastYearsMonthMean = [NSString stringWithFormat:@"%.2f",gongjiYueShu > shangyeYueShu ?benXiGongjiYueHuan:benXiShangYeYueHuan];
                    NSInteger absNum = gongjiYueShu - shangyeYueShu;
                    NSInteger num = (NSInteger)labs(absNum)/12;
                    _resultBenXiData.lastYearsMonthMeanTitle = [NSString stringWithFormat:@"后%zd年月供",num];
                    DLog(@"%@     %@",_resultBenXiData.lastYearsMonthMeanTitle,_resultBenJinData.lastYearsMonthMean)
                    
                }else{
                    _resultBenXiData.lastYearsMonthMean = @"";
                    _resultBenXiData.lastYearsMonthMeanTitle = @"";
                    
                }
                
            }else if ([_gongJiCaCheData.monely doubleValue]>0 && [_shangYeCaCheData.monely doubleValue] == 0){
                _resultBenXiData.nianShu =[NSString stringWithFormat:@"%g",gongjiYueShu];
                
            }else if ([_gongJiCaCheData.monely doubleValue] == 0 && [_shangYeCaCheData.monely doubleValue]> 0){
                _resultBenXiData.nianShu =[NSString stringWithFormat:@"%g",shangyeYueShu];
            }else{
                _resultBenXiData.nianShu =@"0";
                _resultBenXiData.lastYearsMonthMean = @"";
                _resultBenXiData.lastYearsMonthMeanTitle = @"";
            }
            _resultBenXiData.everyMonthMean = [NSString stringWithFormat:@"%f",benXiGongjiYueHuan+benXiShangYeYueHuan];

            //计算前判断各种参数是否填写完毕
            if (defaultsSectionNum == 5)
            {
                [self ayncData];

                defaultsSectionNum = 7;
                [self.tableView reloadData];
                //刷新后把各种参数还原
            }
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.tableView reloadData];

}

-(void)restartToCalculate:(UIButton *)sender
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
//    unitPriceStyle ,   //单价
//    areaStyle,        //面积
//    firstPayStyle,    //首付
//    provideAllMonelyStyle,  //贷款总额
    
    if ([textField isEqual:self.unitPriceTF] || [textField isEqual:self.areaTF]|| [textField isEqual:self.allPriceTF]) {
        if (textField.text.length==0) {
            textField.text = @"0";
        }
    }
    
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];

    if ([textField isEqual:gongjiView.lilvTF] || [textField isEqual:shangView.lilvTF]) {
        
        if(([textField.text floatValue]>100 || [textField.text floatValue]<0 || (int)([textField.text floatValue]*100) != [textField.text floatValue]*100)){
            [TipsView showTips:@"请输入正确利率" inView:self.superview];
            
            if ([textField isEqual:gongjiView.lilvTF]) {
                textField.text = @"3.25";

            }else if([textField isEqual:shangView.lilvTF]){
                textField.text = @"5.15";
            }
        }
        
        if ([textField.text doubleValue]==0) {
            if ([textField isEqual:gongjiView.lilvTF]) {
                textField.text = @"3.25";
                
            }else if([textField isEqual:shangView.lilvTF]){
                textField.text = @"5.15";
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    DLog(@"当前的文本内容===%@    即将出现的文本内容===%@",textField.text,string);
    
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];
    
    if ([textField isEqual:self.allPriceTF]) {
        if (![string isValidNumber]) {
            return NO;
        }
        if (range.location >= 5)
            return NO;
        if (![string isEqualToString:@""])
        {
            NSRange rang = [textField.text rangeOfString:@"."];
            if ([string isEqualToString:@"."])
            {
                if (textField.text.length == 0) return NO;
                if (range.location != NSNotFound) return NO;
                
            }else{
                if (rang.location!= NSNotFound){
                    textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
            }
        }
    }

    if ([textField isEqual:self.unitPriceTF] || [textField isEqual:self.areaTF]) {
      
        if (range.location >= 9)
            return NO;
        if (![string isValidNumber]) {
            return NO;
        }
        
        if (![string isEqualToString:@""])
        {
            
            NSRange rang = [textField.text rangeOfString:@"."];
            if ([string isEqualToString:@"."])
            {
                if (textField.text.length == 0) return NO;
                if (range.location != NSNotFound) return NO;

                //限制第一个字符
            }else if ([string isEqualToString:@"0"]){
                if (textField.text.length == 0) return NO;
                if (textField.text==0) return NO;
                
            }else{
            
                if (rang.location!= NSNotFound){
                textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];

                }
            }
        }
    }
    

    if ([textField isEqual:gongjiView.monelyTF] || [textField isEqual:shangView.monelyTF]) {
        
        if (range.location >= 14)
                return NO;
            if (![string isEqualToString:@""])
            {
                NSRange rang = [textField.text rangeOfString:@"."];
                if ([string isEqualToString:@"."])
                {
                    if (textField.text.length == 0) return NO;
                    if (range.location != NSNotFound) return NO;

                }else{

                    if (rang.location!= NSNotFound){
                        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
                    }
                    
                    if ([[textField.text stringByAppendingString:string] doubleValue] > [self.provideAllMonely.text doubleValue]/10000) return NO;
                }
            }
        }

    if ([textField isEqual:gongjiView.lilvTF] || [textField isEqual:shangView.lilvTF])
        {
            if (range.location >= 5)
                return NO;
            if (![string isEqualToString:@""]) {
                NSRange range = [textField.text rangeOfString:@"."];
                if ([string isEqualToString:@"."]) {
                    if (textField.text.length == 0) return NO;
                    if (range.location != NSNotFound) return NO;
                }else {
                    if ((range.location != NSNotFound) && (range.location == textField.text.length - 3)) return NO;
                    if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) return NO;
                }
            }
            else{
//                if (textField.text.length==1) {
//                  
//                    textField.text = @"3.250";
//                }
                
            }
        }
    //首付输入实时校验 最多5位正整数 最后两个小数点
    if ([textField isEqual:self.firstPayTF]) {
      
        if (![string isEqualToString:@""]) {
            NSRange range = [textField.text rangeOfString:@"."];
            if ([string isEqualToString:@"."]) {
                if (textField.text.length == 0) return NO;
                if (range.location != NSNotFound) return NO;
            }else {
                if ((range.location != NSNotFound) && (range.location == textField.text.length - 3)) return NO;
                else if (range.location == NSNotFound && textField.text.length > 4) return NO;
                if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) return NO;
            }
        }
    }
    return YES;
}

-(void)cellTextFiledEventValueChanged:(UITextField *)textFiled
{
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];
    
        if ([textFiled isEqual:gongjiView.monelyTF]) {
    
            if ([self.provideAllMonely.text doubleValue]>0 && [gongjiView.monelyTF.text doubleValue]<=[self.provideAllMonely.text doubleValue]/10000) {
                shangView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000 - [gongjiView.monelyTF.text doubleValue]];
                shangView.monelyTF.text = [self changeDoubleValeStringToInt:shangView.monelyTF.text];
            }else{
                
               shangView.monelyTF.text = @"0";
            }
        }
    
        if ([textFiled isEqual:shangView.monelyTF]) {
    
            if ([self.provideAllMonely.text doubleValue]>0 && [shangView.monelyTF.text doubleValue]<=[self.provideAllMonely.text doubleValue]/10000) {
                gongjiView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000 - [shangView.monelyTF.text doubleValue]];
                gongjiView.monelyTF.text = [self changeDoubleValeStringToInt:gongjiView.monelyTF.text];
            }else{
                gongjiView.monelyTF.text = @"0";
                
            }
        }
    [self ayncData];

}

#pragma mark - 单价  面积 等等改变的时候时时调用

-(void)textFiledEventValueChanged:(UITextField *)textFiled
{
    ////    unitPriceStyle ,   //单价
    ////    areaStyle,        //面积
    ////    firstPayStyle,    //首付
    ////    provideAllMonelyStyle,  //贷款总额
    //    allPriceTF   总价
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];
    
    if (self.mortgageCalculatorViewStyle == danJiaStyle) {
        
        if ([self isPureFloat:self.unitPriceTF.text] && [self isPureFloat:self.areaTF.text]) {
            if ([textFiled isEqual:self.firstPayTF]) {
                if ([self.firstPayTF.text doubleValue]*10000 > [self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]) {
                    [TipsView showTips:@"您输入首付大于贷款总额" inView:self.superview];
                    self.firstPayProportionLabel.text = @"首付比";
                }else{
                    double num = [self.firstPayTF.text doubleValue]*10000/([self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]);
                    DLog(@"%f",num);
                    if (num > 0 && num < 1)
                    {
                        if (num==0.1) {
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"1"];
                        }else if (num == 0.2){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"2"];
                        }else if (num == 0.3){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"3"];
                        }else if (num == 0.4){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"4"];
                        }else if (num == 0.5){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"5"];
                        }else if (num == 0.6){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"6"];
                        }else if (num == 0.7){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"7"];
                        }else if (num == 0.8){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"8"];
                        }else if (num == 0.9){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"9"];
                        }else{
                            self.firstPayProportionLabel.text = @"首付比";
                        }
                    }
                }
            }
            
            if (![self.firstPayProportionLabel.text isEqualToString:@"首付比"]) {
                NSString *number = [self.firstPayProportionLabel.text stringByReplacingOccurrencesOfString:@"成" withString:@""];
                CGFloat PercenNumber = [[NSString stringWithFormat:@"0.%@",number] doubleValue];
                self.firstPayTF.text =  [NSString stringWithFormat:@"%.4f",PercenNumber*[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]/10000];
                self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",(1-PercenNumber)*[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
                
                if ([self.provideAllMonely.text doubleValue]/10000 > 50) {
                    gongjiView.monelyTF.text = @"50";
                    shangView.monelyTF.text = [NSString stringWithFormat:@"%.2f",(([self.provideAllMonely.text doubleValue]/10000)-50)];
                    shangView.monelyTF.text = [self changeDoubleValeStringToInt:shangView.monelyTF.text];
                }else{
                    gongjiView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000];
                    gongjiView.monelyTF.text = [self changeDoubleValeStringToInt:gongjiView.monelyTF.text];
                    shangView.monelyTF.text = @"0";
                }
                
            }else {// 不计算首付比的时候  等于首付比
                
                if ([self isPureFloat:self.firstPayTF.text]) {
                    if ([self.firstPayTF.text doubleValue]>0) {
                        
                         self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue] -[self.firstPayTF.text doubleValue]*10000];
                    }else{
                        self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
                    }
                }else{
                     self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.unitPriceTF.text doubleValue]*[self.areaTF.text doubleValue]];
                }
                
               
                if ([self.provideAllMonely.text doubleValue]/10000 > 50) {
                    gongjiView.monelyTF.text = @"50";
                    shangView.monelyTF.text = [NSString stringWithFormat:@"%.2f",(([self.provideAllMonely.text doubleValue]/10000)-50) ];
                    shangView.monelyTF.text = [self changeDoubleValeStringToInt:shangView.monelyTF.text];
                }else{
                    gongjiView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000];
                    gongjiView.monelyTF.text = [self changeDoubleValeStringToInt:gongjiView.monelyTF.text];
                    shangView.monelyTF.text = @"0";
                }
            }
        }
        
        [self ayncData];
       
    }else if (self.mortgageCalculatorViewStyle == zongJiaStyle){
        
        if ([self isPureFloat:self.allPriceTF.text]) {
            
            
            if ([textFiled isEqual:self.firstPayTF]) {
                
                if ([self.firstPayTF.text doubleValue] > [self.allPriceTF.text doubleValue]) {
                    [TipsView showTips:@"您输入首付大于贷款总额" inView:self.superview];
                    self.firstPayProportionLabel.text = @"首付比";
                }else{
                    
                    double num = [self.firstPayTF.text doubleValue]/[self.allPriceTF.text doubleValue];
                    if (num > 0 && num < 1)
                    {
                        if (num==0.1) {
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"1"];
                        }else if (num == 0.2){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"2"];
                        }else if (num == 0.3){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"3"];
                        }else if (num == 0.4){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"4"];
                        }else if (num == 0.5){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"5"];
                        }else if (num == 0.6){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"6"];
                        }else if (num == 0.7){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"7"];
                        }else if (num == 0.8){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"8"];
                        }else if (num == 0.9){
                            self.firstPayProportionLabel.text = [NSString stringWithFormat:@"%@成",@"9"];
                        }else{
                            self.firstPayProportionLabel.text = @"首付比";
                        }
                    }
                    [self ayncData];
                }
            }
            if (![self.firstPayProportionLabel.text isEqualToString:@"首付比"]) {
                
                NSString *number = [self.firstPayProportionLabel.text stringByReplacingOccurrencesOfString:@"成" withString:@""];
                CGFloat PercenNumber = [[NSString stringWithFormat:@"0.%@",number] doubleValue];
                self.firstPayTF.text = [NSString stringWithFormat:@"%.4f",PercenNumber*[self.allPriceTF.text doubleValue]];
                self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",(1-PercenNumber)*[self.allPriceTF.text doubleValue]*10000];
                
                 if ([self.provideAllMonely.text doubleValue]/10000 > 50)
                 {
                     gongjiView.monelyTF.text = @"50";
                     shangView.monelyTF.text = [NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000 - 50 ];
                     shangView.monelyTF.text = [self changeDoubleValeStringToInt:shangView.monelyTF.text];
                
                 }else{
                     gongjiView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000];
                     gongjiView.monelyTF.text = [self changeDoubleValeStringToInt:gongjiView.monelyTF.text];
                     shangView.monelyTF.text = @"0";
                 }
                
            }else{  //不计算首付的情况
                
                if ([self isPureFloat:self.firstPayTF.text]) {
                    if ([self.firstPayTF.text doubleValue]>0) {
                        
                        self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.allPriceTF.text doubleValue]*10000 -[self.firstPayTF.text doubleValue]*10000];
                    }else{
                        self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.allPriceTF.text doubleValue]*10000];
                    }
                }else{
                    
                    self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",[self.allPriceTF.text doubleValue]*10000];
                }
                
                if ([self.provideAllMonely.text doubleValue]/10000 > 50) {
                    
                    gongjiView.monelyTF.text = @"50";
                    shangView.monelyTF.text = [NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000 - 50 ];
                    shangView.monelyTF.text = [self changeDoubleValeStringToInt:shangView.monelyTF.text];
                }else{
                    gongjiView.monelyTF.text =[NSString stringWithFormat:@"%.2f",[self.provideAllMonely.text doubleValue]/10000];
                    gongjiView.monelyTF.text = [self changeDoubleValeStringToInt:gongjiView.monelyTF.text];
                    shangView.monelyTF.text = @"0";
                }
            }
        }else if ([self.allPriceTF.text doubleValue] == 0){
            NSString *number = [self.firstPayProportionLabel.text stringByReplacingOccurrencesOfString:@"成" withString:@""];
            CGFloat PercenNumber = [[NSString stringWithFormat:@"0.%@",number] doubleValue];
            self.firstPayTF.text = [NSString stringWithFormat:@"%.4f",PercenNumber*[self.allPriceTF.text doubleValue]];
            self.provideAllMonely.text = [NSString stringWithFormat:@"%.2f",(1-PercenNumber)*[self.allPriceTF.text doubleValue]*10000];
        }
        
    }
    [self ayncData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self resignAllTextFiledFirstResponder];
    
}

-(void)btnClick:(UIButton *)sender
{
    DLog(@"btnClick:(UIButton *)sender");
    if ([self.delegate respondsToSelector:@selector(select:Withindex:)])  {
        
        [self.delegate select:self Withindex:sender.tag];
    }
}


//同步数据
-(void)ayncData
{
    _unitPriceTFtext = self.unitPriceTF.text;
    _allPriceTFtext = self.allPriceTF.text;
    _areaTFtext = self.areaTF.text;
    _firstPayTFtext = self.firstPayTF.text;
    _provideAllMonelytext = self.provideAllMonely.text;
    _firstPayProportionLabelText =self.firstPayProportionLabel.text;
    
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];
    
    _gongJiCaCheData.monely = gongjiView.monelyTF.text;
    _gongJiCaCheData.years = gongjiView.yearBtn.titleLabel.text;
    _gongJiCaCheData.lilv = gongjiView.lilvTF.text;
    
    _shangYeCaCheData.monely = shangView.monelyTF.text;
    _shangYeCaCheData.years = shangView.yearBtn.titleLabel.text;
    _shangYeCaCheData.lilv = shangView.lilvTF.text;
    
}

//判断文本是否为数字

- (BOOL)isPureFloat:(NSString *)string{
    
    if (string.length >0) {
        
        NSScanner* scan = [NSScanner scannerWithString:string];
        float val;
        return [scan scanFloat:&val] && [scan isAtEnd];
    }else{
        
        return NO;
    }
   
}


#pragma mark - 让当前页面所有的输入框失去第一响应

-(void)resignAllTextFiledFirstResponder
{
    ProvideView *gongjiView = (ProvideView *)[self viewWithTag:8800];
    ProvideView *shangView = (ProvideView *)[self viewWithTag:8801];

    [gongjiView.lilvTF resignFirstResponder];
    [gongjiView.monelyTF resignFirstResponder];
    [shangView.lilvTF resignFirstResponder];
    [shangView.monelyTF resignFirstResponder];
    
    [self.unitPriceTF resignFirstResponder]; //单价
    [self.areaTF resignFirstResponder];    //面积
    [self.firstPayTF resignFirstResponder]; //首付
    [self.provideAllMonely resignFirstResponder];
    [self.allPriceTF resignFirstResponder];
    
}

- (NSString *)changeDoubleValeStringToInt:(NSString *)doubleString  //去掉小数点和后面的小数
{
   
    NSRange rang = [doubleString rangeOfString:@"."];
    if (rang.location != NSNotFound) {
        
        NSArray *stringArr = [doubleString componentsSeparatedByString:@"."];
        
        DLog(@"stringArr[0]====%@",stringArr[0]);
        
        return stringArr[0];
        
    }else{
        return doubleString;

    }
    
    
    
}




@end

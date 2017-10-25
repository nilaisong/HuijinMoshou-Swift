//
//  SeeAboutCarViewController.m
//  MoShou2
//
//  Created by wangzz on 16/8/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "SeeAboutCarViewController.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface SeeAboutCarViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView       *headerView;
    UIView       *middleView;
    NSArray      *titleArr;
    int          count;
    UIButton     *subBtn;
    UIButton     *addBtn;
    UIButton     *modifyBtn;
    UITextField  *placeTF;
    UILabel      *peopleL;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSDate    *subscribeDate;
    NSDate    *tempDate;
    UIView    *maskView;
    UIButton  *rideBtn;
}
@property (nonatomic, strong) TPKeyboardAvoidingScrollView  *scrollView;
@property (nonatomic, strong) UIView         *dateSelectView;
@property (nonatomic, strong) UIPickerView   *datePickerView;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;
@property (nonatomic, strong) NSArray        *dataSource;
@property (nonatomic, assign) BOOL           bIsTouched;

@end

@implementation SeeAboutCarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"预约专车";
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    count = 1;
    _dateArray = [[NSMutableArray alloc] init];
    _hourArray = [[NSMutableArray alloc] init];
    _minuteArray = [[NSMutableArray alloc] init];
//    _carObject = [[SeeAboutTheCarObject alloc] init];
    titleArr = @[@"约车楼盘",@"客户姓名",@"客户手机号",@"约车地点",@"约车时间",@"乘车人数"];
    
    self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height - viewTopY)];
    self.scrollView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.scrollView];
    
    [self createHeaderView];
    
    [self createMiddleView];
    
    rideBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, middleView.bottom + 20, kMainScreenWidth - 20, 44)];
    [rideBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    rideBtn.titleLabel.font = FONT(16);
    [rideBtn setBackgroundColor:LINECOLOR];
    [rideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rideBtn.layer setMasksToBounds:YES];
    [rideBtn.layer setCornerRadius:4];
    rideBtn.tag = 1003;
    [rideBtn setEnabled:NO];
    [rideBtn addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:rideBtn];

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    // Do any additional setup after loading the view.
}

- (void)createHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44*3)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:headerView];
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(16)};
    CGSize size = [@"客户手机号" sizeWithAttributes:attributes];
    for (int i=0; i<3; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 7+44*i, size.width+5, 30)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel.text = [titleArr objectForIndex:i];
        titleLabel.textColor = NAVIGATIONTITLE;
        titleLabel.font = FONT(16);
        [headerView addSubview:titleLabel];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+10, titleLabel.top, kMainScreenWidth - titleLabel.right - 10 - 16, 30)];
        contentL.textColor = NAVIGATIONTITLE;
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.font = FONT(16);
        [headerView addSubview:contentL];
        
        [headerView addSubview:[self createLineView:44*(i+1)-0.5]];
        
        switch (i) {
            case 0:
            {
                contentL.text = _carObject.estateName;
            }
                break;
            case 1:
            {
                contentL.text = _carObject.customerName;
            }
                break;
            case 2:
            {
                contentL.text = _carObject.customerMobile;
            }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)createMiddleView
{
    middleView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bottom+10, kMainScreenWidth, 44*3)];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:middleView];
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(16)};
    CGSize size = [@"客户手机号" sizeWithAttributes:attributes];
    for (int i=0; i<3; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 7+44*i, size.width+5, 30)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        titleLabel.text = [titleArr objectForIndex:i+3];
        titleLabel.textColor = NAVIGATIONTITLE;
        titleLabel.font = FONT(16);
        [middleView addSubview:titleLabel];
        
        [middleView addSubview:[self createLineView:44*(i+1)-0.5]];
        
        switch (i) {
            case 0:
            {
                placeTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right+10, titleLabel.top, kMainScreenWidth - titleLabel.right - 10 - 30, 30)];
                placeTF.delegate = self;
                placeTF.placeholder = @"请输入出发地点";
                [placeTF setValue:TFPLEASEHOLDERCOLOR forKeyPath:@"_placeholderLabel.textColor"];
                placeTF.font = FONT(15);
                placeTF.textColor = LABELCOLOR;
                placeTF.textAlignment = NSTextAlignmentRight;
                [middleView addSubview:placeTF];
                [placeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 1:
            {
                modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.right+10, titleLabel.top-10, kMainScreenWidth - titleLabel.right - 10 - 16, 44)];
                modifyBtn.titleLabel.font = FONT(15);
                modifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [modifyBtn setTitle:@"请选择约车时间" forState:UIControlStateNormal];
                [modifyBtn layoutIfNeeded];
                [modifyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 14)];
                [modifyBtn setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
                [modifyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, modifyBtn.bounds.size.width-8, 0, 0)];
                
                [modifyBtn setTitleColor:TFPLEASEHOLDERCOLOR forState:UIControlStateNormal];
                modifyBtn.tag = 1000;
                [modifyBtn addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
                [middleView addSubview:modifyBtn];
                
            }
                break;
            case 2:
            {
                UIView *countbgView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth-16-111, titleLabel.top, 111, 30)];
                countbgView.layer.cornerRadius = 4.f;
                countbgView.layer.masksToBounds = YES;
                [countbgView.layer setBorderWidth:0.5];
                countbgView.layer.borderColor = buttonBorderColor.CGColor;
                [middleView addSubview:countbgView];
                
                UILabel *cpountlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(countbgView.width/2-0.25, 5, 0.5, 20)];
                cpountlineLabel.backgroundColor = buttonBorderColor;
                [countbgView addSubview:cpountlineLabel];
                
                subBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, countbgView.width/2, countbgView.height)];
                subBtn.enabled = NO;
                subBtn.tag = 1001;
                [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_hui"] forState:UIControlStateNormal];
                [subBtn addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
                [countbgView addSubview:subBtn];
                
                addBtn = [[UIButton alloc] initWithFrame:CGRectMake(countbgView.width/2, 0, countbgView.width/2, countbgView.height)];
                addBtn.tag = 1002;
                [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_lan"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
                [countbgView addSubview:addBtn];
                
                peopleL = [[UILabel alloc] init];
                peopleL.textColor = NAVIGATIONTITLE;
                peopleL.textAlignment = NSTextAlignmentRight;
                peopleL.font = FONT(16);
                [middleView addSubview:peopleL];
                peopleL.text = @"1人";
                _carObject.followStaffCount = @"1";
                peopleL.frame = CGRectMake(titleLabel.right+10, titleLabel.top, kMainScreenWidth - titleLabel.right - countbgView.width - 10 - 20 - 16, 30);
            }
                break;
                
                
            default:
                break;
        }
    }
}

- (void)toggleButton:(UIButton*)sender
{
    NSInteger tag = sender.tag - 1000;
    switch (tag) {
        case 0:
        {
            [placeTF resignFirstResponder];
            maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
            maskView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
            [self.view addSubview:maskView];
            [self createDateSelectView];
        }
            break;
        case 1:
        {
            if (count > 1 && count <= 4) {
                count--;
                [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_lan"] forState:UIControlStateNormal];
                addBtn.enabled = YES;
                if (count == 1)
                {
                    [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_hui"] forState:UIControlStateNormal];
                    subBtn.enabled = NO;
                }
            }
            peopleL.text = [NSString stringWithFormat:@"%d人",count];
            NSString *str = [NSString stringWithFormat:@"%d",count];
            _carObject.followStaffCount = str;
        }
            break;
        case 2:
        {
            if (count < 4) {
                count++;
                [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_lan"] forState:UIControlStateNormal];
                subBtn.enabled = YES;
                if (count == 4)
                {
                    [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_hui"] forState:UIControlStateNormal];
                    addBtn.enabled = NO;
                }
            }
            peopleL.text = [NSString stringWithFormat:@"%d人",count];
            NSString *str = [NSString stringWithFormat:@"%d",count];
            _carObject.followStaffCount = str;
        }
            break;
        case 3:
        {
            [MobClick event:@"yckf_tjyc"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            if (![self isBlankString:_carObject.buildingId]) {
                [dic setValue:_carObject.buildingId forKey:@"buildingId"];
            }
            if (![self isBlankString:_carObject.customerMobile]) {
                [dic setValue:_carObject.customerMobile forKey:@"customerMobile"];
            }
            if (![self isBlankString:_carObject.customerName]) {
                [dic setValue:_carObject.customerName forKey:@"customerName"];
            }
            if (![self isBlankString:_carObject.estateCustomerId]) {
                [dic setValue:_carObject.estateCustomerId forKey:@"waitConfirmId"];
            }
            if (![self isBlankString:_carObject.subscribePlace]) {
                [dic setValue:_carObject.subscribePlace forKey:@"subscribePlace"];
            }
            if (![self isBlankString:_carObject.subscribeTime]) {
                [dic setValue:_carObject.subscribeTime forKey:@"subscribeTime"];
            }
            if (![self isBlankString:_carObject.followStaffCount]) {
                [dic setValue:_carObject.followStaffCount forKey:@"followStaffCount"];
            }
            if (!_bIsTouched) {
                _bIsTouched = YES;
                UIImageView * loadingView = [self setRotationAnimationWithView];
                __weak SeeAboutCarViewController *weakSelf = self;
                [[DataFactory sharedDataFactory] addEstateAppointCarWithDict:dic withCallBack:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (![weakSelf removeRotationAnimationView:loadingView]) {
                            return ;
                        }
                        weakSelf.bIsTouched = NO;
                        if (!result.success) {
                            [weakSelf showTips:result.message];
                        }else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"约车成功" message:[NSString stringWithFormat:@"您为%@预约的%@看房专车已预约成功，可在约车记录中查看进度，请等待司机与您联系",_carObject.customerName,_carObject.estateName] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil,nil];
                            [alert show];
                        }
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //防止多次pop发生崩溃闪退
                        
//                        });
                        
                    });
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([self.view superview]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAppointmentCarView" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAppointmentRecordView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)createDateSelectView
{
//    _carObject.trystTimeType = @"day";
//    _carObject.trystCarTime = @"3";
    NSDate *nowDate = [NSDate date];
    
    NSDate* theDate;
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    if ([_carObject.trystTimeType isEqualToString:@"day"]) {
        
        if (subscribeDate == nil) {
            tempDate = nowDate;
            [_hourArray removeAllObjects];
            [_minuteArray removeAllObjects];
            for (int i=0; i<[_carObject.trystCarTime integerValue]; i++) {
                theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"yyyy年MM月dd日";
                NSString *str = [dateFormatter stringFromDate:theDate];
                
                //        if ([str hasPrefix:@"0"]) {
                //            dateFormatter.dateFormat = @"M月dd日";
                //            str = [dateFormatter stringFromDate:theDate];
                //        }
                [_dateArray appendObject:str];
                if (i==0) {
                    dateFormatter.dateFormat = @"HH";
                    str = [dateFormatter stringFromDate:theDate];
                    for (int j=[str intValue]; j<24; j++) {
                        NSString *str = [NSString stringWithFormat:@"%02d点",j];
                        [_hourArray appendObject:str];
                    }
                    dateFormatter.dateFormat = @"mm";
                    str = [[dateFormatter stringFromDate:theDate] substringToIndex:1];
                    for (int k=[str intValue]; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }
            }
        }else
        {
            tempDate = subscribeDate;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            NSString *str = nil;
            if (dayIndex == 0) {
                [_hourArray removeAllObjects];
                [_minuteArray removeAllObjects];
                dateFormatter.dateFormat = @"HH";
                str = [dateFormatter stringFromDate:tempDate];
                NSString *nowStr = [dateFormatter stringFromDate:nowDate];
                if ([nowStr integerValue] > [str integerValue]) {
                    hourIndex = 0;
                }else
                {
                    hourIndex = [str integerValue] - [nowStr integerValue];
                }
                for (int j=[nowStr intValue]; j<24; j++) {
                    NSString *str = [NSString stringWithFormat:@"%02d点",j];
                    [_hourArray appendObject:str];
                }
                dateFormatter.dateFormat = @"mm";
                str = [[dateFormatter stringFromDate:tempDate] substringToIndex:1];
                nowStr = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
                
                if (hourIndex == 0) {
                    if ([nowStr integerValue] > [str integerValue]) {
                        minuteIndex = 0;
                    }else
                    {
                        minuteIndex = [str integerValue] - [nowStr integerValue];
                    }
                    for (int k=[nowStr intValue]; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }else
                {
                    for (int k=0; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }
            }else{
                [_hourArray removeAllObjects];
                [_minuteArray removeAllObjects];
                for (int j=0; j<24; j++) {
                    NSString *str = [NSString stringWithFormat:@"%02d点",j];
                    [_hourArray appendObject:str];
                }
                dateFormatter.dateFormat = @"HH";
                str = [dateFormatter stringFromDate:tempDate];

                hourIndex = [str integerValue];
                
                for (int k=0; k<6; k++) {
                    NSString *str = [NSString stringWithFormat:@"%d0分",k];
                    [_minuteArray appendObject:str];
                }
                dateFormatter.dateFormat = @"mm";
                str = [[dateFormatter stringFromDate:tempDate] substringToIndex:1];

                minuteIndex = [str integerValue];
            }
        }
    }else if ([_carObject.trystTimeType isEqualToString:@"hour"])
    {
        for (int i=0; i<1; i++) {
            NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
            theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *str = [dateFormatter stringFromDate:theDate];

            [_dateArray appendObject:str];
        }
    }else if ([_carObject.trystTimeType isEqualToString:@"minute"])
    {
        for (int i=0; i<1; i++) {
            NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
            theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *str = [dateFormatter stringFromDate:theDate];

            [_dateArray appendObject:str];
        }
    }
    
    _dateSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-224, kMainScreenWidth, 224)];
    _dateSelectView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:_dateSelectView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 80, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:FONT(15)];
    [cancelBtn addTarget:self action:@selector(toggleSelectCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_dateSelectView addSubview:cancelBtn];
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(_dateSelectView.width-80, 7, 80, 30)];
    [queryBtn setTitle:@"确定" forState:UIControlStateNormal];
    [queryBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [queryBtn.titleLabel setFont:FONT(15)];
    [queryBtn addTarget:self action:@selector(toggleSelectQueryButton:) forControlEvents:UIControlEventTouchUpInside];
    [_dateSelectView addSubview:queryBtn];
    
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, queryBtn.bottom+7, _dateSelectView.width, _dateSelectView.height-queryBtn.bottom)];
        _datePickerView.showsSelectionIndicator = YES;
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
        [_dateSelectView addSubview:_datePickerView];
        [_datePickerView selectRow:dayIndex inComponent:0 animated:NO];
        [_datePickerView selectRow:hourIndex inComponent:1 animated:NO];
        [_datePickerView selectRow:minuteIndex inComponent:2 animated:NO];
        [_datePickerView reloadAllComponents];
    }
    
//    [_dateSelectView addSubview:[self createLineView:_dateSelectView.height - 0.5]];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowCount = 0;
    if (component==0) {
        rowCount = _dateArray.count;
    }else if (component==1)
    {
        rowCount = _hourArray.count;
    }else if (component==2)
    {
        rowCount = _minuteArray.count;
    }
    return rowCount;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    UIColor *textColor = NAVIGATIONTITLE;
    NSString *title;
    
    if (component==0) {
        if (row==0) {
            title = @"今天";
        }else{
            //            title = [dateArray objectForIndex:row];
            NSArray *array = [NSArray array];
            if (_dateArray.count > row) {
                array = [[_dateArray objectForIndex:row] componentsSeparatedByString:@"年"];
            }
            NSString *str = array[1];
            if ([str hasPrefix:@"0"]) {
                title = [str substringFromIndex:1];
            }else{
                title = str;
            }
        }
    }
    if (component==1) {
        if (_hourArray.count > row) {
            title = [_hourArray objectForIndex:row];
        }
    }
    if (component==2) {
        if (_minuteArray.count > row) {
            title = [_minuteArray objectForIndex:row];
        }
    }
    
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return _datePickerView.width/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (_datePickerView.height-44)/5;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [pickerView reloadAllComponents];
    NSString *str = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    _dateEndLabel setLayoutMargins:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    if (component==0) {
        if (dayIndex != row) {
            if (row == 0) {
                
//                NSDate *date = nil;
//                if (tempDate == nil) {
//                    str = [_dateArray objectForIndex:dayIndex];
//                    str = [str stringByAppendingString:[_hourArray objectForIndex:hourIndex]];
//                    str = [str stringByAppendingString:[_minuteArray objectForIndex:minuteIndex]];
//                    
//                    date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
//                }else
//                {
//                    date = tempDate;
//                }
                [_hourArray removeAllObjects];
                [_minuteArray removeAllObjects];
                
                
                dateFormatter.dateFormat = @"HH";
//                str = [dateFormatter stringFromDate:date];
                
                NSDate *date = [NSDate date];
                str = [dateFormatter stringFromDate:date];
                
                if (hourIndex > [str integerValue]) {
                    hourIndex -= [str integerValue];
                }else
                {
                    hourIndex = 0;
                }
                for (int j=[str intValue]; j<24; j++) {
                    NSString *str = [NSString stringWithFormat:@"%02d点",j];
                    [_hourArray appendObject:str];
                }
                
                dateFormatter.dateFormat = @"mm";
                str = [[dateFormatter stringFromDate:date] substringToIndex:1];
                if (hourIndex==0) {
                    if (minuteIndex > [str integerValue]) {
                        minuteIndex -= [str integerValue];
                    }else
                    {
                        minuteIndex = 0;
                    }
                    for (int k=[str intValue]; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }else
                {
                    for (int k=0; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }
                
                
            }else if (dayIndex == 0)
            {
                NSDate *date = nil;
                if (tempDate == nil) {
                    if (_dateArray.count > dayIndex) {
                        str = [_dateArray objectForIndex:dayIndex];
                    }
                    if (_hourArray.count > hourIndex) {
                        str = [str stringByAppendingString:[_hourArray objectForIndex:hourIndex]];
                    }
                    if (_minuteArray.count > minuteIndex) {
                        str = [str stringByAppendingString:[_minuteArray objectForIndex:minuteIndex]];
                    }
                    
                    date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
                }else
                {
                    date = tempDate;
                }
                
                [_hourArray removeAllObjects];
                [_minuteArray removeAllObjects];
                
                dateFormatter.dateFormat = @"HH";
                str = [dateFormatter stringFromDate:date];
                for (int j=0; j<24; j++) {
                    NSString *str = [NSString stringWithFormat:@"%02d点",j];
                    [_hourArray appendObject:str];
                }
                hourIndex = [str integerValue];
                
                dateFormatter.dateFormat = @"mm";
                str = [[dateFormatter stringFromDate:date] substringToIndex:1];
                
                minuteIndex = [str integerValue];
                
                for (int k=0; k<6; k++) {
                    NSString *str = [NSString stringWithFormat:@"%d0分",k];
                    [_minuteArray appendObject:str];
                }
            }
            dayIndex = row;
            [_datePickerView reloadAllComponents];
        }
    }
    if (component==1) {
        if (hourIndex != row) {
            if (dayIndex == 0) {
                if (row == 0) {
                    NSDate *nowDate = [NSDate date];
                    NSDate *date = nil;
                    if (tempDate == nil) {
                        if (_dateArray.count > dayIndex) {
                            str = [_dateArray objectForIndex:dayIndex];
                        }
                        if (_hourArray.count > hourIndex) {
                            str = [str stringByAppendingString:[_hourArray objectForIndex:hourIndex]];
                        }
                        if (_minuteArray.count > minuteIndex) {
                            str = [str stringByAppendingString:[_minuteArray objectForIndex:minuteIndex]];
                        }
                        
                        date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
                    }else
                    {
                        date = tempDate;
                    }
                    [_minuteArray removeAllObjects];
                    
                    dateFormatter.dateFormat = @"mm";
                    str = [[dateFormatter stringFromDate:date] substringToIndex:1];
                    NSString *nowStr = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
                    if ([nowStr integerValue] < [str integerValue]) {
                        minuteIndex = [str integerValue] - [nowStr integerValue];
                    }else
                    {
                        minuteIndex = 0;
                    }
                    for (int k=[nowStr intValue]; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }else if (hourIndex == 0)
                {
                    NSDate *date = nil;
                    if (tempDate == nil) {
                        if (_dateArray.count > dayIndex) {
                            str = [_dateArray objectForIndex:dayIndex];
                        }
                        if (_hourArray.count > hourIndex) {
                            str = [str stringByAppendingString:[_hourArray objectForIndex:hourIndex]];
                        }
                        if (_minuteArray.count > minuteIndex) {
                            str = [str stringByAppendingString:[_minuteArray objectForIndex:minuteIndex]];
                        }
                        
                        date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
                    }else
                    {
                        date = tempDate;
                    }
                    [_minuteArray removeAllObjects];
                    
                    dateFormatter.dateFormat = @"mm";
                    str = [[dateFormatter stringFromDate:date] substringToIndex:1];
                    
                    minuteIndex = [str integerValue];
                    
                    for (int k=0; k<6; k++) {
                        NSString *str = [NSString stringWithFormat:@"%d0分",k];
                        [_minuteArray appendObject:str];
                    }
                }
            }
            
            hourIndex = row;
            [_datePickerView reloadAllComponents];
        }
        
    }
    if (component==2) {
        if (minuteIndex != row) {
            minuteIndex = row;
        }
    }
    [_datePickerView selectRow:dayIndex inComponent:0 animated:NO];
    [_datePickerView selectRow:hourIndex inComponent:1 animated:NO];
    [_datePickerView selectRow:minuteIndex inComponent:2 animated:NO];
    if (_dateArray.count > dayIndex) {
        str = [_dateArray objectForIndex:dayIndex];
    }
    if (_hourArray.count > hourIndex) {
        str = [str stringByAppendingString:[_hourArray objectForIndex:hourIndex]];
    }
    if (_minuteArray.count > minuteIndex) {
        str = [str stringByAppendingString:[_minuteArray objectForIndex:minuteIndex]];
    }
    
    NSDate *date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
    
    tempDate = date;
}

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

- (void)toggleSelectCancleButton:(UIButton*)sender
{
    tempDate = nil;
    [maskView removeFromSuperview];
    [_dateSelectView removeAllSubviews];
    [_dateSelectView removeFromSuperview];
    [_datePickerView removeFromSuperview];
    _datePickerView = nil;
}

- (void)toggleSelectQueryButton:(UIButton*)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM月dd日 HH:mm";
    if (tempDate != nil) {
        NSString *str = [dateFormatter stringFromDate:tempDate];
        if ([str hasPrefix:@"0"]) {
            str = [str substringFromIndex:1];
            str = [str substringToIndex:10];
            str = [str stringByAppendingString:@"0"];
        }else
        {
            str = [str substringToIndex:11];
            str = [str stringByAppendingString:@"0"];
        }
        
        [modifyBtn setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        [modifyBtn setTitleColor:LABELCOLOR forState:UIControlStateNormal];
        
        subscribeDate = tempDate;
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        str = [dateFormatter stringFromDate:subscribeDate];
        _carObject.subscribeTime = str;
        tempDate = nil;
        
        
    }
    [maskView removeFromSuperview];
    [_dateSelectView removeAllSubviews];
    [_dateSelectView removeFromSuperview];
    [_datePickerView removeFromSuperview];
    _datePickerView = nil;
    
    if (placeTF.text.length>0 && ![modifyBtn.titleLabel.text isEqualToString:@"请选择约车时间"]) {
        [rideBtn setBackgroundColor:BLUEBTBCOLOR];
        [rideBtn setEnabled:YES];
    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    _carObject.subscribePlace = textField.text;
    if (textField.text.length>0 && ![modifyBtn.titleLabel.text isEqualToString:@"请选择约车时间"]) {
        [rideBtn setBackgroundColor:BLUEBTBCOLOR];
        [rideBtn setEnabled:YES];
    }
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
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

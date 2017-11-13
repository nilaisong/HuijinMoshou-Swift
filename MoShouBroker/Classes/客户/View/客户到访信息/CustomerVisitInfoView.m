//
//  CustomerVisitInfoView.m
//  MoShou2
//
//  Created by wangzz on 16/6/27.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerVisitInfoView.h"
#import "ConfirmUserListView.h"

#define widthScale  710.0/750
#define heightScale 1110.0/1333
#define BUTTON_HEIGHT                  30               //按钮高

@interface CustomerVisitInfoView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int _row;
    CGFloat _allWidth;
    NSMutableArray *_itemArray;
    
    //记录位置
    NSInteger yearIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSDate    *tempDate;
    BOOL      bIsStartDateButton;
}

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UILabel        *dateStartLabel;
@property (nonatomic, strong) UILabel        *dateEndLabel;
@property (nonatomic, strong) UILabel        *countVisitLabel;
@property (nonatomic, copy) NSString         *transfStr;
@property (nonatomic, strong) NSDate         *startDate;
@property (nonatomic, strong) NSDate         *endDate;

@property (nonatomic, strong) UIView         *customerView;
@property (nonatomic, strong) UIView         *dateSelectView;//时间选择view
@property (nonatomic, strong) UIView         *dateView;//预计到访时间
@property (nonatomic, strong) UIView         *countView;//预计到访人数
@property (nonatomic, strong) UIView         *transfView;//到访交通方式
@property (nonatomic, strong) UIButton       *subBtn;
@property (nonatomic, strong) UIButton       *addBtn;
@property (nonatomic, strong) UIPickerView   *datePickerView;//时间选择控件
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;
@property (nonatomic, strong) NSArray        *dataSource;
@property (nonatomic, assign) int            count;

@property (nonatomic, strong) UIView         *confirmView;//确客信息
@property (nonatomic, strong) UILabel        *confirmUserLabel;

@end

@implementation CustomerVisitInfoView
@synthesize customerView;
@synthesize dateSelectView;
@synthesize dateView;
@synthesize countView;
@synthesize transfView;
@synthesize scrollView;
@synthesize subBtn;
@synthesize addBtn;
@synthesize datePickerView;
@synthesize dateArray;
@synthesize hourArray;
@synthesize minuteArray;
@synthesize dataSource;
@synthesize count;

@synthesize confirmView;
@synthesize confirmUserLabel;

@synthesize startDate;
@synthesize endDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.3];
        dataSource = @[@"公交",@"自驾",@"班车"];
        count = 1;
        
        [self layoutUI];
    }
    return self;
}

-(void)setVisitInfoData:(CustomerVisitInfoData *)visitInfoData
{
    if (_visitInfoData != visitInfoData) {
        _visitInfoData = visitInfoData;
    }
    [self updateVisitInfoData];
}

-(void)setConfirmInfoData:(ConfirmUserInfoObject *)confirmInfoData
{
    if (_confirmInfoData != confirmInfoData) {
        _confirmInfoData = confirmInfoData;
    }
    [self updateConfirmInfoData];
}

-(void)setBIsShowConfirm:(BOOL)bIsShowConfirm
{
    if (_bIsShowConfirm != bIsShowConfirm) {
        _bIsShowConfirm = bIsShowConfirm;
    }
    if (_bIsShowConfirm) {
        confirmView.hidden = NO;
        scrollView.contentSize = CGSizeMake(scrollView.width, confirmView.bottom+10);
    }
}

- (void)updateVisitInfoData
{
    startDate = _visitInfoData.startDate;
    endDate = _visitInfoData.endDate;
    _dateStartLabel.text = _visitInfoData.startDateStr;
    _dateEndLabel.textColor = BLUEBTBCOLOR;
    _dateEndLabel.text = _visitInfoData.endDateStr;
    _countVisitLabel.text = _visitInfoData.visitCount;
    count = [[_countVisitLabel.text substringToIndex:_countVisitLabel.text.length-1] intValue];
    if (count == 10) {
        [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_lan"] forState:UIControlStateNormal];
        subBtn.enabled = YES;
        [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_hui"] forState:UIControlStateNormal];
        addBtn.enabled = NO;
    }else if (count > 1 && count <= 10) {
        [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_lan"] forState:UIControlStateNormal];
        subBtn.enabled = YES;
    }
    _transfStr = _visitInfoData.transfFunc;
    for (int i=0; i<dataSource.count; i++) {
        if ([_transfStr isEqualToString:[dataSource objectForIndex:i]]) {
            UIButton *button = (UIButton*)[transfView viewWithTag:100+i];
            button.selected = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:BLUEBTBCOLOR];
            button.layer.borderColor = BLUEBTBCOLOR.CGColor;
        }
    }
}

- (void)updateConfirmInfoData
{
    confirmUserLabel.text = _confirmInfoData.confirmUserName;
}

- (void)layoutUI
{
    customerView = [[UIView alloc] initWithFrame:CGRectMake(self.width*(1-widthScale)/2, self.height*(1-heightScale)/2, self.width*widthScale, self.height*heightScale)];
    customerView.backgroundColor = BACKGROUNDCOLOR;
    [customerView.layer setCornerRadius:10.0];
    [customerView.layer setMasksToBounds:YES];
    [self addSubview:customerView];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 40, 40)];
    [cancleBtn setImage:[UIImage imageNamed:@"button_visitinfo_delete"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(toggleCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [customerView addSubview:cancleBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerView.width/2-90, 7, 180, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"客户报备信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    titleLabel.textColor =NAVIGATIONTITLE;
    [customerView addSubview:titleLabel];
    
    [customerView addSubview:[self createLineView:49.5]];
    
    [self createScrollView];
    
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, customerView.height-48, customerView.width, 48)];
    saveBtn.backgroundColor = BLUEBTBCOLOR;
    saveBtn.titleLabel.font = FONT(17);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [saveBtn setImage:[UIImage imageNamed:@"button_visitinfo_save@3x"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(toggleSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [customerView addSubview:saveBtn];
}

- (void)createScrollView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, customerView.width, customerView.height - 50 - 48)];
    scrollView.backgroundColor = [UIColor clearColor];
    [customerView addSubview:scrollView];
    
    
    
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 68)];
    dateView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:dateView];
    
    NSString *str = @"预计到访时间";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize size = [str sizeWithAttributes:attributes];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, size.width, 30)];
    label.text = str;
    label.font = FONT(15);
    label.textColor = NAVIGATIONTITLE;
    [dateView addSubview:label];
    
    UIView *datebgView = [[UIView alloc] initWithFrame:CGRectMake(label.right+10, 12, scrollView.width-label.right-20, 44)];
    datebgView.layer.cornerRadius = 4.f;
    datebgView.layer.masksToBounds = YES;
    [datebgView.layer setBorderWidth:0.5];
    datebgView.layer.borderColor = buttonBorderColor.CGColor;
    [dateView addSubview:datebgView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(datebgView.width/2-0.25, 9, 0.5, 26)];
    lineLabel.backgroundColor = buttonBorderColor;
    [datebgView addSubview:lineLabel];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lineLabel.left, 22)];
    startLabel.text = @"开始时间";
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.textColor = LABELCOLOR;
    startLabel.font = FONT(12);
    startLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:startLabel];
    
    _dateStartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startLabel.bottom, startLabel.width, 22)];
    _dateStartLabel.text = @"选择时间";
    _dateStartLabel.textAlignment = NSTextAlignmentCenter;
    _dateStartLabel.textColor = BLUEBTBCOLOR;
    _dateStartLabel.font = FONT(10);
    _dateStartLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:_dateStartLabel];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, datebgView.width/2, datebgView.height)];
    [startBtn setBackgroundColor:[UIColor clearColor]];
    [startBtn addTarget:self action:@selector(toggleStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [datebgView addSubview:startBtn];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineLabel.left, 0, lineLabel.left, 22)];
    endLabel.text = @"结束时间";
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.textColor = LABELCOLOR;
    endLabel.font = FONT(12);
    endLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:endLabel];
    
    _dateEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(endLabel.left, endLabel.bottom, endLabel.width, 22)];
    _dateEndLabel.text = @"—";
    _dateEndLabel.textAlignment = NSTextAlignmentCenter;
    _dateEndLabel.textColor = LABELCOLOR;
    _dateEndLabel.font = FONT(10);
    _dateEndLabel.backgroundColor = [UIColor clearColor];
    [datebgView addSubview:_dateEndLabel];
    
    UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(datebgView.width/2, 0, datebgView.width/2, datebgView.height)];
    [endBtn setBackgroundColor:[UIColor clearColor]];
    [endBtn addTarget:self action:@selector(toggleEndButton:) forControlEvents:UIControlEventTouchUpInside];
    [datebgView addSubview:endBtn];
    
    [dateView addSubview:[self createLineView:dateView.height-0.5]];
    
    [self createDateSelectView];
    
    countView = [[UIView alloc] initWithFrame:CGRectMake(0, dateView.bottom+10, scrollView.width, 59)];
    countView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:countView];
    
    [countView addSubview:[self createLineView:0]];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, size.width, 30)];
    label2.text = @"预计到访人数";
    label2.font = FONT(15);
    label2.textColor = NAVIGATIONTITLE;
    [countView addSubview:label2];
    
    _countVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(countView.width/2, label2.top, 50, 30)];
    _countVisitLabel.text = @"1人";
    _countVisitLabel.font = FONT(15);
    _countVisitLabel.textColor = NAVIGATIONTITLE;
    [countView addSubview:_countVisitLabel];
    
    UIView *countbgView = [[UIView alloc] initWithFrame:CGRectMake(_countVisitLabel.right, 12, scrollView.width-_countVisitLabel.right-10, 34)];
    countbgView.layer.cornerRadius = 4.f;
    countbgView.layer.masksToBounds = YES;
    [countbgView.layer setBorderWidth:0.5];
    countbgView.layer.borderColor = buttonBorderColor.CGColor;
    [countView addSubview:countbgView];
    
    UILabel *cpountlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(countbgView.width/2-0.25, 5, 0.5, 24)];
    cpountlineLabel.backgroundColor = buttonBorderColor;
    [countbgView addSubview:cpountlineLabel];
    
    subBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, countbgView.width/2, countbgView.height)];
    subBtn.enabled = NO;
    [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_hui"] forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(toggleSubButton:) forControlEvents:UIControlEventTouchUpInside];
    [countbgView addSubview:subBtn];
    
    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(countbgView.width/2, 0, countbgView.width/2, countbgView.height)];
    [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_lan"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(toggleAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [countbgView addSubview:addBtn];
    
    [countView addSubview:[self createLineView:countView.height - 0.5]];
    
    transfView = [[UIView alloc] initWithFrame:CGRectMake(0, countView.bottom+10, scrollView.width, 90)];
    transfView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:transfView];
    
    [transfView addSubview:[self createLineView:0]];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, size.width, 30)];
    label3.text = @"到访交通方式";
    label3.font = FONT(15);
    label3.textColor = NAVIGATIONTITLE;
    [transfView addSubview:label3];
    
    
    _itemArray = [[NSMutableArray alloc] init];
    CGFloat btnWidth = (scrollView.width-(10+10+2*20))/3;
    for (int i = 0; i < dataSource.count; i ++) {
        NSString *str = dataSource[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = FONT(12);
        button.layer.cornerRadius = 4.f;
        button.layer.masksToBounds = YES;
        [button.layer setBorderWidth:0.5];
        if (!button.enabled) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:BLUEBTBCOLOR];
            button.layer.borderColor = BLUEBTBCOLOR.CGColor;
            
        }else
        {
            [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.layer.borderColor = buttonBorderColor.CGColor;
        }
        
        button.tag = i+100;
        button.frame = CGRectMake(10+20*i+btnWidth*i, label3.bottom+7, btnWidth, BUTTON_HEIGHT);
        
        _allWidth += (button.width + 20);
        
        [transfView addSubview:button];
        [_itemArray appendObject:button];
        
    }
    
    [transfView addSubview:[self createLineView:transfView.height - 0.5]];
    scrollView.contentSize = CGSizeMake(scrollView.width, transfView.bottom+10);
    
//    if (_bIsShowConfirm) {
        confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, transfView.bottom+10, scrollView.width, 44)];
        confirmView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:confirmView];
        
        [confirmView addSubview:[self createLineView:0]];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, size.width, 30)];
        label4.text = @"选择确客专员";
        label4.font = FONT(15);
        label4.textColor = NAVIGATIONTITLE;
        label4.textAlignment = NSTextAlignmentLeft;
        [confirmView addSubview:label4];
        
        confirmUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(label4.right + 10, label4.top, scrollView.width-label4.right-10-23, 30)];
        confirmUserLabel.font = FONT(14);
        confirmUserLabel.textAlignment = NSTextAlignmentRight;
        confirmUserLabel.textColor = NAVIGATIONTITLE;
        [confirmView addSubview:confirmUserLabel];
        
        UIImageView *btnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(confirmView.width - 18, 15, 8, 14)];
        [btnImgView setImage:[UIImage imageNamed:@"arrow-right"]];
        [confirmView addSubview:btnImgView];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, confirmView.width, confirmView.height)];
        confirmBtn.backgroundColor = [UIColor clearColor];
        [confirmBtn addTarget:self action:@selector(toggleConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        [confirmView addSubview:confirmBtn];
    
        [confirmView addSubview:[self createLineView:confirmView.height-0.5]];
    
    confirmView.hidden = YES;
    
//    }
}

- (void)createDateSelectView
{
    dateArray = [[NSMutableArray alloc] init];
    hourArray = [[NSMutableArray alloc] init];
    minuteArray = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        NSDate*nowDate = [NSDate date];
        NSDate* theDate;
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
        NSString *str = [dateFormatter stringFromDate:theDate];
        
//        if ([str hasPrefix:@"0"]) {
//            dateFormatter.dateFormat = @"M月dd日";
//            str = [dateFormatter stringFromDate:theDate];
//        }
        [dateArray appendObject:str];
    }
    for (int i=0; i<24; i++) {
        NSString *str = [NSString stringWithFormat:@"%02d点",i];
        [hourArray appendObject:str];
    }
    for (int i=0; i<6; i++) {
        NSString *str = [NSString stringWithFormat:@"%d0分",i];
        [minuteArray appendObject:str];
    }
    
    dateSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, dateView.bottom, scrollView.width, 224)];
    dateSelectView.hidden = YES;
    dateSelectView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:dateSelectView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 80, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:FONT(15)];
    [cancelBtn addTarget:self action:@selector(toggleSelectCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [dateSelectView addSubview:cancelBtn];
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake(dateSelectView.width-80, 7, 80, 30)];
    [queryBtn setTitle:@"确定" forState:UIControlStateNormal];
    [queryBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [queryBtn.titleLabel setFont:FONT(15)];
    [queryBtn addTarget:self action:@selector(toggleSelectQueryButton:) forControlEvents:UIControlEventTouchUpInside];
    [dateSelectView addSubview:queryBtn];
    
    if (!datePickerView) {
        datePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, queryBtn.bottom+7, dateSelectView.width, dateSelectView.height-queryBtn.bottom-7-0.5)];
        datePickerView.showsSelectionIndicator = YES;
        datePickerView.backgroundColor = [UIColor whiteColor];
        datePickerView.delegate = self;
        datePickerView.dataSource = self;
        [dateSelectView addSubview:datePickerView];
    }
    
    [dateSelectView addSubview:[self createLineView:dateSelectView.height - 0.5]];
}
#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, customerView.width, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
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
        rowCount = dateArray.count;
    }else if (component==1)
    {
        rowCount = hourArray.count;
    }else if (component==2)
    {
        rowCount = minuteArray.count;
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
            NSArray *array = [[NSArray alloc] init];
            if (dateArray.count > row) {
                array = [[dateArray objectForIndex:row] componentsSeparatedByString:@"年"];
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
        if (hourArray.count > row) {
            title = [hourArray objectForIndex:row];
        }
    }
    if (component==2) {
        if (minuteArray.count > row) {
            title = [minuteArray objectForIndex:row];
        }
    }
    
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return datePickerView.width/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (datePickerView.height-44)/5;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [pickerView reloadAllComponents];
    NSString *str = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    _dateEndLabel setLayoutMargins:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    if (component==0) {
        dayIndex = row;
    }
    if (component==1) {
        hourIndex = row;
    }
    if (component==2) {
        minuteIndex = row;
    }
    if (dateArray.count > dayIndex) {
        str = [dateArray objectForIndex:dayIndex];
    }
    if (hourArray.count > hourIndex) {
        str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
    }
    if (minuteArray.count > minuteIndex) {
        str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
    }
    
    NSDate *date = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
    NSDate *nowDate = [NSDate date];
    if (bIsStartDateButton) {
        if ([date compare:nowDate] == NSOrderedAscending) {
            
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *str = [dateFormatter stringFromDate:nowDate];
            for (int i=0; i<dateArray.count; i++) {
                if ([str isEqualToString:[dateArray objectForIndex:i]]) {
                    dayIndex = i;
                    [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
                }
            }
            
            dateFormatter.dateFormat = @"HH";
            str = [dateFormatter stringFromDate:nowDate];
            [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
            hourIndex = [str integerValue];
            
            dateFormatter.dateFormat = @"mm";
            str = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
            [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
            minuteIndex = [str integerValue];
            tempDate = nowDate;
            if ((0 < [[[dateFormatter stringFromDate:nowDate] substringFromIndex:1] integerValue])) {
                if (minuteIndex==minuteArray.count-1) {
                    hourIndex += 1;
                    [datePickerView selectRow:hourIndex inComponent:1 animated:YES];
                    minuteIndex = 0;
                    [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
                }else
                {
                    minuteIndex += 1;
                    [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
                }
                if (dateArray.count > dayIndex) {
                    str = [dateArray objectForIndex:dayIndex];
                }
                if (hourArray.count > hourIndex) {
                    str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
                }
                if (minuteArray.count > minuteIndex) {
                    str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
                }
                startDate = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
                tempDate = startDate;
            }
            
            
        }else if ([date compare:nowDate] == NSOrderedDescending){
            tempDate = date;
        }
    }else
    {
        if ([date compare:startDate] == NSOrderedAscending) {
            dateFormatter.dateFormat = @"yyyy年MM月dd日";
            NSString *str = [dateFormatter stringFromDate:startDate];
            for (int i=0; i<dateArray.count; i++) {
                if ([str isEqualToString:[dateArray objectForIndex:i]]) {
                    dayIndex = i;
                    [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
                }
            }
            
            dateFormatter.dateFormat = @"HH";
            str = [dateFormatter stringFromDate:startDate];
            [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
            hourIndex = [str integerValue];
            
            dateFormatter.dateFormat = @"mm";
            str = [[dateFormatter stringFromDate:startDate] substringToIndex:1];
            [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
            minuteIndex = [str integerValue];
            
            tempDate = startDate;
        }else if ([date compare:startDate] == NSOrderedDescending){
            tempDate = date;
        }
    }
}
#pragma mark-------------button响应事件
- (void)buttonAction:(UIButton *)sender {
    for (UIButton *item in _itemArray) {
        item.selected = NO;
        [item setTitleColor:LABELCOLOR forState:UIControlStateNormal];
        [item setBackgroundColor:[UIColor whiteColor]];
        item.layer.borderColor = buttonBorderColor.CGColor;
        
        if (item == sender) {
            sender.selected = YES;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundColor:BLUEBTBCOLOR];
            sender.layer.borderColor = BLUEBTBCOLOR.CGColor;
        }
    }
    if (dataSource.count > sender.tag - 100) {
        _transfStr = [dataSource objectForIndex:sender.tag - 100];
    }
    sender.selected = !sender.selected;
}

- (void)toggleCancleButton:(UIButton*)sender
{
    self.didSelectedCancelBtn();
    [self removeFromSuperview];
}
#pragma mark - 保存按钮
- (void)toggleSaveButton:(UIButton*)sedner
{
    CustomerVisitInfoData *visitData = [[CustomerVisitInfoData alloc] init];
    visitData.startDate = startDate;
    visitData.endDate = endDate;
    visitData.startDateStr = _dateStartLabel.text;
    visitData.endDateStr = _dateEndLabel.text;
    visitData.visitCount = _countVisitLabel.text;
    visitData.transfFunc = _transfStr;
    
    _didSelectedSaveBtn(visitData,_confirmInfoData);
}

- (void)toggleStartButton:(UIButton*)sender
{
    dateSelectView.hidden = NO;
    countView.top = dateSelectView.bottom+10;
    transfView.top = countView.bottom+10;
    bIsStartDateButton = YES;
    
    NSDate *nowDate;
    if (startDate == nil) {
        nowDate = [NSDate date];
        tempDate = nowDate;
    }else
    {
        nowDate = startDate;
        tempDate = nowDate;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *str = [dateFormatter stringFromDate:nowDate];
    for (int i=0; i<dateArray.count; i++) {
        if ([str isEqualToString:[dateArray objectForIndex:i]]) {
            dayIndex = i;
            [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
        }
    }
    
    dateFormatter.dateFormat = @"HH";
    str = [dateFormatter stringFromDate:nowDate];
    [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
    hourIndex = [str integerValue];
    
    dateFormatter.dateFormat = @"mm";
    str = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
    [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
    minuteIndex = [str integerValue];
    
    if ((0 < [[[dateFormatter stringFromDate:nowDate] substringFromIndex:1] integerValue])) {
        if (minuteIndex==minuteArray.count-1) {
            hourIndex += 1;
            [datePickerView selectRow:hourIndex inComponent:1 animated:YES];
            minuteIndex = 0;
            [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
        }else
        {
            minuteIndex += 1;
            [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
        }
    }
    
    if (startDate == nil) {
        if (dateArray.count > dayIndex) {
            str = [dateArray objectForIndex:dayIndex];
        }
        if (hourArray.count > hourIndex) {
            str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
        }
        if (minuteArray.count > minuteIndex) {
            str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
        }
        
        startDate = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
        tempDate = startDate;
    }
    if (_bIsShowConfirm) {
        confirmView.top = transfView.bottom+10;
        scrollView.contentSize = CGSizeMake(0, confirmView.bottom+10);
    }else
    {
        scrollView.contentSize = CGSizeMake(0, transfView.bottom+10);
    }
    
}

- (void)toggleEndButton:(UIButton*)sedner
{
    if ([_dateStartLabel.text isEqualToString:@"选择时间"]) {
        //提示语：请先设置开始时间
        self.didShowTip();
    }else
    {
        dateSelectView.hidden = NO;
        bIsStartDateButton = NO;
        countView.top = dateSelectView.bottom+10;
        transfView.top = countView.bottom+10;
        if (_bIsShowConfirm) {
            confirmView.top = transfView.bottom+10;
            scrollView.contentSize = CGSizeMake(0, confirmView.bottom+10);
        }else
        {
            scrollView.contentSize = CGSizeMake(0, transfView.bottom+10);
        }
        
        NSDate *nowDate;
        if (endDate == nil) {
            nowDate = startDate;
            tempDate = nowDate;
        }else
        {
            if ([endDate compare:startDate] == NSOrderedAscending) {
                nowDate = startDate;
            }else {
                nowDate = endDate;
            }
            tempDate = nowDate;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
        NSString *str = [dateFormatter stringFromDate:nowDate];
        for (int i=0; i<dateArray.count; i++) {
            if ([str isEqualToString:[dateArray objectForIndex:i]]) {
                dayIndex = i;
                [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
            }
        }
        
        dateFormatter.dateFormat = @"HH";
        str = [dateFormatter stringFromDate:nowDate];
        [datePickerView selectRow:[str integerValue] inComponent:1 animated:YES];
        hourIndex = [str integerValue];
        
        dateFormatter.dateFormat = @"mm";
        str = [[dateFormatter stringFromDate:nowDate] substringToIndex:1];
        [datePickerView selectRow:[str integerValue] inComponent:2 animated:YES];
        minuteIndex = [str integerValue];
        if (endDate == nil) {
            if (dateArray.count > dayIndex) {
                str = [dateArray objectForIndex:dayIndex];
            }
            if (hourArray.count > hourIndex) {
                str = [str stringByAppendingString:[hourArray objectForIndex:hourIndex]];
            }
            if (minuteArray.count > minuteIndex) {
                str = [str stringByAppendingString:[minuteArray objectForIndex:minuteIndex]];
            }
            
            endDate = [self dateFromString:str withFormat:@"yyyy年MM月dd日HH点mm分"];
        }
    }
}

- (void)toggleSubButton:(UIButton*)sender
{
    if (count > 1 && count <= 10) {
        count--;
        [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_lan"] forState:UIControlStateNormal];
        addBtn.enabled = YES;
        if (count == 1)
        {
            [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_hui"] forState:UIControlStateNormal];
            subBtn.enabled = NO;
        }
    }
    _countVisitLabel.text = [NSString stringWithFormat:@"%d人",count];
}

- (void)toggleAddButton:(UIButton*)sender
{
    if (count < 10) {
        count++;
        [subBtn setImage:[UIImage imageNamed:@"button_visitinfo_sub_lan"] forState:UIControlStateNormal];
        subBtn.enabled = YES;
        if (count == 10)
        {
            [addBtn setImage:[UIImage imageNamed:@"button_visitinfo_add_hui"] forState:UIControlStateNormal];
            addBtn.enabled = NO;
        }
    }
    _countVisitLabel.text = [NSString stringWithFormat:@"%d人",count];
}

- (void)toggleSelectCancleButton:(UIButton*)sender
{
    dateSelectView.hidden = YES;
    countView.top = dateView.bottom+10;
    transfView.top = countView.bottom+10;
    if (_bIsShowConfirm) {
        confirmView.top = transfView.bottom + 10;
        scrollView.contentSize = CGSizeMake(0, confirmView.bottom+10);
    }else
    {
        scrollView.contentSize = CGSizeMake(0, transfView.bottom+10);
    }
}

- (void)toggleSelectQueryButton:(UIButton*)sender
{
    if (bIsStartDateButton) {
        bIsStartDateButton = NO;
        startDate = tempDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM月dd日 HH:mm";
        NSString *str = [dateFormatter stringFromDate:startDate];
        if ([str hasPrefix:@"0"]) {
            str = [str substringFromIndex:1];
            str = [str substringToIndex:10];
            str = [str stringByAppendingString:@"0"];
        }else
        {
            str = [str substringToIndex:11];
            str = [str stringByAppendingString:@"0"];
        }
        _dateStartLabel.text = str;
//        _dateStartLabel.textColor = LABELCOLOR;
        
        _dateEndLabel.text = @"选择时间";
        _dateEndLabel.textColor = BLUEBTBCOLOR;
        
        [datePickerView selectRow:dayIndex inComponent:0 animated:YES];
        [datePickerView selectRow:hourIndex inComponent:1 animated:YES];
        [datePickerView selectRow:minuteIndex inComponent:2 animated:YES];
        
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM月dd日 HH:mm";
        endDate = tempDate;
        if (endDate == nil) {
            endDate = startDate;
        }
        NSString *str = [dateFormatter stringFromDate:endDate];
        if ([str hasPrefix:@"0"]) {
            str = [str substringFromIndex:1];
            str = [str substringToIndex:10];
            str = [str stringByAppendingString:@"0"];
        }else
        {
            str = [str substringToIndex:11];
            str = [str stringByAppendingString:@"0"];
        }
        _dateEndLabel.text = str;
//        _dateEndLabel.textColor = BLUEBTBCOLOR;
        
//        _dateStartLabel.textColor = BLUEBTBCOLOR;
        
        dateSelectView.hidden = YES;
        countView.top = dateView.bottom+10;
        transfView.top = countView.bottom+10;
        if (_bIsShowConfirm) {
            confirmView.top = transfView.bottom + 10;
            scrollView.contentSize = CGSizeMake(0, confirmView.bottom+10);
        }else
        {
            scrollView.contentSize = CGSizeMake(0, transfView.bottom+10);
        }
    }
}

- (void)toggleConfirmButton:(UIButton*)sender
{
//    self.hidden = YES;
    ConfirmUserListView *listView = [[ConfirmUserListView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    listView.selectedData = _confirmInfoData;
    listView.confirmArray = _confirmMutArr;
    __weak CustomerVisitInfoView *weakSelf = self;
    [listView concelConfirmUserCellBlock:^{
    }];
    [listView selectConfirmUserCellBlock:^(ConfirmUserInfoObject *confirmObj) {
        weakSelf.confirmInfoData = confirmObj;
        weakSelf.confirmUserLabel.text = confirmObj.confirmUserName;
        [listView removeFromSuperview];
//        weakSelf.hidden = NO;
    }];
    [self addSubview:listView];
}

- (void)seleteEndDateBlock:(showtipEndDateBlock)ablock
{
    self.didShowTip = ablock;
}

- (void)seleteSaveButtonBlock:(saveButtonSelectedBlock)ablock
{
    [MobClick event:@"khdf_xxbc"];
    self.didSelectedSaveBtn = ablock;
}

- (void)seleteCancelButtonBlock:(cancelButtonSelectedBlock)ablock
{
    self.didSelectedCancelBtn = ablock;
}

//根据string返回date
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

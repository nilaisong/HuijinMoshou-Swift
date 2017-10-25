//
//  CustAddFollowViewController.m
//  MoShou2
//
//  Created by wangzz on 2017/2/27.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "CustAddFollowViewController.h"
#import "CustomerTextView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "DataFactory+Customer.h"
@interface CustAddFollowViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel          *buildNameL;
//@property (nonatomic, strong) UIButton       *buildBtn;
@property (nonatomic, strong) UIButton         *confirmBtn;
@property (nonatomic, strong) CustomerTextView *followTV;
@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) UIView           *tableBgView;
@property (nonatomic, strong) UIView           *grayBgView;
@property (nonatomic, strong) UIImageView      *iconImgView;
@property (nonatomic, copy)   NSString         *buildId;
@property (nonatomic, strong) NSMutableArray   *buildingTradeArray;
@property (nonatomic, assign) BOOL             bIsTouched;
@property (nonatomic, strong) UIView           *followBgView;
@property (nonatomic, assign) NSInteger        selectedIndex;

@end

@implementation CustAddFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"添加跟进";
    
    _buildingTradeArray = [[NSMutableArray alloc] init];
    _selectedIndex = 0;
    [self hasNetwork];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleNewFollowView:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
}

- (void)hasNetwork
{
    __weak typeof(self) weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:_customerId]) {
        [dic setValue:_customerId forKey:@"custProfileId"];
    }
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getReportBuildingWithDic:dic WithCallBack:^(ActionResult *result, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (result.success) {
                if (_buildingTradeArray.count>0) {
                    [_buildingTradeArray removeAllObjects];
                }
                [_buildingTradeArray addObjectsFromArray:array];
            }else
            {
                [self showTips:result.message];
            }
        });
    }];
    [self layoutUI];
}

- (void)layoutUI
{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, kMainScreenHeight-viewTopY)];
    scrollView.backgroundColor = VIEWBGCOLOR;
    [self.view addSubview:scrollView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];
    
    CGSize labelSize = [@"楼盘名称" sizeWithAttributes:@{NSFontAttributeName:FONT(12)}];
    CGSize labelSize2 = [@"楼盘名称" sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, labelSize.width, labelSize2.height)];
    nameL.textColor = [UIColor colorWithHexString:@"888888"];
    nameL.text = @"楼盘名称";
    nameL.font = FONT(12);
    [bgView addSubview:nameL];
    
    _grayBgView = [[UIView alloc] initWithFrame:CGRectMake(nameL.right+15, 15, kMainScreenWidth-15-10-nameL.right, 20+labelSize2.height)];
    _grayBgView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    [_grayBgView.layer setMasksToBounds:YES];
    [_grayBgView.layer setCornerRadius:3];
    [bgView addSubview:_grayBgView];
//    9:6
    _buildNameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, _grayBgView.width-15-9-10-10, labelSize2.height)];
    _buildNameL.textColor = NAVIGATIONTITLE;
    _buildNameL.font = [UIFont boldSystemFontOfSize:13];
    _buildNameL.text = @"请选择";
    [_grayBgView addSubview:_buildNameL];
    
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_buildNameL.right+10, _grayBgView.height/2-3, 9, 6)];
    [_iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
    [_grayBgView addSubview:_iconImgView];
    
    UIButton *_buildBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _grayBgView.width, _grayBgView.height)];
    [_buildBtn setBackgroundColor:[UIColor clearColor]];
    _buildBtn.tag = 1000;
    [_buildBtn addTarget:self action:@selector(toggleAddFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [_grayBgView addSubview:_buildBtn];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, _grayBgView.bottom+15, kMainScreenWidth, 0.5)];
    lineV.backgroundColor = VIEWBGCOLOR;
    [bgView addSubview:lineV];
    
    UILabel *followL = [[UILabel alloc] initWithFrame:CGRectMake(10, lineV.bottom+15, labelSize2.width, labelSize.height)];
    followL.textColor = [UIColor colorWithHexString:@"888888"];
    followL.text = @"跟进信息";
    followL.font = FONT(12);
    [bgView addSubview:followL];
    
    _followTV = [[CustomerTextView alloc]initWithFrame:CGRectMake(10, followL.bottom+10, kMainScreenWidth-20, 90)];
    _followTV.font = FONT(13);
    _followTV.textColor = NAVIGATIONTITLE;
    _followTV.placeHolder = @"请输入内容(200字以内)";
    _followTV.placeHolderTextColor = [UIColor colorWithHexString:@"888888"];
    _followTV.delegate = self;
//    followTV.showsVerticalScrollIndicator = NO;
    _followTV.showsHorizontalScrollIndicator = NO;
    [_followTV.layer setMasksToBounds:YES];
    [_followTV.layer setCornerRadius:4];
    [_followTV.layer setBorderColor:[UIColor colorWithHexString:@"d6d6d6"].CGColor];
    [_followTV.layer setBorderWidth:0.5];
    [bgView addSubview:_followTV];
    
    bgView.height = _followTV.bottom + 15;
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, bgView.bottom+15, 30, 30)];
    _confirmBtn.tag = 1001;
    [_confirmBtn setBackgroundColor:[UIColor clearColor]];
    [_confirmBtn setImage:[UIImage imageNamed:@"button_confirm_no"] forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"button_confirm_yes"] forState:UIControlStateSelected];
    _confirmBtn.selected = YES;
    [_confirmBtn addTarget:self action:@selector(toggleAddFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_confirmBtn];
    
    UILabel *confirmL = [[UILabel alloc] initWithFrame:CGRectMake(_confirmBtn.right+5, _confirmBtn.top, 150, 30)];
    confirmL.text = @"确客专员可见";
    confirmL.textColor = NAVIGATIONTITLE;
    confirmL.font = FONT(13);
    [scrollView addSubview:confirmL];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, _confirmBtn.bottom+15, kMainScreenWidth-20, 45)];
    saveBtn.tag = 1002;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BLUEBTBCOLOR];
    [saveBtn.layer setMasksToBounds:YES];
    [saveBtn.layer setCornerRadius:4];
    [saveBtn addTarget:self action:@selector(toggleAddFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:saveBtn];
}

- (void)toggleAddFollowButton:(UIButton*)sender
{
    switch (sender.tag-1000) {
        case 0://是否展示楼盘列表
        {
            if (_tableView == nil) {
                [_iconImgView setImage:[UIImage imageNamed:@"icon_blackArrowUp"]];
                CGFloat height = viewTopY+15+_grayBgView.height;
                _followBgView = [[UIView alloc] initWithFrame:CGRectMake(0, height, kMainScreenWidth, kMainScreenHeight - height)];
                [_followBgView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.3]];
                [self.view addSubview:_followBgView];
                _tableBgView = [[UIView alloc] initWithFrame:CGRectMake(_grayBgView.left, height, _grayBgView.width, MIN(33*_buildingTradeArray.count+11, 200))];
                _tableBgView.backgroundColor = [UIColor clearColor];
                [self.view addSubview:_tableBgView];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 11, 7)];
                [imgView setImage:[UIImage imageNamed:@"icon_alertrect"]];
                [_tableBgView addSubview:imgView];
                
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imgView.bottom, _tableBgView.width, _tableBgView.height-11) style:UITableViewStylePlain];
                _tableView.delegate = self;
                _tableView.dataSource = self;
                [_tableView.layer setMasksToBounds:YES];
                [_tableView.layer setCornerRadius:3];
                _tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
                _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                [_tableBgView addSubview:_tableView];
            }else
            {
                [self dismissTableView];
            }
        }
            break;
        case 1://确客是否可见
        {
            if (sender.selected) {
                sender.selected = NO;
            }else
            {
                sender.selected = YES;
            }
            NSLog(@"确客专员是否可见：%d",sender.selected);
        }
            break;
        case 2://点击保存按钮
        {
            if ([self isBlankString:_buildId]) {
                [self showTips:@"请选择楼盘"];
                return;
            }
            if ([self isBlankString:_followTV.text]) {
                [self showTips:@"请填写跟进信息"];
                return;
            }
//            _confirmBtn.selected
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            if (![self isBlankString:_customerId]) {
                [dic setValue:_customerId forKey:@"custProfileId"];
            }
            if (![self isBlankString:_buildId]) {
                [dic setValue:_buildId forKey:@"estateId"];
            }
            if (![self isBlankString:_followTV.text]) {
                [dic setValue:_followTV.text forKey:@"content"];
            }
            int visible = _confirmBtn.selected;
            if (visible == 0) {
                visible = 2;
            }
            [dic setValue:[NSString stringWithFormat:@"%d",visible] forKey:@"confirmIsVisible"];
            if (!_bIsTouched) {
                _bIsTouched = YES;
                UIImageView* loadingView = [self setRotationAnimationWithView];
                [[DataFactory sharedDataFactory] addTrackMessageWithDict:dic withCallBack:^(ActionResult *result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self removeRotationAnimationView:loadingView];
                        [self showTips:result.message];
                        if (result.success) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCustomerFollowList" object:nil];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                //防止多次pop发生崩溃闪退
                                if ([self.view superview]) {
                                    _bIsTouched = NO;
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            });
                        }else
                        {
                            _bIsTouched = NO;
                        }
                    });
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)toggleNewFollowView:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    if (_tableView != nil) {
        [self dismissTableView];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)dismissTableView
{
    [_iconImgView setImage:[UIImage imageNamed:@"blackArrowDown"]];
    [_followBgView removeFromSuperview];
    [_tableView removeAllSubviews];
    [_tableView removeFromSuperview];
    _tableView = nil;
    [_tableBgView removeAllSubviews];
    [_tableBgView removeFromSuperview];
    _tableBgView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buildingTradeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *line = nil;
    UILabel *nameLabel = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 32.5, _tableView.width, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"d6d6d6"];
        [cell.contentView addSubview:line];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _tableBgView.width-30, 32.5)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = NAVIGATIONTITLE;
        nameLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:nameLabel];
        
        cell.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == _selectedIndex) {
        nameLabel.textColor = BLUEBTBCOLOR;
    }
    if (indexPath.row == _buildingTradeArray.count-1) {
        line.hidden = YES;
    }
    
    CustomerFollowData *data = (CustomerFollowData*)[_buildingTradeArray objectForIndex:indexPath.row];
    nameLabel.text = data.estateName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerFollowData *tradeRecord = (CustomerFollowData*)[_buildingTradeArray objectForIndex:indexPath.row];
    _buildNameL.text = tradeRecord.estateName;
    _buildId = tradeRecord.estateId;
    _selectedIndex = indexPath.row;
    [self dismissTableView];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length >= 200)
    {
        textView.text = [textView.text substringToIndex:200];
        [textView resignFirstResponder];
    }
//    _displayLb.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textview.text.length];
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

//
//  ChangeAddressViewController.m
//  MoShou2
//
//  Created by wangzz on 2017/2/20.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "ChangeAddressViewController.h"
#import "NewAddressViewController.h"
#import "DataFactory+Customer.h"

@interface ChangeAddressViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIView         *addView;
@property (nonatomic, strong) UIView         *modifyView;
@property (nonatomic, assign) BOOL           bHasAddress;
@property (nonatomic, strong) AddressData    *data;
//@property (nonatomic, strong) NSMutableArray *addressArr;

@end

@implementation ChangeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"我的地址";
    self.view.backgroundColor = VIEWBGCOLOR;
//    _addressArr = [[NSMutableArray alloc] init];
    _data = [[AddressData alloc] init];
//    _bHasAddress = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressNotification:) name:@"RefreshAddressList" object:nil];
    [self creatNewAddressView];
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

- (void)refreshAddressNotification:(NSNotification*)notification
{
    [self reloadView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshAddressList" object:nil];
}

- (void)hasNetwork
{
    __weak ChangeAddressViewController *weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getAddressWithDict:nil withCallBack:^(ActionResult *result, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (result.success) {
//                [_addressArr addObjectsFromArray:array];
                if (_modifyView != nil) {
                    [_modifyView removeAllSubviews];
                    [_modifyView removeFromSuperview];
                    _modifyView = nil;
                }
                if (array.count>0) {
                    _data = (AddressData*)[array objectForIndex:0];
                    _bHasAddress = YES;
                }else
                {
                    _bHasAddress = NO;
                }
                
                [self layoutUI];
            }else
            {
                [self showTips:result.message];
            }
        });
    }];
}

- (void)creatNewAddressView
{
    //没有地址时展示addView
    _addView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY+10, kMainScreenWidth, 45)];
    _addView.backgroundColor = [UIColor whiteColor];
    _addView.hidden = YES;
    [self.view addSubview:_addView];
    
    UIImageView *addImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    [addImgView setImage:[UIImage imageNamed:@"icon_addAddress"]];
    [_addView addSubview:addImgView];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(addImgView.right+10, addImgView.top, kMainScreenWidth-addImgView.right-10, addImgView.height)];
    addLabel.textColor = NAVIGATIONTITLE;
    addLabel.font = FONT(15);
    addLabel.textAlignment = NSTextAlignmentLeft;
    addLabel.text = @"添加地址";
    [_addView addSubview:addLabel];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, _addView.height)];
    [addBtn setBackgroundColor:[UIColor clearColor]];
    [addBtn setTag:1000];
    [addBtn addTarget:self action:@selector(toggleAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addView addSubview:addBtn];
}

- (void)layoutUI
{
    //有地址时展示modifyView
    _modifyView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY+10, kMainScreenWidth, 0)];
    _modifyView.backgroundColor = [UIColor whiteColor];
    _modifyView.hidden = YES;
    [self.view addSubview:_modifyView];
    
    CGSize nameSize = [_data.receiverUser sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    CGSize phoneSize = [_data.receiverMobile sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
    CGSize addressSize = [self textSize:_data.receiverAddress withConstraintWidth:kMainScreenWidth-20];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, (nameSize.width+phoneSize.width)>kMainScreenWidth-30?kMainScreenWidth-30-phoneSize.width:nameSize.width, nameSize.height)];
    nameLabel.text = _data.receiverUser;
    nameLabel.textColor = NAVIGATIONTITLE;
    nameLabel.font =FONT(15);
    [_modifyView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-phoneSize.width, 15, phoneSize.width, nameSize.height)];
    phoneLabel.text = _data.receiverMobile;
    phoneLabel.textColor = NAVIGATIONTITLE;
    phoneLabel.font =FONT(15);
    [_modifyView addSubview:phoneLabel];
    
    UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.bottom+15, kMainScreenWidth-20, addressSize.height)];
    addressL.text = _data.receiverAddress;
    addressL.textColor = NAVIGATIONTITLE;
    addressL.font =FONT(15);
    addressL.numberOfLines = 0;
    addressL.lineBreakMode = NSLineBreakByWordWrapping;
    [_modifyView addSubview:addressL];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addressL.bottom+15, kMainScreenWidth, 0.5)];
    lineView.backgroundColor = VIEWBGCOLOR;
    [_modifyView addSubview:lineView];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-55, lineView.bottom+15, 55, 25)];
    deleteBtn.tag = 1002;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = FONT(13);
    [deleteBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [deleteBtn.layer setMasksToBounds:YES];
    [deleteBtn.layer setCornerRadius:4];
    [deleteBtn.layer setBorderWidth:0.5];
    [deleteBtn.layer setBorderColor:BLUEBTBCOLOR.CGColor];
    [deleteBtn addTarget:self action:@selector(toggleAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [_modifyView addSubview:deleteBtn];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(deleteBtn.left-55-15, lineView.bottom+15, 55, 25)];
    editBtn.tag = 1001;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.titleLabel.font = FONT(13);
    [editBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [editBtn.layer setMasksToBounds:YES];
    [editBtn.layer setCornerRadius:4];
    [editBtn.layer setBorderWidth:0.5];
    [editBtn.layer setBorderColor:BLUEBTBCOLOR.CGColor];
    [editBtn addTarget:self action:@selector(toggleAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [_modifyView addSubview:editBtn];
    
    _modifyView.height = editBtn.bottom+15;
    
    if (_bHasAddress) {
        _modifyView.hidden = NO;
    }else
    {
        _addView.hidden = NO;
    }
}

- (void)toggleAddressAction:(UIButton*)sender
{
    switch (sender.tag-1000) {
        case 0://添加新地址
        {
            NewAddressViewController *newAddVC = [[NewAddressViewController alloc] init];
            newAddVC.addressType = kNewAddress;
            __weak typeof(self) weakSelf = self;
            [newAddVC saveModifyAddressBlock:^{
                [weakSelf reloadView];
            }];
            [self.navigationController pushViewController:newAddVC animated:YES];
        }
            break;
        case 1://编辑地址
        {
            NewAddressViewController *newAddVC = [[NewAddressViewController alloc] init];
            newAddVC.addressType = kEditAddress;
            newAddVC.addressData = _data;
            __weak typeof(self) weakSelf = self;
            [newAddVC saveModifyAddressBlock:^{
                [weakSelf reloadView];
            }];
            [self.navigationController pushViewController:newAddVC animated:YES];
        }
            break;
        case 2://删除地址
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认删除该地址吗 ?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (![self isBlankString:_data.addressId]) {
            [dic setValue:_data.addressId forKey:@"id"];
        }
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory] deleteAddressWithDict:dic withCallBack:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeRotationAnimationView:loadingView];
                [self showTips:result.message];
                if (result.success) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                    [_modifyView removeAllSubviews];
                    [_modifyView removeFromSuperview];
                    _modifyView = nil;
                    _bHasAddress = NO;
                    _addView.hidden = NO;
                }
            });
        }];
    }
}

//通过字符串、字体大小和指定宽度计算所需高度
- (CGSize)textSize:(NSString *)text withConstraintWidth:(int)contraintWidth{
    CGSize constraint = CGSizeMake(contraintWidth, 20000.0f);
    UIFont *font = [UIFont systemFontOfSize:15];
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

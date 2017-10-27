//
//  PersonalInfoViewController.m
//  MoShouBroker
//
//  Created by Aminly on 15/6/17.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UserData.h"
#import "DataFactory+User.h"
//#import "LoginViewController.h"
#import "TipsView.h"
#import "NetworkSingleton.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AutoLabel.h"
#import "HMTool.h"
#import "ChangeNameViewController.h"
#import "ChangeSexViewController.h"
#import "ChangeShopViewController.h"
#import "ChangeMobileViewController.h"
#import "UILabel+StringFrame.h"
#import "UIImageView+AFNetworking.h"
#import "BaseNavigationController.h"
#import "ChangeEmplyeeNoViewController.h"
#import "ChangeAddressViewController.h"
@interface PersonalInfoViewController (){
    
    //    UITableViewCell *headcell;
    UIImageView *bigHeadImage;
    
}

@property (nonatomic, strong) UITableView  *tableView;

@end

@implementation PersonalInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEWBGCOLOR;
    self.navigationBar.titleLabel.text = @"个人资料";
    [self initLayout];
    
}

-(void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initLayout{
    //    [UserData sharedUserData].isExchangeShop = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, kMainScreenHeight-viewTopY) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _textArr = @[@"姓名",@"性别",@"手机号",@"地区",@"所属门店",@"员工编号",@"我的地址"];
    [self initTableViewHeaderView];
    
    //    _infoTable = [[UITableView alloc]init];
    //    [_infoTable setFrame:CGRectMake(0, headcell.frame.origin.y+headcell.frame.size.height+10, kMainScreenWidth, 135)];
    //     _infoTable.delegate = self;
    //     _infoTable.dataSource = self;
    //     _infoTable.scrollEnabled = NO;
    //    _infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_infoTable setTag:2000];
    //     [self.view addSubview:_infoTable];
    //
    //
    //    _cityTable = [[UITableView alloc]init];
    //    if (![self isBlankString:[UserData sharedUserData].storeNum]) {
    //        [_cityTable setFrame:CGRectMake(0, kFrame_YHeight(_infoTable)+10, kMainScreenWidth, 135)];
    //
    //    }else if([self isBlankString:[UserData sharedUserData].storeNum]){
    //        [_cityTable setFrame:CGRectMake(0, kFrame_YHeight(_infoTable)+10, kMainScreenWidth, 45)];
    //    }
    //    _cityTable.delegate = self;
    //    _cityTable.dataSource = self;
    //    _cityTable.scrollEnabled = NO;
    //    _cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_cityTable setTag:2001];
    //    [self.view addSubview:_cityTable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableView) name:@"REFRESHPERSONINFO" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShop) name:@"REFRESHPERSONSHOP" object:nil];
    
    
}

- (void)initTableViewHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 85)];
    headerView.backgroundColor = VIEWBGCOLOR;
    
    UITableViewCell *headcell =[self getArrowCellWithFrame:CGRectMake(0,10,kMainScreenWidth, 75)];
    [headerView addSubview:headcell];
    
    _chengeBtn =[[UIButton alloc]initWithFrame:CGRectMake(0,0,kFrame_Width(headcell),kFrame_Height(headcell))];
    [_chengeBtn setTag:HEAD_BUTTON_TAG];
    [headcell addSubview:_chengeBtn];
    [_chengeBtn addTarget: self action:@selector(BtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _headImage = [[MyImageView alloc]initWithFrame:CGRectMake(headcell.frame.size.width-25-8-10-55,10, 55, 55)];
    if ([UserData sharedUserData].userInfo.avatar.length>0) {
        [_headImage setImageWithUrlString:[UserData sharedUserData].userInfo.avatar placeholderImage:[UIImage imageNamed:@"icon_header"]];//默认图片75
        //        [_headImage setImageWithURL:[NSURL URLWithString:[UserData sharedUserData].avatar] placeholderImage:[UIImage imageNamed:@"默认图片75"]];
    }else{
        [_headImage setImage:[UIImage imageNamed:@"icon_header"]];//我线-拷贝
    }
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 27.5;
    [_headImage setTag:1003];
    _headImage.centerY = 37.5;
    _headImage.userInteractionEnabled = YES;
    UIImageView *arrow = [[UIImageView alloc]init];
    [arrow setImage:[UIImage imageNamed:@"arrow-right"]];
    [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 37.5-13/2, 8, 13)];
    [headcell addSubview:arrow];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadPicAction)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [_headImage addGestureRecognizer:singleTap];
    [headcell addSubview:_headImage];
    UILabel *text =[[UILabel alloc]initWithPoint:CGPointMake(25, 37.5-8) andText:@"头像" andFontSize:16];
    [text setTextColor:LABELCOLOR];
    text.centerY = 37.5;
    [headcell addSubview:text];
    
    
    //    UIView *line2 = [HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(_chengeBtn), kMainScreenWidth, 0.5) andColor:LINECOLOR];
    //    [headcell addSubview:line2];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)updateTableView{
    
    //    if (_infoTable) {
    //        [_infoTable removeFromSuperview];
    //    }
    //    _infoTable = [[UITableView alloc]init];
    //    [_infoTable setFrame:CGRectMake(0, headcell.frame.origin.y+headcell.frame.size.height+10, kMainScreenWidth, 135)];
    //    _infoTable.delegate = self;
    //    _infoTable.dataSource = self;
    //    _infoTable.scrollEnabled = NO;
    //    _infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_infoTable setTag:2000];
    //    [self.view addSubview:_infoTable];
    //    if (![self isBlankString:[UserData sharedUserData].storeNum]) {
    //        [_cityTable setFrame:CGRectMake(0, kFrame_YHeight(_infoTable)+10, kMainScreenWidth, 135)];
    //
    //    }else if([self isBlankString:[UserData sharedUserData].storeNum]){
    //        [_cityTable setFrame:CGRectMake(0, kFrame_YHeight(_infoTable)+10, kMainScreenWidth, 45)];
    //    }
    //    [_cityTable reloadData];
    [self.tableView reloadData];
    
}
//绑定门店后刷新本页面的tableview
-(void)refreshShop{
    
    //    if (_cityTable ) {
    //        [_cityTable removeFromSuperview];
    //    }
    //    _cityTable = [[UITableView alloc]init];
    //    if (![self isBlankString:[UserData sharedUserData].storeNum]) {
    //
    //        [_cityTable setFrame:CGRectMake(0, kFrame_YHeight(_infoTable)+10, kMainScreenWidth, 135)];
    //
    //    }else if([self isBlankString:[UserData sharedUserData].storeNum]){
    //        [_cityTable setFrame:CGRectMake(0, kFrame_YHeight(_infoTable)+10, kMainScreenWidth, 45)];
    //    }
    //    _cityTable.delegate = self;
    //    _cityTable.dataSource = self;
    //    _cityTable.scrollEnabled = NO;
    //    _cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [_cityTable setTag:2001];
    //    [self.view addSubview:_cityTable];
    //    [_cityTable reloadData];
    [self.tableView reloadData];
}

-(void)BtnClickedAction:(UIButton *)btn{
    
    if (btn.tag == 1000) {//更换头像按钮
        
        if (_hmSheet) {
            [_hmSheet removeFromSuperview];
        }
        _hmSheet = [[HMActionSheet alloc]initWithDelegate:self];
        [self.view addSubview:_hmSheet];
        
    }else if (btn.tag == 1001){//修改密码按钮
        
        
    }else if (btn.tag == 1002){//头像放大后点击小时按钮
        
        [bigHeadImage removeFromSuperview];
        [_review removeFromSuperview];
        [_closeBtn removeFromSuperview];
    }
    
    
}
-(void)tapHeadPicAction{
    
    _review =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.view.bounds.size.height)];
    [_review setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_review];
    bigHeadImage = [[UIImageView alloc]initWithImage:_headImage.image];
    
    bigHeadImage.frame = CGRectMake(0, (self.view.bounds.size.height/2)-(kMainScreenWidth/2), kMainScreenWidth, kMainScreenWidth);
    [_review addSubview:bigHeadImage];
    
    _closeBtn = [[UIButton alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_closeBtn];
    [_closeBtn setTag:1002];
    [_closeBtn addTarget:self action:@selector(BtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (tableView.tag == 2001){
    //        if ([self isBlankString:[UserData sharedUserData].storeNum])
    //        {
    //            return 1;
    //        }
    //    }
    if (section == 1){
        if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum])
        {
            return 1;
        }
    }else if (section == 2)
    {
        return 1;
    }
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    header.backgroundColor = VIEWBGCOLOR;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //static NSString *identifier  = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];//[tableView dequeueReusableCellWithIdentifier:identifier];
    //    if ( cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //        if (tableView.tag == 2000) {
    if (indexPath.section == 0) {
        UILabel *title = [[UILabel alloc]initWithPoint:CGPointMake(25, 16) andText:[_textArr objectForIndex:indexPath.row] andFontSize:16];
        title.centerY = 25;
        [title setTextColor:LABELCOLOR];
        [cell addSubview:title];
        UILabel *detail =[[UILabel alloc]init];
        detail.textAlignment = NSTextAlignmentRight;
        [cell addSubview:detail];
        UIImageView *arrow = [[UIImageView alloc]init];
        [arrow setImage:[UIImage imageNamed:@"arrow-right"]];
        [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 25-13/2, 8, 13)];
        [cell addSubview:arrow];
        
        if (indexPath.row == 0) {
            //                UIView *line1=[HMTool getLineWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5) andColor:LINECOLOR];
            //                [cell addSubview:line1];
            
            UIView *line2=[HMTool getLineWithFrame:CGRectMake(10, 44.5, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
            [cell addSubview:line2];
            if([self isBlankString:[UserData sharedUserData].userInfo.userName]){
                [detail setText:@"未填写"];
                
            }else{
                [detail setText:[UserData sharedUserData].userInfo.userName];
                
            }
            [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
            [detail setFont:[UIFont systemFontOfSize:16]];
            [detail setTextColor:TFPLEASEHOLDERCOLOR];
        }else if (indexPath.row == 1){
            [detail setFont:[UIFont systemFontOfSize:16]];
            [detail setTextColor:TFPLEASEHOLDERCOLOR];
            [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
            if ([UserData sharedUserData].userInfo.gender.intValue == -1) {
                [detail setText:@"未选择"];
            }else{
                [detail setText:[UserData sharedUserData].userInfo.gender.intValue == 1 ?@"男":@"女"];
            }
        }else if (indexPath.row == 2){
            UIView *line1=[HMTool getLineWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
            [cell addSubview:line1];
            
            //                UIView *line2=[HMTool getLineWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
            //                [cell addSubview:line2];
            //                CGSize detailsize = [HMTool getTextSizeWithText:[UserData sharedUserData].mobile andFontSize:16];
            //                [detail setFrame:CGRectMake(kFrame_X(arrow)-16-detailsize.width, 25-detailsize.height/2, detailsize.width, detailsize.height)];
            [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
            [detail setFont:[UIFont systemFontOfSize:16]];
            [detail setTextColor:TFPLEASEHOLDERCOLOR];
            [detail setText:[UserData sharedUserData].userInfo.mobile];
        }
    }else if (indexPath.section == 1){
        //        }else if (tableView.tag == 2001){
        if (![self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
            UILabel *title = [[UILabel alloc]initWithPoint:CGPointMake(25, 16) andText:[_textArr objectForIndex:indexPath.row+3] andFontSize:16];
            [title setTextColor:LABELCOLOR];
            [cell addSubview:title];
            UILabel *detail =[[UILabel alloc]init];
            detail.textAlignment = NSTextAlignmentRight;
            [cell addSubview:detail];
            if (indexPath.row == 0) {
                UIImageView *arrow = [[UIImageView alloc]init];
                [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 25-13/2, 8, 13)];
                [cell addSubview:arrow];
                //                    UIView *line1=[HMTool getLineWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5) andColor:LINECOLOR];
                //                    [cell addSubview:line1];
                UIView *line2=[HMTool getLineWithFrame:CGRectMake(10, 44.5, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
                [cell addSubview:line2];
                
                [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
                
                [detail setFont:[UIFont systemFontOfSize:16]];
                [detail setTextColor:TFPLEASEHOLDERCOLOR];
                [detail setText:[UserData sharedUserData].cityName];
            }else if(indexPath.row == 1){
                UIImageView *arrow = [[UIImageView alloc]init];
                [arrow setImage:[UIImage imageNamed:@"arrow-right"]];
                [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 25-13/2, 8, 13)];
                [cell addSubview:arrow];
                if ([UserData sharedUserData].userInfo.isExchangeShop == 1) {
                    arrow.hidden = YES;
                }
                
                [detail setText:[UserData sharedUserData].userInfo.storeName];
                [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
                [detail setFont:[UIFont systemFontOfSize:16]];
                [detail setTextColor:TFPLEASEHOLDERCOLOR];
                UIView *line2=[HMTool getLineWithFrame:CGRectMake(10, 44.5, kMainScreenWidth-20, 0.5) andColor:LINECOLOR];
                [cell addSubview:line2];
                //                    if (kFrame_XWidth(title)>=kFrame_X(arrow)-16-detailsize.width) {
                //                        [detail setFrame:CGRectMake(kFrame_XWidth(title)+5, 25-detailsize.height/2, detailsize.width-10, detailsize.height)];
                //                    }
                
            }else if (indexPath.row == 2)
            {
                UIImageView *arrow = [[UIImageView alloc]init];
                [arrow setImage:[UIImage imageNamed:@"arrow-right"]];
                [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 25-13/2, 8, 13)];
                [cell addSubview:arrow];
                if ([UserData sharedUserData].userInfo.isExchangeShop == 1) {
                    arrow.hidden = YES;
                }
                
                [detail setText:[UserData sharedUserData].userInfo.employeeNo];
                //                    CGSize detailsize = [HMTool getTextSizeWithText:detail.text andFontSize:16];
                [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
                [detail setFont:[UIFont systemFontOfSize:16]];
                [detail setTextColor:TFPLEASEHOLDERCOLOR];
                //                    UIView *line2=[HMTool getLineWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
                //                    [cell addSubview:line2];
                //                    if (kFrame_XWidth(title)>=kFrame_X(arrow)-16-detailsize.width) {
                //                        [detail setFrame:CGRectMake(kFrame_XWidth(title)+5, 25-detailsize.height/2, detailsize.width-10, detailsize.height)];
                //                    }
            }
            
        }
        else if([self isBlankString:[UserData sharedUserData].userInfo.storeNum]){
            UILabel *title = [[UILabel alloc]initWithPoint:CGPointMake(25, 16) andText:[_textArr objectForIndex:indexPath.row+4] andFontSize:16];
            [title setTextColor:LABELCOLOR];
            [cell addSubview:title];
            UILabel *detail =[[UILabel alloc]init];
            detail.textAlignment = NSTextAlignmentRight;
            [cell addSubview:detail];
            
            //                UIView *line1=[HMTool getLineWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5) andColor:LINECOLOR];
            //                [cell addSubview:line1];
            //                UIView *line2=[HMTool getLineWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
            //                [cell addSubview:line2];
            UIImageView *arrow = [[UIImageView alloc]init];
            [arrow setImage:[UIImage imageNamed:@"arrow-right"]];
            [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 25-13/2, 8, 13)];
            [cell addSubview:arrow];
            if([self isBlankString:[UserData sharedUserData].userInfo.storeNum]){
                [detail setText:@"请先绑定门店"];
            }else{
                [detail setText:[UserData sharedUserData].userInfo.storeName];
            }
            [detail setFrame:CGRectMake(title.right + 10, title.top, arrow.left - title.right - 10 - 10, title.height)];
            [detail setFont:[UIFont systemFontOfSize:16]];
            [detail setTextColor:TFPLEASEHOLDERCOLOR];
            
        }
        
    }else if (indexPath.section == 2)
    {
        UILabel *title = [[UILabel alloc]initWithPoint:CGPointMake(25, 16) andText:[_textArr objectForIndex:6] andFontSize:16];
        [title setTextColor:LABELCOLOR];
        [cell addSubview:title];
        UIImageView *arrow = [[UIImageView alloc]init];
        [arrow setImage:[UIImage imageNamed:@"arrow-right"]];
        [arrow setFrame:CGRectMake(kMainScreenWidth-16-8, 25-13/2, 8, 13)];
        [cell addSubview:arrow];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    //    }
    
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (tableView.tag == 2000) {
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            ChangeNameViewController *name =[[ChangeNameViewController alloc]init];
            [self.navigationController pushViewController:name animated:YES];
        }else if (indexPath.row == 1){
            ChangeSexViewController *name =[[ChangeSexViewController alloc]init];
            [self.navigationController pushViewController:name animated:YES];
            
        }else if (indexPath.row == 2){
            ChangeMobileViewController *name =[[ChangeMobileViewController alloc]init];
            [self.navigationController pushViewController:name animated:YES];
            
        }
    }else if (indexPath.section == 1) {
        //    }else if (tableView.tag == 2001){
        if ([self isBlankString:[UserData sharedUserData].userInfo.storeNum]) {
            if(indexPath.row == 0){
                if(![self isBlankString:[UserData sharedUserData].userInfo.userName]){
                    if([UserData sharedUserData].userInfo.changeShopVerifyStatus == 1){
                        //&&[self isChinese:[UserData sharedUserData].userName]&&![self adjusStrHasNumber:[UserData sharedUserData].userName]
                        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"审核中，请耐心等待。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [av show];
                        
                    }else{
                        ChangeShopViewController *shp=[[ChangeShopViewController alloc]init];
                        [self.navigationController pushViewController:shp animated:YES];
                    }
                    
                    
                }else{
                    UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先填写真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去填写", nil];
                    [av show];
                }
                
            }
            
        }else{
            if ([UserData sharedUserData].userInfo.isExchangeShop == 0) {
                if(indexPath.row == 0){
                    
                }else if (indexPath.row == 1){
                    //                [UserData sharedUserData].changeShopVerifyStatus = 1;
                    if([UserData sharedUserData].userInfo.changeShopVerifyStatus == 1){
                        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"审核中，请耐心等待。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [av show];
                        
                    }else{
                        ChangeShopViewController *shp=[[ChangeShopViewController alloc]init];
                        [self.navigationController pushViewController:shp animated:YES];
                    }
                    
                    //                ChangeShopViewController *shp=[[ChangeShopViewController alloc]init];
                    //                [self.navigationController pushViewController:shp animated:YES];
                }else if (indexPath.row == 2)
                {
                    [MobClick event:@"wdzl_ygbh"];
                    ChangeEmplyeeNoViewController *employee = [[ChangeEmplyeeNoViewController alloc] init];
                    [self.navigationController pushViewController:employee animated:YES];
                }
            }
        }
    }else if (indexPath.section == 2)
    {
        ChangeAddressViewController *addressVC = [[ChangeAddressViewController alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
 }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        ChangeNameViewController *changname =[[ChangeNameViewController alloc]init];
        [self.navigationController pushViewController:changname animated:YES];
    }
}

-(BOOL)isChinese:(NSString*)str{
    
    
    for (int i=0; i<str.length;i++){
        
        NSRange range=NSMakeRange(i,1);
        
        NSString *subString=[str substringWithRange:range];
        
        const char *cString=[subString UTF8String];
        
        if (strlen(cString)==3){
            
            
            if(str.length<2||str.length>15){
                
                
                return NO;
                
            }
            return YES;
            
            
        }
        
    }
    
    return NO;
    
    
    
}

-(BOOL)adjusStrHasNumber:(NSString *)str{
    
    if(([str rangeOfString:@"0"].location !=NSNotFound)||([str rangeOfString:@"1"].location !=NSNotFound)||([str rangeOfString:@"2"].location !=NSNotFound)||([str rangeOfString:@"3"].location !=NSNotFound)||([str rangeOfString:@"4"].location !=NSNotFound)||([str rangeOfString:@"5"].location !=NSNotFound)||([str rangeOfString:@"6"].location !=NSNotFound)||([str rangeOfString:@"7"].location !=NSNotFound)||([str rangeOfString:@"8"].location !=NSNotFound)||([str rangeOfString:@"9"].location !=NSNotFound)){
        return true;
        
    }
    return false;
}

-(void)openCamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    _pickerImage = [[UIImagePickerController alloc] init];//初始化
    [_pickerImage.navigationBar setBarTintColor:BACKGROUNDCOLOR];
    _pickerImage.navigationBar.alpha = 1;
    [_pickerImage.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONTITLE,UITextAttributeTextColor,nil]];//title设置白色
    _pickerImage.delegate = self;
    _pickerImage.allowsEditing = YES;//设置可编辑
    _pickerImage.sourceType = sourceType;
    [self presentViewController:_pickerImage animated:YES completion:nil];
    
}
-(void)openPicture{
    
    _pickerImage = [[UIImagePickerController alloc] init];
    [_pickerImage.navigationBar setBarTintColor:BACKGROUNDCOLOR];
    _pickerImage.navigationBar.alpha = 1;
    [_pickerImage.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATIONTITLE,UITextAttributeTextColor,nil]];//title设置白色
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_pickerImage.sourceType];
        
    }
    _pickerImage.delegate = self;
    _pickerImage.allowsEditing = NO;
    [self presentViewController:_pickerImage animated:YES completion:nil];
}
//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString* mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImage *image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
            
            UIImage *photo =  image;
            
            RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
            imageCropVC.isCamera = YES;
            imageCropVC.delegate = self;
            self.myNave.navigationBarHidden = NO;
            [self.myNave pushViewController:imageCropVC animated:YES];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
        }else{
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            
            RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
            imageCropVC.isCamera = NO;
            imageCropVC.delegate = self;
            self.myNave.navigationBarHidden = NO;
            [self.myNave pushViewController:imageCropVC animated:YES];
        }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        [TipsView showTips: @"请选择图片文件" inView:self.view];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    if (controller.isCamera) {
        
        [_pickerImage dismissViewControllerAnimated:YES completion:nil];
        [_hmSheet disappear];
        
    }else{
        [_pickerImage popToRootViewControllerAnimated:YES];
        
    }
    
}
//获取头像切割后的图片
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView *loading =[self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]uploadAvatarWith:croppedImage userId:[UserData sharedUserData].userInfo.userId  andCallback:^(ActionResult *result) {
            if (result.success) {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    
                    //                    [_headImage setFrame:CGRectMake(headcell.frame.size.width-25-8-10-30,0, 30, 30)];
                    
                    [_headImage setImageWithUrlString:[UserData sharedUserData].userInfo.avatar placeholderImage:[UIImage imageNamed:@"icon_header"]];
                    _headImage.layer.masksToBounds = YES;
                    _headImage.layer.cornerRadius = 27.5;
                    //                    _headImage.contentMode = UIViewContentModeScaleAspectFit;
                    //                    NSLog(@"iiiiii%@", [UserData sharedUserData].avatar);
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINEINFO" object:self];
                    
                });
                [self removeRotationAnimationView:loading];
                
            }
            else{
                [TipsView showTips:@"修改失败" inView:self.view ];
                [self removeRotationAnimationView:loading];
                
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    if (_hmSheet) {
        [_hmSheet disappear];
    }
    
}
//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_hmSheet disappear];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.myNave = navigationController;
    
}
-(CGSize )getTextSizeWithText:(NSString *)text andFountSize:(float)size{
    CGSize fsize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}];
    return  fsize;
}
-(UITableViewCell *)getArrowCellWithFrame:(CGRect)fram{
    UITableViewCell *cell =[[UITableViewCell alloc]init];
    cell.frame =fram;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-20, cell.frame.size.height/2-7, 8, 14)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor= [UIColor colorWithHexString:@"#4c4b4b"];
    [arrow setImage: [UIImage imageNamed:@"arrow-gray"]];
    [cell addSubview:arrow];
    
    return cell;
}
-(UILabel *)setDetailLabelWithText:(NSString *)text andFontSize:(float)fontSize cellHeight:(float)height{
    
    UILabel  *detail =[[UILabel alloc]init];
    detail.text = text;
    detail.textAlignment = NSTextAlignmentRight;
    detail.textColor =[UIColor colorWithHexString:@"#717171"];
    CGSize fsize = [self getTextSizeWithText:detail.text andFountSize:fontSize];
    [detail setFrame:CGRectMake((kMainScreenWidth-30)-fsize.width, (height/2)-(fsize.height/2), fsize.width, fsize.height)];
    detail.adjustsFontSizeToFitWidth  = YES;
    return detail;
}
-(void)firstBtnClickAction{
    [self openCamera];
}
-(void)seconBtnClickAction{
    [self openPicture];
    
}
#pragma mark 侧滑刷新数据
//- (void)baseNavigationController:(BaseNavigationController*)controller didReturn:(NSString*)className{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHMINETABLEVIEW" object:self];
//}
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

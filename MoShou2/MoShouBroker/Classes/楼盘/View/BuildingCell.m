//
//  BuildingCell.m
//  MoShouQueke
//
//  Created by strongcoder on 15/10/28.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//

#import "BuildingCell.h"
#import "AutoLabel.h"
#import "UIView+YR.h"
#import "UILabel+StringFrame.h"
#import "CustomerReportViewController.h"
#import "BannerInfo.h"
#import "DataFactory+Customer.h"
#import "MyCustomersViewController.h"
@implementation BuildingCell

- (instancetype)initWithStyle:(TableViewCellStyle)style andBuildListData:(BuildingListData *)buildListData;
{
    self = [super init];
    if (self) {
        self.buildingListData = buildListData;
        self.tableViewCellStyle = style;
        
        if (self.tableViewCellStyle == HomeTableViewCellStyle)
        {
            [self loadHomeTableViewCellUI];
            
        }else if (self.tableViewCellStyle == MyBuildingTableViewCellDownLoadStyle || self.tableViewCellStyle == MyBuildingTableViewCellFavoriteStyle)
        {
            [self loadHomeTableViewCellUI];
            
        }
        
    }
    return self;
}


//- (instancetype)initWithStyle:(TableViewCellStyle)style andBuildListData:(BuildingListData *)buildListData WithBannerInfosResult:(CityFirstResult *)cityFirstResult;
//{
//    self = [super init];
//    if (self) {
//        self.buildingListData = buildListData;
//        self.tableViewCellStyle = style;
//
//
//        self.cityFirstResult = cityFirstResult;
//
//        if (self.tableViewCellStyle == HomeTableViewCellStyle)
//        {
//            [self loadHomeTableViewCellUI];
//
//        }else if (self.tableViewCellStyle == MyBuildingTableViewCellDownLoadStyle || self.tableViewCellStyle == MyBuildingTableViewCellFavoriteStyle)
//        {
//
//
//        }
//
//    }
//    return self;
//
//
//
//
//}

//- (instancetype)initWithStyle:(TableViewCellStyle)style andBuilding:(BuildingListData *)buildding;
//{
//    self = [super init];
//    if (self) {
//        self.buildingListData = buildding;
//        self.tableViewCellStyle = style;
//       if (self.tableViewCellStyle == MyBuildingTableViewCellDownLoadStyle || self.tableViewCellStyle == MyBuildingTableViewCellFavoriteStyle)
//        {
//            [self loadMyBuildingTableViewCellUI];
//
//        }
//
//    }
//    return self;
//}

- (void)loadHomeTableViewCellUI {
    
    [self EditNullValue];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //楼盘图片
    self.buildImageView = [[BuildingImageView alloc]initWithFrame:CGRectMake(16, 15, 100, 75) andBuildingId:self.buildingListData.buildingId];
    self.buildImageView.backgroundColor = [UIColor grayColor];
    self.buildImageView.layer.cornerRadius = 4;
    self.buildImageView.layer.masksToBounds = YES;
    [self.buildImageView setImageWithUrlString:self.buildingListData.thmUrl placeholderImage:[UIImage imageNamed:@"列表默认图"]];
    
    DLog(@"url================%@",self.buildingListData.thmUrl);
    [self.contentView addSubview:self.buildImageView];
    
    //写一个数组  按照 特价 新上  热门  来按照 buildingListData的对应字段是否显示 需求加进去
    
    //然后 按照数组中的内容 来布局内容 以此排练 三个图片
    NSMutableArray *array = [NSMutableArray array];
#warning 测试数据
    
    //    self.buildingListData.isHot = arc4random() %(0+2);
    //    self.buildingListData.isNew = arc4random() %(0+2);
    //    self.buildingListData.isSpecialPrice = arc4random() %(0+2);
    //    self.buildingListData.bedroomSegment = @"1-5居";
    //    self.buildingListData.saleAreaSegment  = @"85-108㎡";
    //    self.buildingListData.districtName = @"昌平";
    //    self.buildingListData.plateName = @"天通苑";
    
    
    if (self.buildingListData.isHot) {
        [array addObject:@"热门"];
    }
    if(self.buildingListData.isNew){
        [array addObject:@"新上"];
    }
    if(self.buildingListData.isSpecialPrice){
        [array addObject:@"特价"];
    }
    CGFloat AllLeftWith =kMainScreenWidth-  (5+(5+22)*array.count);
    if (array.count>0) {
        
        for (NSInteger i  = 0 ; i < array.count; i ++) {
            NSString *string = array[i];
            if ([string isEqualToString:@"热门"]) {
                
                [self.contentView addSubview:[self creatImageViewWithFrameX:AllLeftWith andImageName:@"building-hot"]];
                AllLeftWith = AllLeftWith+5+22;
                
            }
            
            if ([string isEqualToString:@"新上"]) {
                [self.contentView addSubview:[self creatImageViewWithFrameX:AllLeftWith andImageName:@"building-new"]];
                AllLeftWith = AllLeftWith  +5+22;
                
            }
            
            if ([string isEqualToString:@"特价"]) {
                [self.contentView addSubview:[self creatImageViewWithFrameX:AllLeftWith andImageName:@"building-specialprice"]];
                AllLeftWith = AllLeftWith +5+22;
            }
            
            
        }
        
        
    }
    
    //楼盘全称
    self.buildNamelabel = [[UILabel alloc]init ];
    self.buildNamelabel.text = [NSString stringWithFormat:@"%@",self.buildingListData.name];
    self.buildNamelabel.textAlignment = NSTextAlignmentLeft;
    self.buildNamelabel.font =[UIFont boldSystemFontOfSize:16.f];     //FONT(16.f);
    self.buildNamelabel.textColor = UIColorFromRGB(0x333333);
    
    CGSize size = [self.buildNamelabel boundingRectWithSize:CGSizeMake(kMainScreenWidth - self.buildImageView.right-(5+(5+22)*array.count)-20, 20)];
    self.buildNamelabel.frame = CGRectMake(kFrame_XWidth(self.buildImageView)+10, 14, size.width, size.height);
    [self.contentView addSubview:self.buildNamelabel];
    UILabel *districtplateNameLabel;
    if (self.buildingListData.districtplateName.length>0) {
        districtplateNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.buildNamelabel.left, self.buildNamelabel.bottom+2, (kMainScreenWidth-self.buildImageView.width-30)/2, 13)];
        districtplateNameLabel.text = self.buildingListData.districtplateName;
        districtplateNameLabel.textColor = TFPLEASEHOLDERCOLOR;
        districtplateNameLabel.font = FONT(12.f);
        [self.contentView addSubview:districtplateNameLabel];
    }
    CGSize districtSize  = [districtplateNameLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth, 0)];
    districtplateNameLabel.width =districtSize.width;
    
    
    if (self.buildingListData.districtplateName.length>0) {
        self.buildDistance = [[UILabel alloc]initWithFrame:CGRectMake(districtplateNameLabel.right+17, kFrame_YHeight(self.buildNamelabel)+2, 150, 15)];
    }else{
        self.buildDistance = [[UILabel alloc]initWithFrame:CGRectMake(self.buildNamelabel.left, kFrame_YHeight(self.buildNamelabel)+2, 150, 15)];
        
    }
    self.buildDistance.font = FONT(13);
    DLog(@"distance===%@",self.buildingListData.buildDistance);
    self.buildDistance.text = [NSString stringWithFormat:@"%@km",self.buildingListData.buildDistance ];
    self.buildDistance.textAlignment  = NSTextAlignmentLeft;
    self.buildDistance.textColor = TFPLEASEHOLDERCOLOR;
    [self.contentView addSubview:self.buildDistance];
    if ([self isBlankString:self.buildingListData.buildDistance]) {
        self.buildDistance.hidden = YES;
    }
    DLog(@"self.buildingListData.buildDistance ==========>>>>>>>>>------%@",self.buildingListData.buildDistance );
    
    //价钱
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.buildNamelabel.left, self.buildDistance.bottom+3, (kMainScreenWidth-self.buildImageView.right)/3, 15)];
    
    self.priceLabel.textColor = ORIGCOLOR;
    self.priceLabel.font = FONT(13);
    if (![self isBlankString:self.buildingListData.showPriceString]) {
        if ([self.buildingListData.showPriceString isEqualToString:@"0"]) {
            self.priceLabel.text =@"";
        }else{
            self.priceLabel.text =[NSString stringWithFormat:@"%@",self.buildingListData.showPriceString];
        }
    }else{
        self.priceLabel.text =@"";
    }
    [self.contentView addSubview:self.priceLabel];
    
    CGSize priceSize = [self.priceLabel boundingRectWithSize:CGSizeMake((kMainScreenWidth-self.buildImageView.right)/2, 0)];
    self.priceLabel.width = priceSize.width;
    
    NSString *string =[NSString stringWithFormat:@"%@      %@",self.buildingListData.saleAreaSegment,self.buildingListData.bedroomSegment];
    
    UILabel *saleAreaSegmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right+17, self.priceLabel.top, (kMainScreenWidth-self.buildImageView.right)/3*2, self.priceLabel.height)];
    saleAreaSegmentLabel.text =string;
    saleAreaSegmentLabel.textColor = TFPLEASEHOLDERCOLOR;
    saleAreaSegmentLabel.font = FONT(12.f);
    saleAreaSegmentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:saleAreaSegmentLabel];
    
    //    if (self.buildingListData.saleAreaSegment) {
    //        UILabel *saleAreaSegmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right, self.priceLabel.top, self.priceLabel.width, self.priceLabel.height)];
    //        saleAreaSegmentLabel.text = self.buildingListData.saleAreaSegment;
    //        saleAreaSegmentLabel.textColor = TFPLEASEHOLDERCOLOR;
    //        saleAreaSegmentLabel.font = FONT(12.f);
    //        saleAreaSegmentLabel.textAlignment = NSTextAlignmentCenter;
    //        [self.contentView addSubview:saleAreaSegmentLabel];
    //    }
    //
    //    if (self.buildingListData.bedroomSegment.length>0) {
    //        UILabel *bedroomSegmentlabel;
    //        if (self.buildingListData.saleAreaSegment.length>0) {
    //            bedroomSegmentlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right+self.priceLabel.width-20, self.priceLabel.top, self.priceLabel.width, self.priceLabel.height)];
    //        }else{
    //            bedroomSegmentlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right, self.priceLabel.top, self.priceLabel.width, self.priceLabel.height)];
    //        }
    //        bedroomSegmentlabel.textColor = TFPLEASEHOLDERCOLOR;
    //        bedroomSegmentlabel.text = self.buildingListData.bedroomSegment;
    //        bedroomSegmentlabel.font = FONT(12.f);
    //        bedroomSegmentlabel.textAlignment = NSTextAlignmentCenter;
    //        [self.contentView addSubview:bedroomSegmentlabel];
    //
    //    }
    
    //佣金
    if (![self isBlankString:self.buildingListData.formatCommissionStandard] && [self verifyTheRulesWithShouldJump:NO] && [self.buildingListData.commissionDisplay isEqualToString:@"0"])
    {
        self.yongJingView = [[UIView alloc]initWithFrame:CGRectMake(self.priceLabel.left, self.priceLabel.bottom, kMainScreenWidth-self.buildImageView.right-10, 25)];
        UILabel *yongjinLabel;
        yongjinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 15, 15)];
        yongjinLabel.font = FONT(10.f);
        yongjinLabel.text = @"佣";
        yongjinLabel.backgroundColor = BLUEBTBCOLOR;
        yongjinLabel.textAlignment = NSTextAlignmentCenter;
        yongjinLabel.textColor = [UIColor whiteColor];
        yongjinLabel.layer.cornerRadius = 3;
        yongjinLabel.layer.masksToBounds = YES;
        [self.yongJingView addSubview:yongjinLabel];
        
        UILabel *yongjingTitleLabel = [[UILabel alloc]init];
        yongjingTitleLabel.textAlignment = NSTextAlignmentLeft;
        if (iPhone4 || iPhone5 ){
            yongjingTitleLabel.font =FONT(15.f);
            
        }else{
            yongjingTitleLabel.font =FONT(16.f);
            
        }
        yongjingTitleLabel.text = [NSString stringWithFormat:@"%@",self.buildingListData.formatCommissionStandard];
        yongjingTitleLabel.textColor = BLUEBTBCOLOR;
        yongjingTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        CGSize size = [yongjingTitleLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-self.buildImageView.right-10, 25)];
        yongjingTitleLabel.frame = CGRectMake(yongjinLabel.right+3, 4, size.width, size.height);
        [self.yongJingView addSubview:yongjingTitleLabel];
        [self.yongJingView setWidth:yongjingTitleLabel.width+23];
        [self.contentView addSubview:self.yongJingView];
        
    }
    UILabel *recentNewslabel;
    if (self.buildingListData.dynamicMsg.length>0) {
        recentNewslabel = [[UILabel alloc]initWithFrame:CGRectMake(self.buildImageView.left, self.buildImageView.bottom+10, kMainScreenWidth-30, 20)];
        recentNewslabel.textAlignment = NSTextAlignmentLeft;
        recentNewslabel.textColor= NAVIGATIONTITLE;
        recentNewslabel.font = FONT(12.f);
        recentNewslabel.text = [NSString stringWithFormat:@"最新动态: %@",self.buildingListData.dynamicMsg];
        [self.contentView addSubview:recentNewslabel];
        
    }
    
    if (self.tableViewCellStyle == MyBuildingTableViewCellFavoriteStyle) {
        
        UIView *bottonView =  [self creatBottomViewWithFrame:CGRectMake(kMainScreenWidth/2, self.buildingListData.dynamicMsg.length>0?recentNewslabel.bottom+15:self.buildImageView.bottom+15, kMainScreenWidth/2, 30)];
        
        [self.contentView addSubview:bottonView];
        
        UIImageView *finishImageView;
        if (![self isBlankString:self.buildingListData.status])  //status存在
        {
            if ([self.buildingListData.status isEqualToString:@"finished"]) {
                
                finishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                finishImageView.image = [UIImage imageNamed:@"我的收藏-已下架.png"];
                
                [self.buildImageView addSubview:finishImageView];
                
            }else if ([self.buildingListData.status isEqualToString:@"expired"])
            {
                finishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                finishImageView.image = [UIImage imageNamed:@"我的收藏-已失效.png"];
                [self.buildImageView addSubview:finishImageView];
                
            }
            
            if (![self.buildingListData.status isEqualToString:@"finished"]&& ![self.buildingListData.status isEqualToString:@"expired"]) {
                
                if (self.buildingListData.agencyReportType) {
                    finishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
                    finishImageView.image = [UIImage imageNamed:@"stopReport.png"];
                    [self.buildImageView addSubview:finishImageView];
                }
                
            }
            
            
        }
    }
    
    if (self.tableViewCellStyle == HomeTableViewCellStyle){
        
        if (self.buildingListData.agencyReportType) {
            UIImageView *finishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            finishImageView.image = [UIImage imageNamed:@"stopReport.png"];
            [self.buildImageView addSubview:finishImageView];
        }
        
        
        
    }
    
    
    
    
    
}



+ (CGFloat)buildingCellHeightWithModel:(BuildingListData *)model WithbuildingStyle:(TableViewCellStyle )tableViewStyle;
{
    
    if (tableViewStyle == HomeTableViewCellStyle) {
        
        if (model.dynamicMsg.length>0) {
            
            return 132;
        }else{
            
            return 105;
        }
        
    }else if (tableViewStyle == MyBuildingTableViewCellFavoriteStyle)
    {
        if (model.dynamicMsg.length>0) {
            
            return 132+40;
        }else{
            
            return 105+40;
        }
        
    }
    
    return 0;
}

-(UIView *)creatBottomViewWithFrame:(CGRect )frame;
{
    //    self.buildingListData.agencyReportType =  arc4random() %(0+2);
    
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UIButton *baoBeiButton = [[UIButton alloc]initWithFrame:CGRectMake(view.width-10-80, 0, 80, 22.5)];
    [baoBeiButton setTitle:@"报备客户" forState:UIControlStateNormal];
    baoBeiButton.titleLabel.font = FONT(13.f);
    [baoBeiButton addTarget:self action:@selector(baoBeiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    baoBeiButton.layer.cornerRadius = 4;
    baoBeiButton.layer.borderWidth = 1;
    
    if ([self.buildingListData.status isEqualToString:@"finished"] ||[self.buildingListData.status isEqualToString:@"expired"] || self.buildingListData.agencyReportType){
        baoBeiButton.layer.borderColor =UIColorFromRGB(0xbababa).CGColor;
        [baoBeiButton setTitleColor:UIColorFromRGB(0xbababa) forState:UIControlStateNormal];
        baoBeiButton.userInteractionEnabled = NO;
        if (self.buildingListData.agencyReportType) {
            [baoBeiButton setTitle:@"暂停报备" forState:UIControlStateNormal];
            
        }else{
            [baoBeiButton setTitle:@"报备客户" forState:UIControlStateNormal];
            
        }
    }else{
        baoBeiButton.layer.borderColor = BLUEBTBCOLOR.CGColor;
        [baoBeiButton setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        
    }
    
    
    [view addSubview:baoBeiButton];
    
    UIButton *myCustomBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.width-10-80-20-80, 0, 80, 22.5)];
    [myCustomBtn setTitle:@"我的客户" forState:UIControlStateNormal];
    myCustomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
    [myCustomBtn addTarget:self action:@selector(myCustomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    myCustomBtn.layer.cornerRadius = 4;
    myCustomBtn.layer.borderWidth = 1;
    [myCustomBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    myCustomBtn.layer.borderColor =BLUEBTBCOLOR.CGColor;
    [view addSubview:myCustomBtn];
    
    return view;
}


- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)baoBeiBtnClick:(UIButton *)sender
{
    if (![self verifyTheRulesWithShouldJump:NO]) {
        
        [TipsView showTips:@"请先绑定门店才能使用功能哦~" inView:self];
        return;
    }
    
    
    
    DLog(@"报备");
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    
    CustomerReportViewController *VC = [[CustomerReportViewController alloc]init];
    VC.buildingID =self.buildingListData.buildingId;
    VC.bIsShowVisitInfo = self.buildingListData.customerVisitEnable;
    VC.mechanismType = self.buildingListData.mechanismType;
    VC.mechanismText = self.buildingListData.mechanismText;
    VC.type = 3;
    
    VC.buildingName = self.buildingListData.name;
    VC.buildDistance = self.buildingListData.buildDistance;
    VC.featureTag = self.buildingListData.featureTag;
    VC.commission = self.buildingListData.formatCommissionStandard;
    
    
    [nav pushViewController:VC animated:YES];
    
}

-(void)myCustomBtnClick:(UIButton *)sender
{
    if (![self verifyTheRulesWithShouldJump:NO]) {
        
        [TipsView showTips:@"请先绑定门店才能使用功能哦~" inView:self];
        return;
    }
    sender.userInteractionEnabled = NO;
    [[DataFactory sharedDataFactory] getBuildingCustomersWithBId:_buildingListData.buildingId WithCallBack:^(ActionResult *result,NSArray *array) {
        
        sender.userInteractionEnabled = YES;
        if (array.count >0)
        {
            MyCustomersViewController *reportVC = [[MyCustomersViewController alloc] init];
            reportVC.buildingId = _buildingListData.buildingId;
            reportVC.customerArr = array;
            
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            [nav pushViewController:reportVC animated:YES];
            
        }else{
            sender.userInteractionEnabled = YES;
            
            [TipsView showTips:@"您还没有报备过客户，请先报备!" inView:self];
        }
        
    }];
    
    
    
}



- (UIImageView *)creatImageViewWithFrameX:(CGFloat)framex andImageName:(NSString *)imageName;
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(framex, 0, 20, 56/2)];
    imageView.image = [UIImage imageNamed:imageName];
    
    return imageView;
}




-(void)EditNullValue
{
    
    if ([self isBlankString:self.buildingListData.commissionDisplay]) {
        self.buildingListData.commissionDisplay = @"0";
    }
    
    if ([self isBlankString:self.buildingListData.name]) {
        self.buildingListData.name = @"";
    }
    
    if ([self isBlankString:self.buildingListData.price]) {
        self.buildingListData.price = @"0";
    }
    
    if ([self isBlankString:self.buildingListData.recommendationNum])
    {
        self.buildingListData.recommendationNum = @"0";
    }
    
    if ([self isBlankString:self.buildingListData.visitNum])
    {
        self.buildingListData.visitNum = @"0";
    }
    
    if ([self isBlankString:self.buildingListData.signNum])
    {
        self.buildingListData.signNum = @"0";
    }
    
    
}



- (BOOL)verifyTheRulesWithShouldJump:(BOOL)isShouldJump;
{
    UserData *user = [UserData sharedUserData];
    if ([self isBlankString:user.storeId])
    {
        
        return NO;
        
    }
    else
    {
        //有门店
        return YES;
    }
    return NO;
    
}

@end

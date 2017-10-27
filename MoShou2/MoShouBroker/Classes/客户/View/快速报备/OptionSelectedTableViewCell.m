//
//  OptionSelectedTableViewCell.m
//  MoShou2
//
//  Created by wangzz on 15/12/14.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "OptionSelectedTableViewCell.h"
#import "UILabel+StringFrame.h"
#import "AutoLabel.h"

#import "UserData.h"

@implementation OptionSelectedTableViewCell
@synthesize custTelTypeL;

- (instancetype)initWithBuildListData:(CustomerBuilding *)buildListData AndTableType:(NSInteger)tableType
{
    self = [super init];
    if (self) {
        _buildingListData = buildListData;
        self.backgroundColor = [UIColor whiteColor];
        _tableType = tableType;
        [self createOptionCell];
    }
    return self;
}

- (void)createOptionCell
{
    _loupNameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kMainScreenWidth-20-70-65, 30)];
    _loupNameL.text = _buildingListData.buildingName;
    _loupNameL.textColor = NAVIGATIONTITLE;
    _loupNameL.textAlignment = NSTextAlignmentLeft;
    _loupNameL.font = FONT(16);
    [self.contentView addSubview:_loupNameL];
    //距离
    _juliView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth-70-55, 10, 70, 20)];
    [self.contentView addSubview:_juliView];
    
    UIImageView *dituIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 7, 9)];
    [dituIcon setImage:[UIImage imageNamed:@"iconfont-yeguoditu.png"]];
    [_juliView addSubview:dituIcon];
    
    UILabel *buildDistance = [[UILabel alloc]initWithFrame:CGRectMake(dituIcon.right+5, 2, 60, 16)];
    buildDistance.font = FONT(13);
    buildDistance.textColor = TFPLEASEHOLDERCOLOR;
    buildDistance.text = [NSString stringWithFormat:@"%@km",self.buildingListData.distance];
    [_juliView addSubview:buildDistance];
    
    _yongJinView = [[UIView alloc]initWithFrame:CGRectMake(_loupNameL.left, _loupNameL.bottom, _loupNameL.width-50, 30)];
    [self.contentView addSubview:_yongJinView];
    
    UILabel *yongjinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 18, 18)];
    yongjinLabel.text = @"佣";
    yongjinLabel.backgroundColor = ORIGCOLOR;
    yongjinLabel.textAlignment = NSTextAlignmentCenter;
    yongjinLabel.textColor = [UIColor whiteColor];
    yongjinLabel.font = [UIFont systemFontOfSize:13.5];
    yongjinLabel.layer.cornerRadius = 3;
    yongjinLabel.layer.masksToBounds = YES;
    [_yongJinView addSubview:yongjinLabel];
    
    UILabel *yongjingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(yongjinLabel.right+3, 5, _yongJinView.width-20-3, 20)];
    yongjingTitleLabel.textAlignment = NSTextAlignmentLeft;
    yongjingTitleLabel.text = _buildingListData.commission;
    yongjingTitleLabel.textColor = ORIGCOLOR;
    yongjingTitleLabel.font = [UIFont systemFontOfSize:15];
    [_yongJinView addSubview:yongjingTitleLabel];
    
    NSString *feature = self.buildingListData.featureTag;
    CGFloat featureX;
    if ([self isBlankString:_buildingListData.commission]) {
        featureX = 20;
        _yongJinView.hidden = YES;
    }else{
        featureX = _loupNameL.right-25-5;
        _yongJinView.hidden = NO;
    }
    
    UILabel *featureTagLabel = [[UILabel alloc]initWithFrame:CGRectMake(featureX, _loupNameL.bottom+7.5, 45, 15)];
    featureTagLabel.textColor = BLUEBTBCOLOR;
    featureTagLabel.font = FONT(11);
    featureTagLabel.textAlignment = NSTextAlignmentCenter;
    [featureTagLabel.layer setBorderColor:BLUEBTBCOLOR.CGColor];
    featureTagLabel.layer.cornerRadius = 3;
    featureTagLabel.layer.masksToBounds = YES;
    [featureTagLabel.layer setBorderWidth:0.8];
    [self addSubview: featureTagLabel];
    
    CGFloat custTelTypeX;
#pragma mark -约车看房
/*    UserData *user = [UserData sharedUserData];
    if (user.trystCarEnable) {
        feature = @"约车看房";
    }else
    {
        
    }*/
    //特色标签
    if (![self isBlankString:feature])
    {
        //不为空
        if ([feature rangeOfString:@","].location!=NSNotFound)
        {  //有分号,
            NSArray *array = [feature componentsSeparatedByString:@","];
            feature = [array objectForIndex:0];
        }
        featureTagLabel.text = feature;
        featureTagLabel.hidden = NO;
        custTelTypeX = featureTagLabel.right+5;
    }else
    {
        featureTagLabel.hidden = YES;
        if (featureX == 20) {
            custTelTypeX = featureX;
        }else
        {
            custTelTypeX = _juliView.left;
        }
    }
    
    custTelTypeL = [[UILabel alloc]initWithFrame:CGRectMake(custTelTypeX, _loupNameL.bottom+7.5, 55, 15)];
    custTelTypeL.text = @"全号报备";
    custTelTypeL.hidden = YES;
    custTelTypeL.textColor = [UIColor colorWithHexString:@"fc6c33"];
    custTelTypeL.font = FONT(11);
    custTelTypeL.textAlignment = NSTextAlignmentCenter;
    [custTelTypeL.layer setBorderColor:[UIColor colorWithHexString:@"fc6c33"].CGColor];
    custTelTypeL.layer.cornerRadius = 3;
    custTelTypeL.layer.masksToBounds = YES;
    [custTelTypeL.layer setBorderWidth:0.8];
    [self addSubview: custTelTypeL];
    
    //手机号是否全部显示 （0全部显示，1部分显示）
    BOOL bMobileVisable = [UserData sharedUserData].userInfo.mobileVisable;
    if (bMobileVisable && [_buildingListData.customerTelType boolValue]) {
        custTelTypeL.hidden = NO;
    }
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.frame = CGRectMake(kMainScreenWidth-40-15, _loupNameL.bottom-15, 40, 40);
    [_selectedBtn setBackgroundColor:[UIColor clearColor]];
    [_selectedBtn setImage:[UIImage imageNamed:@"big_selected"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"big_selected_h"] forState:UIControlStateSelected];
    [_selectedBtn addTarget:self action:@selector(toggleSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectedBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(kMainScreenWidth-40-15, _loupNameL.bottom-15, 40, 40);
    [_deleteBtn setBackgroundColor:[UIColor clearColor]];
    [_deleteBtn setImage:[UIImage imageNamed:@"iconfont-guanbi"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(toggleDelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
//    if ([_buildingListData.customerVisitEnable boolValue]) {
        //应开发商要求，该楼盘报备必须填写客户到访信息
        _visitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_loupNameL.left, _yongJinView.bottom, kMainScreenWidth, 30)];
//    _visitLabel.text = _buildingListData.customerVisitText;
        _visitLabel.textColor = BLUEBTBCOLOR;
        _visitLabel.font = FONT(13);
        [self.contentView addSubview:_visitLabel];
//    }
    
    if (_tableType) {
        _juliView.hidden = YES;
        _selectedBtn.hidden = YES;
        _deleteBtn.hidden = NO;
    }else
    {
        _juliView.hidden = NO;
        _selectedBtn.hidden = NO;
        _deleteBtn.hidden = YES;
    }
    if ([self isBlankString:self.buildingListData.distance])
    {
        _juliView.hidden = YES;;
    }else
    {
        _juliView.hidden = NO;
    }
}

-(void)setBIsShowVisitInfo:(BOOL)bIsShowVisitInfo
{
    if (_bIsShowVisitInfo != bIsShowVisitInfo) {
        _bIsShowVisitInfo = bIsShowVisitInfo;
    }
    if (_bIsShowVisitInfo) {
        _visitLabel.hidden = YES;
        _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(_loupNameL.left, _yongJinView.bottom+10, kMainScreenWidth*18.5/25, 70)];
        _showVisitInfoView.showInfoType = kShowVisitInfo;
        [self.contentView addSubview:_showVisitInfoView];
        if (_bIsShowConfirmInfo) {
            _showVisitInfoView.height = 90;
        }
    }
}

-(void)setBIsShowConfirmInfo:(BOOL)bIsShowConfirmInfo
{
    if (_bIsShowConfirmInfo != bIsShowConfirmInfo) {
        _bIsShowConfirmInfo = bIsShowConfirmInfo;
    }
    
    if (_bIsShowConfirmInfo) {
        if (_bIsShowVisitInfo) {
           _showVisitInfoView.height = 90;
        }else
        {
            _visitLabel.hidden = YES;
            _showVisitInfoView = [[CustomerShowVisitInfoView alloc] initWithFrame:CGRectMake(_loupNameL.left, _yongJinView.bottom+10, kMainScreenWidth*18.5/25, 30)];
            _showVisitInfoView.showInfoType = kShowConfirmInfo;
            [self.contentView addSubview:_showVisitInfoView];
            
        }
    }
}

-(void)optionDeleteCellBlock:(deleteOptionsBlock)ablock
{
    self.didDelectedLouPOption = ablock;
}

-(void)optionSelectCellBlock:(selecteOptionsBlock)ablock
{
    self.didSelectedLouPOption = ablock;
}

- (void)toggleDelectedBtn:(UIButton*)sender
{
    _didDelectedLouPOption(self);
}

- (void)toggleSelectedBtn:(UIButton*)sender
{
    if (!sender.selected) {
        sender.selected = YES;
    }else
    {
        sender.selected = NO;
    }
    _didSelectedLouPOption(self,sender.selected);
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

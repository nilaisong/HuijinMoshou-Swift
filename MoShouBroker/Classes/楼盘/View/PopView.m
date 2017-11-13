//
//  PopView.m
//  MoShou2
//
//  Created by Mac on 2016/12/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "PopView.h"
#import "Discount.h"
#import "AutoLabel.h"
#import "MyImageView.h"

@implementation PopView
{
    UILabel *_titleLabel;
    UIView *_youHuiHuoDongView;
    UIView *_renChouHuoDongView;

    
}
-(id)initWithType:(PopViewType)popViewType AndBuilding:(Building *)building;
{

    self = [super initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, kMainScreenHeight)];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.popViewType = popViewType;
        self.buildingMo = building;
        self.estateBuildingMo = self.buildingMo.estate;
        [self loadUI];
    }
    
    return self;

}


-(void)loadUI{
    
//    UIView *bgView = [[UIView alloc]initWithFrame:self.frame];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.alpha = 0.3;
//    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    
    [self addGestureRecognizer:tap];
    
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    self.bgScrollView.contentOffset = CGPointMake(0, 0);
    [self addSubview:self.bgScrollView];
//    头部文本高度58
//    116/2
    _titleLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, kMainScreenWidth, 58) text:@"活动信息" textAlignment:NSTextAlignmentCenter fontSize:18.f textColor:UIColorFromRGB(0x333333)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    
    [self.bgScrollView addSubview:_titleLabel];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-58, _titleLabel.top, 58, 58)];
    [closeBtn setImage:[UIImage imageNamed:@"优惠活动-弹窗关闭"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:closeBtn];
    
    if (self.popViewType  ==  kRenChouHuoDong) {
        _titleLabel.text = @"活动信息";
        [self loadRenChouHuoDongUI];
    }else if(self.popViewType  == kCommissionRuleCooperationRule){
        _titleLabel.text = @"佣金及合作规则";
        [self loadCommissionRuleCooperationRuleUI];
        
    }else if(self.popViewType == kOnLineChat){
        _titleLabel.text = @"在线咨询";
        [self loadOnLineChatUI];
        
    }else if (self.popViewType == kConnectionsSquare){
      _titleLabel.text = @"联系驻场";
        [self loadkConnectionsSquareUI];
    }else if (self.popViewType == kConsultBuilding){
        _titleLabel.text = @"选择咨询楼盘";

        [self loadConsultBuilding];
    }else if (self.popViewType == kRecommendBuilding){
        _titleLabel.text = @"选择推荐楼盘";
        
        [self loadConsultBuilding];
    }
    

    [self changeSelfHeight];

}
-(void)loadRenChouHuoDongUI  //优惠活动和认筹活动
{//    优惠活动
    if (self.buildingMo.youHuiLists.count>0) {
        _youHuiHuoDongView = [[UIView alloc]initWithFrame:CGRectMake(0, 58, kMainScreenWidth, 300)];
        [self.bgScrollView addSubview:_youHuiHuoDongView];

        UIImageView *youHuiIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,20, 18, 18)];
        youHuiIconImageView.image = [UIImage imageNamed:@"优惠活动-拥有项"];
        [_youHuiHuoDongView addSubview:youHuiIconImageView];
        
        UILabel *youhuiTitleLabel = [UILabel createLabelWithFrame:CGRectMake(youHuiIconImageView.right+20, youHuiIconImageView.top, kMainScreenWidth-60, 18) text:@"优惠活动" textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        youhuiTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [_youHuiHuoDongView addSubview:youhuiTitleLabel];
        
        for (NSInteger i = 0; i < _buildingMo.youHuiLists.count; i ++) {
            Discount *discontModel = _buildingMo.youHuiLists[i];
            NSInteger lastNum = i;
            UIView *lastView = (UIView *)[_youHuiHuoDongView viewWithTag:2000+lastNum-1];
            UIView *oneYouhuiView =   [self creatOneHuoDongViewWithFrame:CGRectMake(0, i==0?10+youhuiTitleLabel.bottom:lastView.bottom+20, kMainScreenWidth, 0) WithModel:discontModel];
            oneYouhuiView.tag = i+2000;
            [_youHuiHuoDongView addSubview:oneYouhuiView];
        }
        UIView *endView = (UIView *)[_youHuiHuoDongView viewWithTag:2000+_buildingMo.youHuiLists.count-1];
        _youHuiHuoDongView.height = endView.bottom;
        [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, _youHuiHuoDongView.bottom+50)];
    }
    
////    认筹活动
    if (_buildingMo.renChouLists.count>0) {
        
        _renChouHuoDongView = [[UIView alloc]initWithFrame:CGRectMake(0, _buildingMo.youHuiLists.count>0?_youHuiHuoDongView.bottom+20:58, kMainScreenWidth, 0)];
        [self.bgScrollView addSubview:_renChouHuoDongView];

        UIImageView *renChouIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,20, 18, 18)];
        renChouIconImageView.image = [UIImage imageNamed:@"优惠活动-拥有项"];
        [_renChouHuoDongView addSubview:renChouIconImageView];
        
        UILabel *renChouTitleLabel = [UILabel createLabelWithFrame:CGRectMake(renChouIconImageView.right+20, renChouIconImageView.top, kMainScreenWidth-60, 18) text:@"认筹活动" textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        renChouTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [_renChouHuoDongView addSubview:renChouTitleLabel];
        
        for (NSInteger i = 0; i < _buildingMo.renChouLists.count; i ++) {
            Discount *discontModel = _buildingMo.renChouLists[i];
            
            NSInteger lastNum = i;
            UIView *lastView = (UIView *)[_renChouHuoDongView viewWithTag:3000+lastNum-1];
            UIView *oneYouhuiView =   [self creatOneHuoDongViewWithFrame:CGRectMake(0, i==0?10+renChouTitleLabel.bottom:lastView.bottom+20, kMainScreenWidth, 0) WithModel:discontModel];
            oneYouhuiView.tag = i+3000;
            
            [_renChouHuoDongView addSubview:oneYouhuiView];
            
        }
        UIView *endView = (UIView *)[_renChouHuoDongView viewWithTag:3000+_buildingMo.renChouLists.count-1];
        
        _renChouHuoDongView.height = endView.bottom;
        
        [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, _renChouHuoDongView.bottom+50)];
    }
    
}

-(void)loadCommissionRuleCooperationRuleUI  //佣金以及合作规则
{
    UIView *yongJingGuiZeBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 58, kMainScreenWidth, 300)];
    [self.bgScrollView addSubview:yongJingGuiZeBaseView];
    
    UIImageView *youHuiIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,20, 18, 18)];
    youHuiIconImageView.image = [UIImage imageNamed:@"优惠活动-拥有项"];
    [yongJingGuiZeBaseView addSubview:youHuiIconImageView];
    
    UILabel *yongJingTitleLabel = [UILabel createLabelWithFrame:CGRectMake(youHuiIconImageView.right+20, youHuiIconImageView.top, kMainScreenWidth-60, 18) text:@"佣金规则" textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
    yongJingTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [yongJingGuiZeBaseView addSubview:yongJingTitleLabel];

    AutoLabel *yongjinLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(yongJingTitleLabel.left, yongJingTitleLabel.bottom+10, kMainScreenWidth-60, 0) andTitle:@"佣       金: " andContent:_estateBuildingMo.formatCommissionStandard];
    yongjinLabel.contentLabel.textColor = BLUEBTBCOLOR;
    [yongJingGuiZeBaseView addSubview:yongjinLabel];
    
    
    AutoLabel *yongjinGuizeLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(yongJingTitleLabel.left, yongjinLabel.bottom+10, kMainScreenWidth-60, 0) andTitle:@"佣金规则: " andContent:_estateBuildingMo.commissionStandard];
    yongjinGuizeLabel.contentLabel.textColor = BLUEBTBCOLOR;

    [yongJingGuiZeBaseView addSubview:yongjinGuizeLabel];
    
    
//    UILabel *guiZeLabel = [[UILabel alloc]init];
//    guiZeLabel.textColor = BLUEBTBCOLOR;
//    guiZeLabel.font = FONT(14.f);
//    guiZeLabel.textAlignment = NSTextAlignmentLeft;
//    guiZeLabel.numberOfLines = 0;
//    guiZeLabel.text =_estateBuildingMo.commissionStandard;
//    CGSize size =  [guiZeLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-yongJingTitleLabel.left-20, 0)];
//    guiZeLabel.frame =CGRectMake(yongJingTitleLabel.left, yongJingTitleLabel.bottom+10, size.width, size.height);
//    [yongJingGuiZeBaseView addSubview:guiZeLabel];
    yongJingGuiZeBaseView.height = yongjinGuizeLabel.bottom;

//    UILabel *label = [UILabel createLabelWithFrame:CGRectMake(guiZeLabel.left, guiZeLabel.bottom+10, kMainScreenWidth-guiZeLabel.left-10, 13) text:@"客户签约后可计算佣金" textAlignment:NSTextAlignmentLeft fontSize:12.f textColor:UIColorFromRGB(0x888888)];
//    [yongJingGuiZeBaseView addSubview:label];
//    yongJingGuiZeBaseView.height = label.bottom;
    
   
    //合作规则
    NSString * protectorString ;
    if ([_estateBuildingMo.customerProtectTerm isEqualToString:@"1"]) {
        
        protectorString = [NSString stringWithFormat:@"带看开始%@天",_estateBuildingMo.effectiveType];
         }else{
        protectorString = [NSString stringWithFormat:@"报备开始%@天",_estateBuildingMo.effectiveType];
    }
    //    报备有效时间
    //    record_effective_type  报备有效类型(0:无限。1:当天有效截止24小时。2具体小时)
    //    record_effective_time   报备有效时间（type 为2的时候这个才有值）
    NSString * recordEffectiveTimeString;
    if ([_estateBuildingMo.recordEffectiveType isEqualToString:@"0"]) {
        recordEffectiveTimeString = @"报备成功即可带看";
    }else if ([_estateBuildingMo.recordEffectiveType isEqualToString:@"1"]){
        recordEffectiveTimeString = @"报备成功当天有效（截止到24点），从报备成功开始，超过期限没有带看，经纪人可重新报备.";
    }else if ([_estateBuildingMo.recordEffectiveType isEqualToString:@"2"]){
        recordEffectiveTimeString = [NSString stringWithFormat:@"报备成功%.1f小时之内有效，从报备成功开始，超过期限没有带看，经纪人可重新报备",_estateBuildingMo.recordEffectiveTime];
    }
    
    
//    NSArray *titleArr = @[@"起止日期",@"带看规则",@"成交标准",@"报备时效",@"客户保护",@"报备号码",@"到访信息"];
    NSArray *titleArr = @[@"起止日期",@"报备时效",@"报备号码",@"到访信息",@"带看规则",@"成交标准",@"客户保护",];
    
    //后么两项需要确认
    NSString *customerTelTypeString;
    if ([_estateBuildingMo.customerTelType isEqualToString:@"0"]) {
        customerTelTypeString = @"全号隐号均可报备";
    }else if([_estateBuildingMo.customerTelType isEqualToString:@"1"]){
        customerTelTypeString = @"仅全号报备";
    }
    NSString *customerVisitEnableString;
    if (_estateBuildingMo.customerVisitEnable) {
        customerVisitEnableString = @"需要填写";
    }else{
        customerVisitEnableString = @"不需要填写";
    }

    NSArray *titleContentArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@至%@",_estateBuildingMo.proxyStartTime,_estateBuildingMo.proxyEndTime],recordEffectiveTimeString,customerTelTypeString,customerVisitEnableString,_estateBuildingMo.customerVisteRule,_estateBuildingMo.dealStandar,protectorString, nil];
    
    UIView *heZuoGuiZeBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, yongJingGuiZeBaseView.bottom+20, kMainScreenWidth, 300)];
    [self.bgScrollView addSubview:heZuoGuiZeBaseView];
    
    UIImageView *heZuoIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,20, 18, 18)];
    heZuoIconImageView.image = [UIImage imageNamed:@"优惠活动-拥有项"];
    [heZuoGuiZeBaseView addSubview:heZuoIconImageView];
    
    UILabel *heZuoTitleLabel = [UILabel createLabelWithFrame:CGRectMake(heZuoIconImageView.right+20, heZuoIconImageView.top, kMainScreenWidth-60, 18) text:@"合作规则" textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
    heZuoTitleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [heZuoGuiZeBaseView addSubview:heZuoTitleLabel];

    for (int i = 0; i < titleArr.count; i ++)
    {
        NSInteger lastNum = i;
        
        AutoLabel *lastlabel = (AutoLabel *)[heZuoGuiZeBaseView viewWithTag:8300+lastNum-1];
        
        AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(heZuoTitleLabel.left, i==0?heZuoTitleLabel.bottom+10:lastlabel.bottom+9, kMainScreenWidth-heZuoTitleLabel.left-10,0) andTitle: [NSString stringWithFormat:@"%@ :  ",titleArr[i]] andContent:titleContentArr[i]];
        
        autoLabel.tag = 8300+i;
        
        [heZuoGuiZeBaseView addSubview:autoLabel];
        
    }
    AutoLabel *endLabel = (AutoLabel *)[heZuoGuiZeBaseView viewWithTag:8300+titleArr.count-1];

    heZuoGuiZeBaseView.height = endLabel.bottom;
    
    [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, heZuoGuiZeBaseView.bottom+50)];

    


}

-(void)loadOnLineChatUI  //在线咨询
{
    for (NSInteger i = 0; i< _buildingMo.easemobConfirmList.count; i ++) {
        EasemobConfirmModel *model = _buildingMo.easemobConfirmList[i];
        
        UIButton *view =  [self creatOneChatAndConsultViewWithFrame:CGRectMake(0, _titleLabel.bottom+i*64, kMainScreenWidth, 64) WithModel:model];
        view.tag = 5000+i;
        [view addTarget:self action:@selector(onlineClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i%2 != 0) {
            view.backgroundColor = [UIColor whiteColor];
        }else{
            view.backgroundColor = UIColorFromRGB(0xfafafa);
        }
        [self.bgScrollView addSubview:view];
        
        UIView *lastView = (UIView *)[self.bgScrollView viewWithTag:5000+_buildingMo.easemobConfirmList.count-1];
        [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, lastView.bottom+50)];
        
    }
}

-(void)loadkConnectionsSquareUI
{
    for (NSInteger i = 0; i< _buildingMo.caseTelList.count; i ++) {
        CaseTelList *model = _buildingMo.caseTelList[i];
        
        UIButton *view =  [self creatOneChatAndConsultViewWithFrame:CGRectMake(0, _titleLabel.bottom+i*64, kMainScreenWidth, 64) WithModel:model];
        view.tag = 6000+i;
        [view addTarget:self action:@selector(ConnectionsSquareClick:) forControlEvents:UIControlEventTouchUpInside];

        if (i%2 != 0) {
            view.backgroundColor = [UIColor whiteColor];
        }else{
            view.backgroundColor = UIColorFromRGB(0xfafafa);
        }
        [self.bgScrollView addSubview:view];
        UIView *lastView = (UIView *)[self.bgScrollView viewWithTag:6000+_buildingMo.caseTelList.count-1];
        [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, lastView.bottom+50)];
        
    }
    
}

//咨询楼盘
- (void)loadConsultBuilding
{
    if (_buildingMo.ziXunBuildingArray.count>0) {
        
        for (NSInteger i = 0; i < _buildingMo.ziXunBuildingArray.count; i ++) {
            Estate *model = _buildingMo.ziXunBuildingArray[i];
            UIButton *button = [self creatOneChatAndConsultViewWithFrame:CGRectMake(0, _titleLabel.bottom+i*95, kMainScreenWidth, 95) WithModel:model];
            button.tag = 9000+i;
            [button addTarget:self action:@selector(ConsultBuildingClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i%2 != 0) {
                button.backgroundColor = [UIColor whiteColor];
            }else{
                button.backgroundColor = UIColorFromRGB(0xfafafa);
            }
            [self.bgScrollView addSubview:button];
            UIView *lastView = (UIView *)[self.bgScrollView viewWithTag:9000+_buildingMo.ziXunBuildingArray.count-1];
            [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, lastView.bottom+50)];
            
        }
    }else{  //没有咨询楼盘的界面
    
        UILabel *noDataLabel = [UILabel createLabelWithFrame:CGRectMake(0, _titleLabel.bottom+(kMainScreenWidth/3-_titleLabel.height)/2+20, kMainScreenWidth, 13) text:@"很抱歉,暂时没有可选择楼盘" textAlignment:NSTextAlignmentCenter fontSize:12.f textColor:UIColorFromRGB(0x888888)];
            
        [self.bgScrollView addSubview:noDataLabel];
        }
    
}
-(UIView *)creatOneHuoDongViewWithFrame:(CGRect)frame WithModel:(Discount *)discount
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    AutoLabel *huodongLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(48, 0, kMainScreenWidth-48-10, 20) andTitle:@"活动名称: " andContent:discount.name];
    [view addSubview:huodongLabel];
    
    AutoLabel *yingfuLabel;
    if (discount.amount.length>0) {
      yingfuLabel= [[AutoLabel alloc]initWithFrame:CGRectMake(huodongLabel.left, 9+huodongLabel.bottom, kMainScreenWidth-48-10, 20) andTitle:@"应付金额: " andContent:discount.amount.length>0?[NSString stringWithFormat:@"%@",discount.amount]:@""];
        [view addSubview:yingfuLabel];
    }

    AutoLabel *youHuiLabel;
    
    if (discount.discription.length >0) {
        youHuiLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(huodongLabel.left, discount.amount.length>0?yingfuLabel.bottom+9:huodongLabel.bottom+8, kMainScreenWidth-48-10, 20) andTitle:@"优惠信息: " andContent:discount.discription];
        [view addSubview:youHuiLabel];}

    CGFloat jieZhiLabelTop = discount.discription.length>0?youHuiLabel.bottom+9:(discount.amount.length>0?yingfuLabel.bottom+9:huodongLabel.bottom+9);
    
    AutoLabel *jieZhiLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(huodongLabel.left, jieZhiLabelTop , kMainScreenWidth-48-10, 20) andTitle:@"起止时间: " andContent: [NSString stringWithFormat:@"%@至%@",discount.startTime,discount.endTime]];
    [view addSubview:jieZhiLabel];

    view.height = jieZhiLabel.bottom;
    
    return view;
    
}

-(UIButton *)creatOneChatAndConsultViewWithFrame:(CGRect )frame WithModel:(id)model {
    UIButton *view;
    if (self.popViewType == kOnLineChat) {
        
        EasemobConfirmModel *easeModel = model;
        view = [[UIButton alloc]initWithFrame:frame];

        //    头像40*40    整体高度 64
       MyImageView *headPicImageView = [[MyImageView alloc]initWithFrame:CGRectMake(20, (view.height-40)/2, 40, 40)];
        headPicImageView.layer.cornerRadius = headPicImageView.width/2;
        headPicImageView.layer.masksToBounds = YES;
        [headPicImageView setImageWithUrlString:easeModel.headPic placeholderImage: [UIImage imageNamed:@"在线咨询-头像"]];
        
        [view addSubview:headPicImageView];
        
        UILabel *nameLabel = [UILabel createLabelWithFrame:CGRectMake(headPicImageView.right+10, 15, kMainScreenWidth/2, (view.height-30)/2) text:easeModel.nickname textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [view addSubview:nameLabel];
        
        UILabel *onLineTypeLabel = [UILabel createLabelWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, kMainScreenWidth/2, nameLabel.height) text:nil textAlignment:NSTextAlignmentLeft fontSize:12 textColor:[UIColor blackColor]];
        if ([easeModel.status isEqualToString:@"online"]) {
            onLineTypeLabel.text =  [NSString stringWithFormat:@"[在线]"];
            onLineTypeLabel.textColor = UIColorFromRGB(0x00d319);
            
        }else{
            onLineTypeLabel.text =  [NSString stringWithFormat:@"[离线请留言]"];
            onLineTypeLabel.textColor = UIColorFromRGB(0x888888);
        }
        [view addSubview:onLineTypeLabel];
        
        UIImageView *chatIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-20-24, (view.height-24)/2, 24, 24)];
        chatIconImageView.image = [UIImage imageNamed:@"在线咨询"];
        [view addSubview:chatIconImageView];
        
        return view;
        
    }
    
    if (self.popViewType == kConnectionsSquare) {
        view = [[UIButton alloc]initWithFrame:frame];

        CaseTelList *caseModel = model;
        UILabel *caseNameLabel = [UILabel createLabelWithFrame:CGRectMake(20, 15, kMainScreenWidth/2, (view.height-30)/2) text:caseModel.caseUsername textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        caseNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [view addSubview:caseNameLabel];
        
        UILabel *phoneLabel = [UILabel createLabelWithFrame:CGRectMake(caseNameLabel.left, caseNameLabel.bottom, kMainScreenWidth/2, caseNameLabel.height) text:caseModel.caseTel textAlignment:NSTextAlignmentLeft fontSize:12 textColor:UIColorFromRGB(0x888888)];
               [view addSubview:phoneLabel];
        
        if (caseModel.caseUsername.length==0) {
            phoneLabel.top = (view.height-phoneLabel.height)/2;
        }
        
        UIImageView *chatIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-20-24, (view.height-24)/2, 24, 24)];
        chatIconImageView.image = [UIImage imageNamed:@"联系案场"];
        [view addSubview:chatIconImageView];
        
        return view;

    }
    
    if(self.popViewType == kConsultBuilding)
    {
        view = [[UIButton alloc]initWithFrame:frame];
        Estate *eatateMo = model;
        
        MyImageView *imageView = [[MyImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 75)];
        [imageView setImageWithUrlString:eatateMo.url placeholderImage:[UIImage imageNamed:@"首页-资讯默认图"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        
        UILabel *buildingNameLabel = [UILabel createLabelWithFrame:CGRectMake(imageView.right+10, 30, kMainScreenWidth/2, 17) text:eatateMo.name textAlignment:NSTextAlignmentLeft fontSize:16.f textColor:UIColorFromRGB(0x333333)];
        buildingNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [view addSubview:buildingNameLabel];
        
        UILabel *districtNameLabel = [UILabel createLabelWithFrame:CGRectMake(imageView.right+10, buildingNameLabel.bottom+10, kMainScreenWidth/2, 13) text:[NSString stringWithFormat:@"%@-%@",eatateMo.districtName,eatateMo.plateName] textAlignment:NSTextAlignmentLeft fontSize:12.f textColor:UIColorFromRGB(0x888888)];
        [view addSubview:districtNameLabel];
        
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-10-55, (view.height-23)/2, 55, 23)];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
        sendButton.layer.cornerRadius = 5;
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.borderColor = BLUEBTBCOLOR.CGColor;
        sendButton.layer.borderWidth = 1.f;
        sendButton.userInteractionEnabled = NO;
        [view addSubview:sendButton];
        
        return view;

    }
    
    
 
    
    
    
    return view;
    
    
}


-(void)changeSelfHeight
{
    DLog(@"self.bgScrollView.contentSize.height==%f",self.bgScrollView.contentSize.height);
    
    if (self.bgScrollView.contentSize.height>(kMainScreenHeight/3)*2) {
        
        self.bgScrollView.height = (kMainScreenHeight/3)*2;
        
    }else if(self.bgScrollView.contentSize.height<(kMainScreenHeight/3)*2 && self.bgScrollView.contentSize.height>kMainScreenHeight/3){
    
        self.bgScrollView.height = self.bgScrollView.contentSize.height;
        
    
    }else if(self.bgScrollView.contentSize.height<kMainScreenHeight/3){
        
        self.bgScrollView.height = kMainScreenHeight/3;
    }
   
    self.height = self.bgScrollView.height;
    
    DLog(@"self.bgScrollView.contentSize.height==%f",self.bgScrollView.contentSize.height);
    DLog(@"self..height==%f",self.height);
    
}

-(void)ConnectionsSquareClick:(UIButton *)btn
{
    
    CaseTelList *model = _buildingMo.caseTelList[btn.tag-6000];
    
    self.DidSelectOneCaseTelViewBlock(model);
    [self removeAllPopSubView];

}
-(void)onlineClick:(UIButton *)btn
{
    EasemobConfirmModel *model = _buildingMo.easemobConfirmList[btn.tag-5000];

    self.DidSelectOneEasemobConfirmBlock(model);
    [self removeAllPopSubView];
    
}


-(void)ConsultBuildingClick:(UIButton *)btn
{
    
    Estate *model = _buildingMo.ziXunBuildingArray[btn.tag-9000];
    
    self.DidSelectOneBuildingBlock(model);
    [self removeAllPopSubView];

    
    
    
}



//点击关闭
-(void)closeBtnClick:(UIButton *)btn
{
    
    
    [self removeAllPopSubView];
    
}
-(void)tapClick{
    
    [self removeAllPopSubView];

}

-(void)removeAllPopSubView
{
    
//    [self removeAllSubviews];
//    [self removeFromSuperview];

    if ([self.delegate respondsToSelector:@selector(didCancelWith:)]) {
        
        [self.delegate didCancelWith:self];
    }
    
}


@end

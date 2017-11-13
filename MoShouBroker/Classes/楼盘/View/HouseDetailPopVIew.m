//
//  HouseDetailPopVIew.m
//  MoShou2
//
//  Created by strongcoder on 15/12/8.
//  Copyright © 2015年 5i5j. All rights reserved.
//
#import "AutoLabel.h"
#import "HouseDetailPopVIew.h"
#define EMPTYSTRING @""

@implementation HouseDetailPopVIew


-(id)initWithType:(viewType)viewType AndBuilding:(Building *)building;
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (self) {
        
        self.viewType = viewType;
        self.buildingMo = building;
        self.estateBuildingMo = self.buildingMo.estate;
        self.alpha = 0;
        [self loadUI];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            [self setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            
        }completion:^(BOOL finished) {
            
        }];
    }
    return self;
}

-(void)loadUI
{
    
    DLog(@"name======%@",_buildingMo.name);
    
    [self EditNullValue];
    
    DLog(@"name======%@",_buildingMo.name);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    [self addGestureRecognizer:tap];
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    
    
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
//    self.bgScrollView.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight);
    self.bgScrollView.contentOffset = CGPointMake(0, 0);
    
    [self addSubview:self.bgScrollView];
    
    switch (self.viewType) {
        case kHouseDetail:
        {
            
            [self loadHouseDetail];  //楼盘详情
        }
            
            break;
            
            case kCommissionRule:  //佣金规则
        {
            [self loadCommissionRule];
            
            
        }
            break;
            
            case kCooperationRule:   // 合作规则
        {
             [self loadCooperationRule];
        }
            break;
            
        default:
            break;
    }
    
}

//楼盘详情
-(void)loadHouseDetail
{
    [self EditNullValue];
    
    
    /**
     *  新需求
     */
//    需求描述：
//    增加“价格详情”字段（文本字段，选项项），位于 均价和面积之间，有内容时展示，没有内容时隐藏处理
//    增加“楼盘卖点”字段（文本字段，必填项），放到特色标签下方；
    NSArray *titleArr2;
    NSArray *titleContentent2;
    
//    if (_estateBuildingMo.priceDetail.length>0) {
//        
//        
//        titleArr2 = @[ @"均价",@"价格详情",@"面积区间",@"特色标签",@"楼盘卖点",@"楼盘简介",@"绿化率",@"容积率",@"车位占比",@"停车位",@"项目内总套数",@"占地面积",@"建筑面积",@"装修标准"];
//        
//        titleContentent2 = @[ [NSString stringWithFormat:@"%@元/平米",_estateBuildingMo.price],_estateBuildingMo.priceDetail,_estateBuildingMo.acreageType, _estateBuildingMo.featureTag, _estateBuildingMo.buildingSellPoint,_estateBuildingMo.estateDescription,[NSString stringWithFormat:@"%@%@",_estateBuildingMo.greeningRatio,@"%"],    [NSString stringWithFormat:@"%@%@",_estateBuildingMo.volumeRatio,@""],_estateBuildingMo.parkingProportion,_estateBuildingMo.parkingSeat,_estateBuildingMo.roomNumber,_estateBuildingMo.landArea,_estateBuildingMo.builtUpArea,_estateBuildingMo.decorationType];
//
//
//    }else{
//    
//        titleArr2 = @[ @"均价",@"面积区间",@"特色标签",@"楼盘卖点",@"楼盘简介",@"绿化率",@"容积率",@"车位占比",@"停车位",@"项目内总套数",@"占地面积",@"建筑面积",@"装修标准"];
//       titleContentent2 = @[ [NSString stringWithFormat:@"%@元/平米",_estateBuildingMo.price],_estateBuildingMo.acreageType, _estateBuildingMo.featureTag, _estateBuildingMo.buildingSellPoint,_estateBuildingMo.estateDescription,[NSString stringWithFormat:@"%@%@",_estateBuildingMo.greeningRatio,@"%"],    [NSString stringWithFormat:@"%@%@",_estateBuildingMo.volumeRatio,@""],_estateBuildingMo.parkingProportion,_estateBuildingMo.parkingSeat,_estateBuildingMo.roomNumber,_estateBuildingMo.landArea,_estateBuildingMo.builtUpArea,_estateBuildingMo.decorationType ];
//
//    }
//    
    
    titleArr2 = @[ @"均价",@"价格详情",@"面积区间",@"特色标签",@"楼盘卖点",@"楼盘简介",@"绿化率",@"容积率",@"车位占比",@"停车位",@"项目内总套数",@"占地面积",@"建筑面积",@"装修标准"];
    
    titleContentent2 = @[ [NSString stringWithFormat:@"%@元/平米",_estateBuildingMo.price],_estateBuildingMo.priceDetail,_estateBuildingMo.acreageType, _estateBuildingMo.featureTag, _estateBuildingMo.buildingSellPoint,_estateBuildingMo.estateDescription,[NSString stringWithFormat:@"%@%@",_estateBuildingMo.greeningRatio,@"%"],    [NSString stringWithFormat:@"%@%@",_estateBuildingMo.volumeRatio,@""],_estateBuildingMo.parkingProportion,_estateBuildingMo.parkingSeat,_estateBuildingMo.roomNumber,_estateBuildingMo.landArea,_estateBuildingMo.builtUpArea,_estateBuildingMo.decorationType];
    
    
    
    //筛选  空字段
    NSMutableArray *secondAllKeyValeArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i< titleArr2.count; i++) {
        
        NSString *titleContentString = titleContentent2[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if (titleContentString.length>0) {
            
            [dic setValue:titleContentent2[i] forKey:titleArr2[i]];
            
            [secondAllKeyValeArray appendObject:dic];
        }
        
    }
    
    NSArray *titleArr1 = @[@"楼盘名称",@"开盘日期",@"交房日期",@"产权年限",@"开发商",@"预售许可证"];
    NSArray *titleContentent1 = @[_estateBuildingMo.name,_estateBuildingMo.openDiscTime,_estateBuildingMo.soughtTime,_estateBuildingMo.propertyRightDeadline,_estateBuildingMo.developerName,_estateBuildingMo.license];
    
    
    NSArray *titleArr3 = @[@"物业公司",@"物业费用",@"物业类型"];
    NSArray *titleContentent3 = @[ _estateBuildingMo.propertyCompanyName,_estateBuildingMo.propertyFee,_estateBuildingMo.propertyType];


    UILabel *buildingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 80, kMainScreenWidth-16-16, 20)] ;
    buildingTitleLabel.text = @"楼盘详情";
    buildingTitleLabel.textAlignment = NSTextAlignmentLeft;
    buildingTitleLabel.textColor = [UIColor whiteColor];
    buildingTitleLabel.font = FONT(15.f);
    
    [self.bgScrollView addSubview:buildingTitleLabel];

    
    for (int i = 0; i < titleArr1.count; i ++)
    {
        NSInteger lastNum = i;
        
        AutoLabel *lastlabel = (AutoLabel *)[self.bgScrollView viewWithTag:8000+lastNum-1];
        
        AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(16, i==0?12+buildingTitleLabel.bottom:kFrame_YHeight(lastlabel)+12, kMainScreenWidth-16-10,20) andNewTitle:[NSString stringWithFormat:@"%@:   ",titleArr1[i]] andNewContent:titleContentent1[i]];
        autoLabel.tag = 8000+i;
    
        [self.bgScrollView addSubview:autoLabel];
        
    }
    AutoLabel *endLabel1 = (AutoLabel *)[self.bgScrollView viewWithTag:8000+titleArr1.count-1];
    
    UILabel *linelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(16, endLabel1.bottom+10, kMainScreenWidth-16, 0.5)];
    linelabel1.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:linelabel1];
    
    
    for (int i = 0; i < secondAllKeyValeArray.count; i ++)
    {
        NSInteger lastNum = i;
        NSMutableDictionary *dic = secondAllKeyValeArray[i];

        AutoLabel *lastlabel = (AutoLabel *)[self.bgScrollView viewWithTag:8100+lastNum-1];
        
        AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(16, i==0?12+linelabel1.bottom:kFrame_YHeight(lastlabel)+12, kMainScreenWidth-16-10,20) andNewTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andNewContent:dic.allValues[0]];
        autoLabel.tag = 8100+i;
        
        [self.bgScrollView addSubview:autoLabel];
        
    }
    AutoLabel *endLabel2 = (AutoLabel *)[self.bgScrollView viewWithTag:8100+secondAllKeyValeArray.count-1];
    
    
    
    
    
    UILabel *linelabel2 = [[UILabel alloc]initWithFrame:CGRectMake(16, endLabel2.bottom+10, kMainScreenWidth-16, 0.5)];
    linelabel2.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:linelabel2];


    
    
    
    for (int i = 0; i < titleArr3.count; i ++)
    {
        NSInteger lastNum = i;
        
        AutoLabel *lastlabel = (AutoLabel *)[self.bgScrollView viewWithTag:8200+lastNum-1];
        
        AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(16, i==0?12+linelabel2.bottom:kFrame_YHeight(lastlabel)+12, kMainScreenWidth-16-10,20) andNewTitle:[NSString stringWithFormat:@"%@:   ",titleArr3[i]] andNewContent:titleContentent3[i]];
        autoLabel.tag = 8200+i;
        
        [self.bgScrollView addSubview:autoLabel];
        
    }
    AutoLabel *endLabel3 = (AutoLabel *)[self.bgScrollView viewWithTag:8200+titleArr3.count-1];
    
    [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, endLabel3.bottom+50)];
    
}

-(void)loadCommissionRule  //佣金规则
{
    
    AutoLabel *autoLabel = [[AutoLabel alloc]initVerticalWithFrame:CGRectMake(10, 80, kMainScreenWidth-16-10, 20) andNewTitle:@"佣金规则" andNewContent:_estateBuildingMo.commissionStandard];
    
    [self addSubview:autoLabel];
    
    
}

-(void)loadCooperationRule //// 合作规则
{
    
    NSArray *titleArr = @[@"带看规则",@"成交标准",@"客户保护期",@"报备有效时间",@"合作截至日期"];
    
    
    NSString * protectorString ;
    
    if ([_estateBuildingMo.customerProtectTerm isEqualToString:@"1"]) {
        
        protectorString = [NSString stringWithFormat:@"带看开始%@天",_estateBuildingMo.effectiveType];

//        if ([_estateBuildingMo.lookoverRule isEqualToString:@"0"]) {
//            
//            protectorString = [NSString stringWithFormat:@"首次带看开始%@天",_estateBuildingMo.effectiveType];
//            
//        }else{
//            protectorString = [NSString stringWithFormat:@"最后一次带看开始%@天",_estateBuildingMo.effectiveType];
//        }
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
        
        recordEffectiveTimeString = [NSString stringWithFormat:@"报备成功%f时之内有效，从报备成功开始，超过期限没有带看，经纪人可重新报备",_estateBuildingMo.recordEffectiveTime];
    }
    
    NSArray *titleContentArr = @[_estateBuildingMo.customerVisteRule,_estateBuildingMo.dealStandar,protectorString,recordEffectiveTimeString,_estateBuildingMo.proxyEndTime];

    
    for (int i = 0; i < titleArr.count; i ++)
    {
        NSInteger lastNum = i;
        
        AutoLabel *lastlabel = (AutoLabel *)[self.bgScrollView viewWithTag:8300+lastNum-1];
        
        AutoLabel *autoLabel = [[AutoLabel alloc]initVerticalWithFrame:CGRectMake(10, i==0?80:kFrame_YHeight(lastlabel)+40, kMainScreenWidth-16-10,20) andNewTitle:[NSString stringWithFormat:@"%@",titleArr[i]] andNewContent:titleContentArr[i]];
        autoLabel.tag = 8300+i;
        
        [self.bgScrollView addSubview:autoLabel];
        
    }
    AutoLabel *endLabel = (AutoLabel *)[self.bgScrollView viewWithTag:8300+titleArr.count-1];
    
    [self.bgScrollView setContentSize:CGSizeMake(kMainScreenWidth, endLabel.bottom+50)];

    
}


-(void)dismissView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(0, 0, 0, 0)];
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
    
}







-(void)EditNullValue
{
    
    
    
    
    
//    NSArray *titleContentent1 = @[_estateBuildingMo.name,_estateBuildingMo.openDiscTime,_estateBuildingMo.soughtTime,_estateBuildingMo.developerName,_estateBuildingMo.license];
//    
//    NSArray *titleContentent2 = @[ [NSString stringWithFormat:@"%@元/平米",_estateBuildingMo.price],_estateBuildingMo.acreageType, _estateBuildingMo.featureTag, [NSString stringWithFormat:@"%@%@",_estateBuildingMo.greeningRatio,@"%"],    [NSString stringWithFormat:@"%@%@",_estateBuildingMo.volumeRatio,@""],_estateBuildingMo.parkingProportion,_estateBuildingMo.parkingSeat,_estateBuildingMo.roomNumber,_estateBuildingMo.landArea,_estateBuildingMo.builtUpArea,_estateBuildingMo.decorationType,_estateBuildingMo.propertyRightDeadline ];
//    NSArray *titleContentent3 = @[ _estateBuildingMo.propertyCompanyName,_estateBuildingMo.propertyFee,_estateBuildingMo.propertyType];
//
//    NSArray *titleContentArr = @[_estateBuildingMo.customerVisteRule,_estateBuildingMo.dealStandar,_estateBuildingMo.customerProtectTerm,_estateBuildingMo.proxyEndTime];
//
//
    
//    if ([self isBlankString:_estateBuildingMo.recordEffectiveTime])
//    {
//        _estateBuildingMo.recordEffectiveTime = EMPTYSTRING;
//    }
    
    if ([self isBlankString:_estateBuildingMo.estateDescription])
    {
        _estateBuildingMo.estateDescription = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.priceDetail])
    {
        _estateBuildingMo.priceDetail = EMPTYSTRING;
    }
   
    if ([self isBlankString:_estateBuildingMo.buildingSellPoint])
    {
        _estateBuildingMo.buildingSellPoint = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.effectiveType])
    {
        _estateBuildingMo.effectiveType = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.name])
    {
        _estateBuildingMo.name = EMPTYSTRING;
    }
    if ([self isBlankString:_estateBuildingMo.openDiscTime])
    {
        _estateBuildingMo.openDiscTime = EMPTYSTRING;
    }
    if ([self isBlankString:_estateBuildingMo.soughtTime])
    {
        _estateBuildingMo.soughtTime = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.developerName])
    {
        _estateBuildingMo.developerName = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.license])
    {
       _estateBuildingMo.license = EMPTYSTRING;
    }
    
    
    
    if ([self isBlankString:_estateBuildingMo.price])
    {
        _estateBuildingMo.price = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.acreageType])
    {
        _estateBuildingMo.acreageType = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.featureTag])
    {
        _estateBuildingMo.featureTag = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.greeningRatio])
    {
        _estateBuildingMo.greeningRatio = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.volumeRatio])
    {
        _estateBuildingMo.volumeRatio = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.parkingProportion])
    {
        _estateBuildingMo.parkingProportion = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.parkingSeat])
    {
        _estateBuildingMo.parkingSeat = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.roomNumber])
    {
        _estateBuildingMo.roomNumber = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.landArea])
    {
        _estateBuildingMo.landArea = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.builtUpArea])
    {
        _estateBuildingMo.builtUpArea = EMPTYSTRING;
    }
    
    
    
    if ([self isBlankString:_estateBuildingMo.decorationType])
    {
        _estateBuildingMo.decorationType = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.propertyRightDeadline])
    {
        _estateBuildingMo.propertyRightDeadline = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.propertyCompanyName])
    {
        _estateBuildingMo.propertyCompanyName = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.propertyFee])
    {
        _estateBuildingMo.propertyFee = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.propertyType])
    {
       _estateBuildingMo.propertyType = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.customerVisteRule])
    {
        _estateBuildingMo.customerVisteRule = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.dealStandar])
    {
        _estateBuildingMo.dealStandar = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.customerProtectTerm])
    {
        _estateBuildingMo.customerProtectTerm = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateBuildingMo.proxyEndTime])
    {
        _estateBuildingMo.proxyEndTime = EMPTYSTRING;
    }
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





@end

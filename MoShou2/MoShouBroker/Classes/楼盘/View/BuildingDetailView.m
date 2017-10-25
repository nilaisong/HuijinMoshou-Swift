//
//  BuildingDetailView.m
//  MoShou2
//
//  Created by Mac on 2016/12/14.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BuildingDetailView.h"
#import "AutoLabel.h"
#import "DataFactory+User.h"
@implementation BuildingDetailView
{
    Building *_buildingMo;
    Estate * _estateMo;
    BuildingDetailViewStyle _buildingDetailViewStyle;
    BOOL _openStyle;
    UIView * baseView;
    UIButton *_moreBtn;
}
-(id)initWithFrame:(CGRect)frame WithBuildingDetailViewStyle:(BuildingDetailViewStyle)buildingDetailViewStyle AndBuildingMo:(Building *)buildingMo AndOpenStyle:(BOOL)openStyle;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _buildingMo = buildingMo;
        _estateMo = _buildingMo.estate;
        _buildingDetailViewStyle = buildingDetailViewStyle;
        _openStyle = openStyle;
        [self EditNullValue];
        [self loadUI];
    }
    
    return self;
    
}
-(void)loadUI
{
    BOOL isHasspeciaContent = false;
    
    NSArray *allspeciaArray =[NSArray arrayWithObjects:_estateMo.buildingSellPoint,_estateMo.estateDescription,_estateMo.mainCustomer,_estateMo.buyHouseDemand,_estateMo.buyHouseBudget,_estateMo.customerGenera,_estateMo.customerWorkArea,_estateMo.customerLiveArea,_estateMo.expandSkills, nil];
  
    for (NSString *string in allspeciaArray) {
        if (string.length>0) {
            isHasspeciaContent = YES;
            break;
        }else{
            isHasspeciaContent = NO;
        }
    }


    if (isHasspeciaContent) {
        
        for (NSInteger i  = 0 ; i < 2; i ++) {
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*(kMainScreenWidth/2), 0, kMainScreenWidth/2, 44)];
            [button setTitle:i==0?@"楼盘特色":@"楼盘详情" forState:UIControlStateNormal];
            [button setTitleColor:BLUEBTBCOLOR forState:UIControlStateSelected];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
            button.tag = i+3000;
            
            if (_buildingDetailViewStyle == BuildingSpeciaStyle) {
                if (i==0) {button.selected = YES;}
                if (i==1) {button.selected = NO;}
            }else{
                if (i==0) {button.selected = NO;}
                if (i==1) {button.selected = YES;}
            }
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(kMainScreenWidth/2), button.height, kMainScreenWidth/2, 1)];
            
            if (_buildingDetailViewStyle == BuildingSpeciaStyle) {
                if (i==0) {lineLabel.backgroundColor = BLUEBTBCOLOR;};
                if (i==1) {lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);};
            }else{
                if (i==0) {lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);}
                if (i==1) {lineLabel.backgroundColor = BLUEBTBCOLOR;}
            }
            lineLabel.tag = i+4000;
            [self addSubview:lineLabel];
        }

        [self loadbaseView];
        
    }else{
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
        [button setTitle:@"楼盘详情" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [self addSubview:button];

        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, button.height, kMainScreenWidth, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        [self addSubview:lineLabel];

        _buildingDetailViewStyle = BuildingDetailStyle;
        
        [self loadbaseView];

    }
    

    
}

-(void)loadbaseView
{
    
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kMainScreenWidth, 0)];
    [self addSubview:baseView];
    
    baseView.clipsToBounds = YES;
    
    //特色View
    if (_buildingDetailViewStyle == BuildingSpeciaStyle) {
        
        UIView *buildingSpeciaView = [self creatBuildingSpeciaView];
        
        [baseView addSubview:buildingSpeciaView];
        baseView.height = buildingSpeciaView.bottom;
        
    }else if (_buildingDetailViewStyle == BuildingDetailStyle){  //详情
        UIView *buildingDetailView = [self creatBuildingDetailView];
        baseView.height = buildingDetailView.bottom;
        [baseView addSubview:buildingDetailView];
    }
    
    self.height = baseView.bottom+15;

//    [self addMoreBtn];
    
    
}

//-(void)addMoreBtn
//{
//    
//    UIView *moreBtnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, baseView.bottom+15, kMainScreenWidth, 30)];
//    moreBtnBgView.backgroundColor = [UIColor whiteColor];
//    
//    [self addSubview:moreBtnBgView];
//    
//    _moreBtn =  [self creatMoreBtnWithFrame:CGRectMake((kMainScreenWidth-170/2)/2, baseView.bottom+10, 170/2, 45/2)];
//    [self addSubview:_moreBtn];
//    
//    self.height = moreBtnBgView.bottom;
//
//    
//}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 3000) { //特色
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LPTS" andPageId:@"PAGE_LPXQ"];

        [MobClick event:@"lpxq_lpts"];
        UIButton *lastButton = (UIButton *)[self viewWithTag:3001];
        lastButton.selected = NO;
        UILabel *clickLabel = (UILabel *)[self viewWithTag:4000];
        UILabel *lastLabel = (UILabel *)[self viewWithTag:4001];
        btn.selected = YES;
        clickLabel.backgroundColor = BLUEBTBCOLOR;
        lastLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        _buildingDetailViewStyle = BuildingSpeciaStyle;
        
        [baseView removeAllSubviews];
        
        
        UIView *buildingSpeciaView = [self creatBuildingSpeciaView];
        
        [baseView addSubview:buildingSpeciaView];
        baseView.height = buildingSpeciaView.bottom;
    }else if (btn.tag == 3001){ //详情
        
        [MobClick event:@"lpxq_lpxx"];
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_LPXQ " andPageId:@"PAGE_LPXQ"];

        UIButton *lastButton = (UIButton *)[self viewWithTag:3000];
        lastButton.selected = NO;
        UILabel *clickLabel = (UILabel *)[self viewWithTag:4001];
        UILabel *lastLabel = (UILabel *)[self viewWithTag:4000];
        btn.selected = YES;
        clickLabel.backgroundColor = BLUEBTBCOLOR;
        lastLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        _buildingDetailViewStyle = BuildingDetailStyle;
        
        [baseView removeAllSubviews];
        
        UIView *buildingDetailView = [self creatBuildingDetailView];
        baseView.height = buildingDetailView.bottom;
        [baseView addSubview:buildingDetailView];
    }
//    [self addMoreBtn];

    DLog(@"self.height===  %f",self.height);
    
    self.height = baseView.bottom+15;

    self.buildingDetailViewStyleChangeBlock(self.height,_openStyle,_buildingDetailViewStyle);
    
    
    
}

-(UIView *)creatBuildingSpeciaView
{
#warning debug message
//    _estateMo.buildingSellPoint = @"全是卖点";
//    _estateMo.estateDescription = @"花漾紫郡hkhfskhfsdhkjhskhdklashulykkjxchkjzxhkhklzjkljkaslukzjvxkjhzkvjlhzkjxhkjlhzkhusadyukhjlzxkjcbzvnmx,bnbzx,bjhkaskhhasjklhkjahsjkhsahdjahkjdhajkshdakjhkjdshakjdhalkjhdakjhha69-115㎡，高性价比，全功能户型。双地铁楼盘，30分钟直达新街口，交通非常便捷。项目自带2万方沿街商业、10万方社区配套；享有香槟广场、南大商业街、莱福城、桥北商圈、泰山路商圈等一站式服务，全方位满足吃喝玩乐购的需求。另外项目也是南京地产*款青年定制爆款，以工匠*精神运用互联生活端网聚业主的生活圈，夜光跑道、宠物乐园、户外会客厅、组团景观WIFI覆盖等，除了其超低总价，这些都是吸引年轻刚需客群的重要因素。另外项目周边还规划有幼儿园、小学及中学，为业主解决了孩子上学难的问题。";
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    //卖点简介
    UIView *sellPointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    [view addSubview:sellPointView];

    if (_estateMo.buildingSellPoint.length>0 || _estateMo.estateDescription.length>0) {
        UILabel * sellPointLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 14) text:@"卖点简介" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x1ac38f)];
        [sellPointView addSubview:sellPointLabel];
        
        AutoLabel *sellAutoLabel;
        if (_estateMo.buildingSellPoint.length>0) {
        
             sellAutoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, sellPointLabel.bottom+5, kMainScreenWidth-20, 0) andTitle:@"楼盘卖点:  " andContent:_estateMo.buildingSellPoint];
            [sellPointView addSubview:sellAutoLabel];
            sellPointView.height = sellAutoLabel.bottom+15;
        }
        if (_estateMo.estateDescription.length>0) {
          
            AutoLabel *estateDescriptionAutoLabl = [[AutoLabel alloc]initWithFrame:CGRectMake(10, _estateMo.buildingSellPoint.length>0?sellAutoLabel.bottom+5:sellPointLabel.bottom+5, kMainScreenWidth-20, 0) andTitle:@"楼盘简介:  " andContent:_estateMo.estateDescription];
            [sellPointView addSubview:estateDescriptionAutoLabl];
            sellPointView.height = estateDescriptionAutoLabl.bottom+15;
        }
        view.height = sellPointView.bottom+15;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, sellPointView.height-1, kMainScreenWidth-10, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        lineLabel.tag = 7000;
        [sellPointView addSubview:lineLabel];
    }
    //目标客户
    CGFloat targetCustomerViewTop = sellPointView.height>0?sellPointView.bottom :0;
    UIView *targetCustomerView = [[UIView alloc]initWithFrame:CGRectMake(0,targetCustomerViewTop , kMainScreenWidth, 0)];
    [view addSubview:targetCustomerView];

    NSArray *titleArr = @[@"客户年龄",@"购房目的",@"购房预算",@"客群属性",@"工作区域",@"居住区域"];
    NSArray *contentArray =[NSArray arrayWithObjects:_estateMo.mainCustomer,_estateMo.buyHouseDemand,_estateMo.buyHouseBudget,_estateMo.customerGenera,_estateMo.customerWorkArea,_estateMo.customerLiveArea, nil];
    //筛选  空字段
    NSMutableArray *targetCustomerAllKeyValeArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i< titleArr.count; i++) {
        NSString *titleContentString = contentArray[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (titleContentString.length>0) {
            [dic setValue:contentArray[i] forKey:titleArr[i]];
            [targetCustomerAllKeyValeArray appendObject:dic];
        }
    }
        if (targetCustomerAllKeyValeArray.count>0) {
            
            UILabel * customerLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 14) text:@"目标客户" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x1ac38f)];
            [targetCustomerView addSubview:customerLabel];
            
            for (int i = 0; i < targetCustomerAllKeyValeArray.count; i ++)
            {
                NSInteger lastNum = i;
                NSMutableDictionary *dic = targetCustomerAllKeyValeArray[i];
                AutoLabel *lastlabel = (AutoLabel *)[targetCustomerView viewWithTag:8100+lastNum-1];
                
                AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?10+customerLabel.bottom:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 0) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
                autoLabel.tag = 8100+i;
                
                [targetCustomerView addSubview:autoLabel];
                
            }
            AutoLabel *endLabel2 = (AutoLabel *)[targetCustomerView viewWithTag:8100+targetCustomerAllKeyValeArray.count-1];

            targetCustomerView.height = endLabel2.bottom+15;
            view.height = targetCustomerView.bottom;

            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, targetCustomerView.height-1, kMainScreenWidth-10, 1)];
            lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
            lineLabel.tag = 8000;
            [targetCustomerView addSubview:lineLabel];
            
        }else{
            UILabel *lastLabel = (UILabel*)[sellPointView viewWithTag:7000];
            lastLabel.hidden = YES;

        }
    
    //Talk skills  拓客技巧
    
    CGFloat talkSkillsViewTop = targetCustomerView.height>0?targetCustomerView.bottom:(sellPointView.height>0?sellPointView.bottom:0);

    UIView * talkSkillsView = [[UIView alloc]initWithFrame:CGRectMake(0, talkSkillsViewTop, kMainScreenWidth, 0)];
    [view addSubview:talkSkillsView];
    
    if (_estateMo.expandSkills.length>0) {
        
        UILabel * talkSkillsLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 14) text:@"拓客技巧" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x1ac38f)];
        [talkSkillsView addSubview:talkSkillsLabel];

        AutoLabel *talkSkillAutolabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, talkSkillsLabel.bottom+5, kMainScreenWidth-20, 20) andTitle:nil andContent:_estateMo.expandSkills];
        
        [talkSkillsView addSubview:talkSkillAutolabel];
        
        talkSkillsView.height = talkSkillAutolabel.bottom;
        view.height = talkSkillsView.bottom;
        
    }else{
        UILabel *lastLabel = (UILabel*)[targetCustomerView viewWithTag:8000];
        lastLabel.hidden = YES;
    }
    
    if (!_openStyle) {
        
        if (view.height>200) {
            view.height = 200;
        }
    }
    
    return view;
    
}

-(UIView *)creatBuildingDetailView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];

    NSArray *titleArr1 = @[@"楼盘名称",@"别名",@"均价",@"价格详情",@"面积区间",@"物业类型",@"装修标准",@"特色标签"];
    NSArray *contentArray1 = [NSArray arrayWithObjects:_estateMo.name,_estateMo.alias,_estateMo.price,_estateMo.priceDetail,_estateMo.acreageType,_estateMo.propertyType,_estateMo.decorationType,_estateMo.featureTag, nil];

    NSArray *titleArr2 = @[@"开盘时间",@"交房时间",@"产权年限",@"开发商",@"预售许可证",@"物业费",@"物业公司"];
    NSArray *contentArray2 = [NSArray arrayWithObjects:_estateMo.openDiscTime,_estateMo.soughtTime,_estateMo.propertyRightDeadline,_estateMo.developerName,_estateMo.license,_estateMo.propertyFee,_estateMo.propertyCompanyName, nil];
    
    NSArray *titleArr3 = @[@"项目内总套数",@"可售房源",@"建筑面积",@"占地面积",@"容积率",@"绿化率",@"停车位",@"车位占比"];
    NSArray *contentArray3 = [NSArray arrayWithObjects:_estateMo.roomNumber,_estateMo.saleRoomNumber,_estateMo.builtUpArea,_estateMo.landArea,_estateMo.volumeRatio,_estateMo.greeningRatio,_estateMo.parkingSeat,_estateMo.parkingProportion, nil];
    
    NSMutableArray *buildingDetailAllKeyValeArray1 = [NSMutableArray array];
    NSMutableArray *buildingDetailAllKeyValeArray2 = [NSMutableArray array];
    NSMutableArray *buildingDetailAllKeyValeArray3 = [NSMutableArray array];
    
    for (NSInteger i = 0; i< titleArr1.count; i++) {
        NSString *titleContentString = contentArray1[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (titleContentString.length>0) {
            [dic setValue:contentArray1[i] forKey:titleArr1[i]];
            [buildingDetailAllKeyValeArray1 appendObject:dic];
        }
    }

    for (NSInteger i = 0; i< titleArr2.count; i++) {
        NSString *titleContentString = contentArray2[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (titleContentString.length>0) {
            [dic setValue:contentArray2[i] forKey:titleArr2[i]];
            [buildingDetailAllKeyValeArray2 appendObject:dic];
        }
    }

    for (NSInteger i = 0; i< titleArr3.count; i++) {
        NSString *titleContentString = contentArray3[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (titleContentString.length>0) {
            [dic setValue:contentArray3[i] forKey:titleArr3[i]];
            [buildingDetailAllKeyValeArray3 appendObject:dic];
        }
    }

    UIView *baseView1;
    if (buildingDetailAllKeyValeArray1.count>0) {
        baseView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
        [view addSubview:baseView1];
        
        for (int i = 0; i < buildingDetailAllKeyValeArray1.count; i ++)
        {
            NSInteger lastNum = i;
            NSMutableDictionary *dic = buildingDetailAllKeyValeArray1[i];
            AutoLabel *lastlabel = (AutoLabel *)[baseView1 viewWithTag:9100+lastNum-1];
            
            AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?15:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 20) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
            autoLabel.tag = 9100+i;
            
            [baseView1 addSubview:autoLabel];
            
        }
        AutoLabel *endLabel1 = (AutoLabel *)[baseView1 viewWithTag:9100+buildingDetailAllKeyValeArray1.count-1];
        
        baseView1.height = endLabel1.bottom+15;
        view.height = baseView1.bottom;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, baseView1.height-1, kMainScreenWidth-10, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        [baseView1 addSubview:lineLabel];
        
    }
    

    UIView *baseView2;
    if (buildingDetailAllKeyValeArray2.count>0) {
        baseView2 = [[UIView alloc]initWithFrame:CGRectMake(0, baseView1.height>0?baseView1.bottom:baseView1.top, kMainScreenWidth, 0)];
        [view addSubview:baseView2];
        
        for (int i = 0; i < buildingDetailAllKeyValeArray2.count; i ++)
        {
            NSInteger lastNum = i;
            NSMutableDictionary *dic = buildingDetailAllKeyValeArray2[i];
            AutoLabel *lastlabel = (AutoLabel *)[baseView2 viewWithTag:9200+lastNum-1];
            AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?15:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 20) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
            autoLabel.tag = 9200+i;
            [baseView2 addSubview:autoLabel];
            
        }
        AutoLabel *endLabel2 = (AutoLabel *)[baseView2 viewWithTag:9200+buildingDetailAllKeyValeArray2.count-1];
        baseView2.height = endLabel2.bottom+15;
        view.height = baseView2.bottom;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, baseView2.height-1, kMainScreenWidth-10, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        [baseView2 addSubview:lineLabel];
        
    }
    

    
    UIView *baseView3;
    if (buildingDetailAllKeyValeArray3.count>0) {
        baseView3 = [[UIView alloc]initWithFrame:CGRectMake(0, baseView2.height>0?baseView2.bottom:baseView2.top, kMainScreenWidth, 0)];
        [view addSubview:baseView3];
        
        for (int i = 0; i < buildingDetailAllKeyValeArray3.count; i ++)
        {
            NSInteger lastNum = i;
            NSMutableDictionary *dic = buildingDetailAllKeyValeArray3[i];
            AutoLabel *lastlabel = (AutoLabel *)[baseView3 viewWithTag:9300+lastNum-1];
            AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?15:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 20) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
            autoLabel.tag = 9300+i;
            [baseView3 addSubview:autoLabel];
            
        }
        AutoLabel *endLabel3 = (AutoLabel *)[baseView3 viewWithTag:9300+buildingDetailAllKeyValeArray3.count-1];
        baseView3.height = endLabel3.bottom;
        view.height = baseView3.bottom;
    }
   /* 楼盘名称
    别名
    均价
    面积区间
    物业类型
    装修标准
    特色标签
    -----------
    开盘时间
    交房时间
    产权年限
    开发商
    预售许可证
    物业费
    物业公司
    ------------
    项目内总套数
    可售房源
    建筑面积
    占地面积
    容积率
    绿化率
    停车位
    车位占比
    */
    
    if (!_openStyle) {
        
        if (view.height>200) {
            view.height = 200;
        }
    }
    return view;
}

//-(UIButton *)creatMoreBtnWithFrame:(CGRect)frame
//{
//    UIButton *moreBtn= [[UIButton alloc]initWithFrame:frame];
//    moreBtn.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
//    moreBtn.layer.borderWidth = 0.5;
//    moreBtn.layer.cornerRadius = 4;
//    moreBtn.layer.masksToBounds = YES;
//    moreBtn.selected = _openStyle;
//    [moreBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
//    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
//    [moreBtn setTitle:@"收起" forState:UIControlStateSelected];
//    [moreBtn setImage:[UIImage imageNamed:@"筛选三角"] forState:UIControlStateNormal];
//    [moreBtn setImage:[UIImage imageNamed:@"筛选三角up"] forState:UIControlStateSelected];
//    moreBtn.titleLabel.font = FONT(13.f);
//    [moreBtn addTarget:self action:@selector(moreViewBtnClik:) forControlEvents:UIControlEventTouchUpInside];
//    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
//    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
//    return moreBtn;
//}
//
//-(void)moreViewBtnClik:(UIButton *)btn
//{
//    btn.selected = !btn.selected;
//    _openStyle = btn.selected;
//    [self loadbaseView];
//    self.buildingDetailViewStyleChangeBlock(self.height,_openStyle,_buildingDetailViewStyle);
//}
-(void)EditNullValue
{
    
    if ([self isBlankString:_estateMo.saleRoomNumber])
    {
        _estateMo.saleRoomNumber = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.name])
    {
        _estateMo.name = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.alias])
    {
        _estateMo.alias = EMPTYSTRING;
    }
        if ([self isBlankString:_estateMo.priceDetail])
    {
        _estateMo.priceDetail = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.acreageType])
    {
        _estateMo.acreageType = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.propertyType])
    {
        _estateMo.propertyType = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.decorationType])
    {
        _estateMo.decorationType = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.featureTag])
    {
        _estateMo.featureTag = EMPTYSTRING;
    }
    //--------------------11111---------------------------
    
    
    if ([self isBlankString:_estateMo.openDiscTime])
    {
        _estateMo.openDiscTime = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.soughtTime])
    {
        _estateMo.soughtTime = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.propertyRightDeadline])
    {
        _estateMo.propertyRightDeadline = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.developerName])
    {
        _estateMo.developerName = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.license])
    {
        _estateMo.license = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.propertyFee])
    {
        _estateMo.propertyFee = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.propertyCompanyName])
    {
        _estateMo.propertyCompanyName = EMPTYSTRING;
    }
    //-------------------2222---------------------------

    if ([self isBlankString:_estateMo.roomNumber])
    {
        _estateMo.roomNumber = EMPTYSTRING;
    }

    if ([self isBlankString:_buildingMo.onsellHouseCount])
    {
        _buildingMo.onsellHouseCount = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.builtUpArea])
    {
        _estateMo.builtUpArea = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.landArea])
    {
        _estateMo.landArea = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.volumeRatio])
    {
        _estateMo.volumeRatio = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.greeningRatio])
    {
        _estateMo.greeningRatio = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.parkingSeat])
    {
        _estateMo.parkingSeat = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.parkingProportion])
    {
        _estateMo.parkingProportion = EMPTYSTRING;
    }

    //-----------------3333----------------------------

    if ([self isBlankString:_estateMo.mainCustomer])
    {
        _estateMo.mainCustomer = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.buyHouseDemand])
    {
        _estateMo.buyHouseDemand = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.buyHouseBudget])
    {
        _estateMo.buyHouseBudget = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.customerGenera])
    {
        _estateMo.customerGenera = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.customerWorkArea])
    {
        _estateMo.customerWorkArea = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.customerLiveArea])
    {
        _estateMo.customerLiveArea = EMPTYSTRING;
    }
    if ([self isBlankString:_estateMo.buyHouseDemand])
  
    //-----------------4444----------------------------

    
//    
//    if ([self isBlankString:_estateMo.recordEffectiveTime])
//    {
//        _estateMo.recordEffectiveTime = EMPTYSTRING;
//    }
    
    if ([self isBlankString:_estateMo.estateDescription])
    {
        _estateMo.estateDescription = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.buildingSellPoint])
    {
        _estateMo.buildingSellPoint = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.effectiveType])
    {
        _estateMo.effectiveType = EMPTYSTRING;
    }    
    if ([self isBlankString:_estateMo.price])
    {
        _estateMo.price = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.customerVisteRule])
    {
        _estateMo.customerVisteRule = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.dealStandar])
    {
        _estateMo.dealStandar = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.customerProtectTerm])
    {
        _estateMo.customerProtectTerm = EMPTYSTRING;
    }
    
    if ([self isBlankString:_estateMo.proxyEndTime])
    {
        _estateMo.proxyEndTime = EMPTYSTRING;
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



+(CGFloat)buildingDetailHeightWith:(Building *)buildingMo;
{
    
    Estate * _estateMo;
    Building *_buildingMo;
    _buildingMo = buildingMo;
    _estateMo = buildingMo.estate;
    
    [BuildingDetailView EditNullValueWithBuiling:buildingMo];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    //卖点简介
    UIView *sellPointView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    [view addSubview:sellPointView];
    
    if (_estateMo.buildingSellPoint.length>0 || _estateMo.estateDescription.length>0) {
        UILabel * sellPointLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 14) text:@"卖点简介" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x1ac38f)];
        [sellPointView addSubview:sellPointLabel];
        
        AutoLabel *sellAutoLabel;
        if (_estateMo.buildingSellPoint.length>0) {
            
            sellAutoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, sellPointLabel.bottom+5, kMainScreenWidth-20, 0) andTitle:@"楼盘卖点:  " andContent:_estateMo.buildingSellPoint];
            [sellPointView addSubview:sellAutoLabel];
            sellPointView.height = sellAutoLabel.bottom+15;
        }
        if (_estateMo.estateDescription.length>0) {
            
            AutoLabel *estateDescriptionAutoLabl = [[AutoLabel alloc]initWithFrame:CGRectMake(10, _estateMo.buildingSellPoint.length>0?sellAutoLabel.bottom+5:sellPointLabel.bottom+5, kMainScreenWidth-20, 0) andTitle:@"楼盘简介:  " andContent:_estateMo.estateDescription];
            [sellPointView addSubview:estateDescriptionAutoLabl];
            sellPointView.height = estateDescriptionAutoLabl.bottom+15;
        }
        view.height = sellPointView.bottom+15;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, sellPointView.height-1, kMainScreenWidth-10, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        [sellPointView addSubview:lineLabel];
    }
    //目标客户
    CGFloat targetCustomerViewTop = sellPointView.height>0?sellPointView.bottom :0;
    UIView *targetCustomerView = [[UIView alloc]initWithFrame:CGRectMake(0,targetCustomerViewTop , kMainScreenWidth, 0)];
    [view addSubview:targetCustomerView];
    
    NSArray *titleArr = @[@"客户年龄",@"购房目的",@"购房预算",@"客群属性",@"工作区域",@"居住区域"];
    NSArray *contentArray = [NSArray arrayWithObjects:_estateMo.mainCustomer,_estateMo.buyHouseDemand,_estateMo.buyHouseBudget,_estateMo.customerGenera,_estateMo.customerWorkArea,_estateMo.customerLiveArea, nil];
    //筛选  空字段
    NSMutableArray *targetCustomerAllKeyValeArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i< titleArr.count; i++) {
        NSString *titleContentString = contentArray[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        if (titleContentString.length>0) {
            [dic setValue:contentArray[i] forKey:titleArr[i]];
            [targetCustomerAllKeyValeArray appendObject:dic];
        }
    }
    if (targetCustomerAllKeyValeArray.count>0) {
        
        UILabel * customerLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 14) text:@"目标客户" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x1ac38f)];
        [targetCustomerView addSubview:customerLabel];
        
        for (int i = 0; i < targetCustomerAllKeyValeArray.count; i ++)
        {
            NSInteger lastNum = i;
            NSMutableDictionary *dic = targetCustomerAllKeyValeArray[i];
            AutoLabel *lastlabel = (AutoLabel *)[targetCustomerView viewWithTag:8100+lastNum-1];
            
            AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?10+customerLabel.bottom:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 0) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
            autoLabel.tag = 8100+i;
            
            [targetCustomerView addSubview:autoLabel];
            
        }
        AutoLabel *endLabel2 = (AutoLabel *)[targetCustomerView viewWithTag:8100+targetCustomerAllKeyValeArray.count-1];
        
        targetCustomerView.height = endLabel2.bottom+15;
        view.height = targetCustomerView.bottom;
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, targetCustomerView.height-1, kMainScreenWidth-10, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
        lineLabel.tag = 8000;
        [targetCustomerView addSubview:lineLabel];
        
    }
    //Talk skills  拓客技巧
    
    CGFloat talkSkillsViewTop = targetCustomerView.height>0?targetCustomerView.bottom:(sellPointView.height>0?sellPointView.bottom:0);
    
    UIView * talkSkillsView = [[UIView alloc]initWithFrame:CGRectMake(0, talkSkillsViewTop, kMainScreenWidth, 0)];
    [view addSubview:talkSkillsView];
    
    if (_estateMo.expandSkills.length>0) {
        
        UILabel * talkSkillsLabel = [UILabel createLabelWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, 14) text:@"拓客技巧" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x1ac38f)];
        [talkSkillsView addSubview:talkSkillsLabel];
        
        AutoLabel *talkSkillAutolabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, talkSkillsLabel.bottom+5, kMainScreenWidth-20, 20) andTitle:nil andContent:_estateMo.expandSkills];
        
        [talkSkillsView addSubview:talkSkillAutolabel];
        
        talkSkillsView.height = talkSkillAutolabel.bottom;
        view.height = talkSkillsView.bottom;
        
    }

    
    
    if (view.height>0) {
        
        return view.height+44+10+6;
 
    }else{
        
    /// 返回详情的高度
//        需要重新计算
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
        
        NSArray *titleArr1 = @[@"楼盘名称",@"别名",@"均价",@"价格详情",@"面积区间",@"物业类型",@"装修标准",@"特色标签"];
        NSArray *contentArray1 =[NSArray arrayWithObjects:_estateMo.name,_estateMo.alias,_estateMo.price,_estateMo.priceDetail,_estateMo.acreageType,_estateMo.propertyType,_estateMo.decorationType,_estateMo.featureTag, nil];
        
        NSArray *titleArr2 = @[@"开盘时间",@"交房时间",@"产权年限",@"开发商",@"预售许可证",@"物业费",@"物业公司"];
        NSArray *contentArray2 =[NSArray arrayWithObjects:_estateMo.openDiscTime,_estateMo.soughtTime,_estateMo.propertyRightDeadline,_estateMo.developerName,_estateMo.license,_estateMo.propertyFee,_estateMo.propertyCompanyName, nil];
        
        NSArray *titleArr3 = @[@"项目内总套数",@"可售房源",@"建筑面积",@"占地面积",@"容积率",@"绿化率",@"停车位",@"车位占比"];
        NSArray *contentArray3 =[NSArray arrayWithObjects:_estateMo.roomNumber,_estateMo.saleRoomNumber,_estateMo.builtUpArea,_estateMo.landArea,_estateMo.volumeRatio,_estateMo.greeningRatio,_estateMo.parkingSeat,_estateMo.parkingProportion, nil];
  
       
        NSMutableArray *buildingDetailAllKeyValeArray1 = [NSMutableArray array];
        NSMutableArray *buildingDetailAllKeyValeArray2 = [NSMutableArray array];
        NSMutableArray *buildingDetailAllKeyValeArray3 = [NSMutableArray array];
        
        for (NSInteger i = 0; i< titleArr1.count; i++) {
            NSString *titleContentString = contentArray1[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (titleContentString.length>0) {
                [dic setValue:contentArray1[i] forKey:titleArr1[i]];
                [buildingDetailAllKeyValeArray1 appendObject:dic];
            }
        }
        
        for (NSInteger i = 0; i< titleArr2.count; i++) {
            NSString *titleContentString = contentArray2[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (titleContentString.length>0) {
                [dic setValue:contentArray2[i] forKey:titleArr2[i]];
                [buildingDetailAllKeyValeArray2 appendObject:dic];
            }
        }
        
        for (NSInteger i = 0; i< titleArr3.count; i++) {
            NSString *titleContentString = contentArray3[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (titleContentString.length>0) {
                [dic setValue:contentArray3[i] forKey:titleArr3[i]];
                [buildingDetailAllKeyValeArray3 appendObject:dic];
            }
        }
        
        UIView *baseView1;
        if (buildingDetailAllKeyValeArray1.count>0) {
            baseView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
            [view addSubview:baseView1];
            
            for (int i = 0; i < buildingDetailAllKeyValeArray1.count; i ++)
            {
                NSInteger lastNum = i;
                NSMutableDictionary *dic = buildingDetailAllKeyValeArray1[i];
                AutoLabel *lastlabel = (AutoLabel *)[baseView1 viewWithTag:9100+lastNum-1];
                
                AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?15:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 20) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
                autoLabel.tag = 9100+i;
                
                [baseView1 addSubview:autoLabel];
                
            }
            AutoLabel *endLabel1 = (AutoLabel *)[baseView1 viewWithTag:9100+buildingDetailAllKeyValeArray1.count-1];
            
            baseView1.height = endLabel1.bottom+15;
            view.height = baseView1.bottom;
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, baseView1.height-1, kMainScreenWidth-10, 1)];
            lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
            [baseView1 addSubview:lineLabel];
            
        }
        
        
        UIView *baseView2;
        if (buildingDetailAllKeyValeArray2.count>0) {
            baseView2 = [[UIView alloc]initWithFrame:CGRectMake(0, baseView1.height>0?baseView1.bottom:baseView1.top, kMainScreenWidth, 0)];
            [view addSubview:baseView2];
            
            for (int i = 0; i < buildingDetailAllKeyValeArray2.count; i ++)
            {
                NSInteger lastNum = i;
                NSMutableDictionary *dic = buildingDetailAllKeyValeArray2[i];
                AutoLabel *lastlabel = (AutoLabel *)[baseView2 viewWithTag:9200+lastNum-1];
                AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?15:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 20) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
                autoLabel.tag = 9200+i;
                [baseView2 addSubview:autoLabel];
                
            }
            AutoLabel *endLabel2 = (AutoLabel *)[baseView2 viewWithTag:9200+buildingDetailAllKeyValeArray2.count-1];
            baseView2.height = endLabel2.bottom+15;
            view.height = baseView2.bottom;
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, baseView2.height-1, kMainScreenWidth-10, 1)];
            lineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
            [baseView2 addSubview:lineLabel];
            
        }
        
        
        
        UIView *baseView3;
        if (buildingDetailAllKeyValeArray3.count>0) {
            baseView3 = [[UIView alloc]initWithFrame:CGRectMake(0, baseView2.height>0?baseView2.bottom:baseView2.top, kMainScreenWidth, 0)];
            [view addSubview:baseView3];
            
            for (int i = 0; i < buildingDetailAllKeyValeArray3.count; i ++)
            {
                NSInteger lastNum = i;
                NSMutableDictionary *dic = buildingDetailAllKeyValeArray3[i];
                AutoLabel *lastlabel = (AutoLabel *)[baseView3 viewWithTag:9300+lastNum-1];
                AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10, i==0?15:kFrame_YHeight(lastlabel)+5, kMainScreenWidth-10-10, 20) andTitle:[NSString stringWithFormat:@"%@:   ",dic.allKeys[0]] andContent:dic.allValues[0]];
                autoLabel.tag = 9300+i;
                [baseView3 addSubview:autoLabel];
                
            }
            AutoLabel *endLabel3 = (AutoLabel *)[baseView3 viewWithTag:9300+buildingDetailAllKeyValeArray3.count-1];
            baseView3.height = endLabel3.bottom;
            view.height = baseView3.bottom;
        }
        
    
        
        return view.height+44+10+10;

        
    }
    
    
    

    
    
}

+(void)EditNullValueWithBuiling:(Building *)buildingMo;
{
    Estate * _estateMo;
    Building *_buildingMo;
    _buildingMo = buildingMo;
    _estateMo = buildingMo.estate;
    if ([BuildingDetailView isBlankString:_estateMo.saleRoomNumber])
    {
        _estateMo.saleRoomNumber = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.name])
    {
        _estateMo.name = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.alias])
    {
        _estateMo.alias = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.priceDetail])
    {
        _estateMo.priceDetail = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.acreageType])
    {
        _estateMo.acreageType = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.propertyType])
    {
        _estateMo.propertyType = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.decorationType])
    {
        _estateMo.decorationType = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.featureTag])
    {
        _estateMo.featureTag = EMPTYSTRING;
    }
    //--------------------11111---------------------------
    
    
    if ([BuildingDetailView isBlankString:_estateMo.openDiscTime])
    {
        _estateMo.openDiscTime = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.soughtTime])
    {
        _estateMo.soughtTime = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.propertyRightDeadline])
    {
        _estateMo.propertyRightDeadline = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.developerName])
    {
        _estateMo.developerName = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.license])
    {
        _estateMo.license = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.propertyFee])
    {
        _estateMo.propertyFee = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.propertyCompanyName])
    {
        _estateMo.propertyCompanyName = EMPTYSTRING;
    }
    //-------------------2222---------------------------
    
    if ([BuildingDetailView isBlankString:_estateMo.roomNumber])
    {
        _estateMo.roomNumber = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_buildingMo.onsellHouseCount])
    {
        _buildingMo.onsellHouseCount = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.builtUpArea])
    {
        _estateMo.builtUpArea = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.landArea])
    {
        _estateMo.landArea = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.volumeRatio])
    {
        _estateMo.volumeRatio = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.greeningRatio])
    {
        _estateMo.greeningRatio = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.parkingSeat])
    {
        _estateMo.parkingSeat = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.parkingProportion])
    {
        _estateMo.parkingProportion = EMPTYSTRING;
    }
    
    //-----------------3333----------------------------
    
    if ([BuildingDetailView isBlankString:_estateMo.mainCustomer])
    {
        _estateMo.mainCustomer = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.buyHouseDemand])
    {
        _estateMo.buyHouseDemand = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.buyHouseBudget])
    {
        _estateMo.buyHouseBudget = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.customerGenera])
    {
        _estateMo.customerGenera = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.customerWorkArea])
    {
        _estateMo.customerWorkArea = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.customerLiveArea])
    {
        _estateMo.customerLiveArea = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.buyHouseDemand])
        
        //-----------------4444----------------------------
        
        
        
//        if ([BuildingDetailView isBlankString:_estateMo.recordEffectiveTime])
//        {
//            _estateMo.recordEffectiveTime = EMPTYSTRING;
//        }
    
    if ([BuildingDetailView isBlankString:_estateMo.estateDescription])
    {
        _estateMo.estateDescription = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.buildingSellPoint])
    {
        _estateMo.buildingSellPoint = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.effectiveType])
    {
        _estateMo.effectiveType = EMPTYSTRING;
    }
    if ([BuildingDetailView isBlankString:_estateMo.price])
    {
        _estateMo.price = EMPTYSTRING;
    }
    
    
    if ([BuildingDetailView isBlankString:_estateMo.customerVisteRule])
    {
        _estateMo.customerVisteRule = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.dealStandar])
    {
        _estateMo.dealStandar = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.customerProtectTerm])
    {
        _estateMo.customerProtectTerm = EMPTYSTRING;
    }
    
    if ([BuildingDetailView isBlankString:_estateMo.proxyEndTime])
    {
        _estateMo.proxyEndTime = EMPTYSTRING;
    }
    
   

}
+ (BOOL) isBlankString:(NSString*)string
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

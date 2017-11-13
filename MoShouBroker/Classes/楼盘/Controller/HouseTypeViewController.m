//
//  HouseTypeViewController.m
//  MoShouBroker
//
//  Created by strongcoder on 15/7/16.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "HouseTypeViewController.h"
//#import "BuildingBigImageView.h"
#import "ShowBigImageViewController.h"
#import "AutoLabel.h"
#import "UILabel+StringFrame.h"
#import "BuildingImageView.h"
#import "MortgageCalculatorViewController.h"
#import "Estate.h"
#import "SpecialHouse.h"
#import "DataFactory+User.h"
@interface HouseTypeViewController ()<UIScrollViewDelegate>
{
    BuildingImageView*_houseImageView ;
    UIScrollView *_scrollView;
//    UILabel *_numberLabel;
    RoomLayout *_roomMo;
    SpecialHouse *_houseMo;
    UIPageControl *_page;
    Estate * _estateBuildingMo;
//    UILabel *_nameLabel;
}

@end

@implementation HouseTypeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _estateBuildingMo = self.building.estate;
    self.navigationBar.titleLabel.text = _building.name;//@"户型详情";
    if (_vcType == kSpecialPriceBuilding) {
        self.navigationBar.titleLabel.text = @"特价房";
        
        
    }else if(_vcType == kAllBuilding){
        
        [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_HXXQ" andPageId:@"PAGE_LPXQ"];
    }
    
    [self loadScrollView];
    [self loadUI];
    
//    [self loadPageNumber];
//    [self addNavItem];
   // [self loadPageControl];
    
    DLog(@"%zd",_building.roomLayoutArray.count);
    
    DLog(@"curruntIndex====%zd",self.currentIndex);
    
}

-(void)adjustFrameForHotSpotChange
{
    [super adjustFrameForHotSpotChange];
    if (_scrollView.superview) {
        _scrollView.frame =CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -64);
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height -64);
    }
}


-(void)addNavItem
{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(kMainScreenWidth-44, 20, 44, 44);
    [button setImage:[UIImage imageNamed:@"icon-qian-touch.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon-qian-touch.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(fangDaiClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationBar addSubview:button];
}

-(void)fangDaiClick:(UIButton *)sender
{
    MortgageCalculatorViewController *VC = [[MortgageCalculatorViewController alloc]init];
    if (_vcType == kSpecialPriceBuilding) {
        SpecialHouse * houseMo = _building.specialHouseList[_currentIndex];
        VC.area = houseMo.saleArea;
        VC.housePrise = houseMo.cheapSinglePrice;
    }else{
        RoomLayout * roomMo = _building.roomLayoutArray[_currentIndex];
        VC.area =roomMo.saleArea;
        VC.housePrise =_estateBuildingMo.price;
    }
    [self.navigationController pushViewController:VC animated:YES];
}

//-(void)loadPageNumber
//{
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewTopY+kMainScreenWidth*(49.0/75)-35, kMainScreenWidth, 35)];
//    bgView.alpha = 0.5;
//    bgView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:bgView];
//    
//    RoomLayout *layout = (RoomLayout*)[_building.roomLayoutArray objectForIndex:_currentIndex];
//    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgView.width-80, bgView.height)];
//    _nameLabel.textColor = [UIColor whiteColor];
//    _nameLabel.backgroundColor = [UIColor clearColor];
//    _nameLabel.text = layout.name;
//    _nameLabel.font = FONT(16);
//    [bgView addSubview:_nameLabel];
//    
//    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth-70, _nameLabel.top, 60, bgView.height)];//
//    _numberLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex+1,self.building.roomLayoutArray.count];
//    _numberLabel.backgroundColor = [UIColor clearColor];
//    _numberLabel.textColor = [UIColor whiteColor];
//    _numberLabel.font = FONT(14.f);
//    _numberLabel.textAlignment = NSTextAlignmentRight;
//
//    [bgView addSubview:_numberLabel];
//    
//    if (_vcType == kSpecialPriceBuilding) {
//        SpecialHouse *house = (SpecialHouse*)[_building.specialHouseList objectForIndex:_currentIndex];
//        _nameLabel.text = house.houseTypeName;
//        _numberLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex+1,self.building.specialHouseList.count];
//    }
//}
-(void)loadPageControl
{
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, (64+kMainScreenWidth*0.75)-30, kMainScreenWidth, 30)];
    _page.numberOfPages = self.building.roomLayoutArray.count;
    _page.currentPage = _currentIndex;
    _page.currentPageIndicatorTintColor = [UIColor grayColor];
    _page.pageIndicatorTintColor = [UIColor blackColor];
    
    if (_vcType == kSpecialPriceBuilding) {
        _page.numberOfPages = self.building.specialHouseList.count;
    }
    [self.view addSubview:_page];
}

-(void)loadScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, self.view.bounds.size.height -64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
//    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kMainScreenWidth*_building.roomLayoutArray.count, self.view.bounds.size.height -64);
    if (_vcType == kSpecialPriceBuilding) {
        _scrollView.contentSize = CGSizeMake(kMainScreenWidth*_building.specialHouseList.count, self.view.bounds.size.height -64);
    }
    _scrollView.contentOffset = CGPointMake( kMainScreenWidth*_currentIndex, 0);
    [self.view addSubview:_scrollView];
}

-(void)loadUI
{
    if (_vcType == kSpecialPriceBuilding) {
        for (NSInteger i = 0; i <_building.specialHouseList.count; i ++)
        {
            _houseMo = _building.specialHouseList[i];
            _houseImageView = [[BuildingImageView alloc]initWithFrame:CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth*0.75) andBuildingId:_building.buildingId];
            
            [_houseImageView setImageWithUrlString:_houseMo.pathImgUrl placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            DLog(@"roomMo.imgUrl===%@",_roomMo.imgUrl);
            _houseImageView.userInteractionEnabled = YES;
            _houseImageView.contentMode = UIViewContentModeScaleAspectFill;
            _houseImageView.clipsToBounds = YES;
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _houseImageView.height - 35, kMainScreenWidth, 35)];
            bgView.alpha = 0.5;
            bgView.backgroundColor = [UIColor blackColor];
            [_houseImageView addSubview:bgView];

            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgView.width-80, bgView.height)];
            namelabel.textColor = [UIColor whiteColor];
            namelabel.backgroundColor = [UIColor clearColor];
            namelabel.text = _houseMo.houseTypeName;
            namelabel.font = FONT(16);
            [bgView addSubview:namelabel];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigIamge:)];
            [_houseImageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:_houseImageView];
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(i*kMainScreenWidth, kFrame_YHeight(_houseImageView), kMainScreenWidth, kMainScreenHeight-kFrame_YHeight(_houseImageView))];
            
            [_scrollView addSubview:contentView];
            [self EditNullValue];
            
            UILabel *titleLabel =[[UILabel alloc]init];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.numberOfLines = 0;
            titleLabel.font = [UIFont systemFontOfSize:16.f];
            titleLabel.textColor = UIColorFromRGB(0x3a3a3a);
            titleLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫%@厨",_houseMo.bedroomNum,_houseMo.livingroomNum,_houseMo.toiletNum,_houseMo.kitchenNum];
            CGSize size = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT(16)}];//[titleLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-40, 0)];
            titleLabel.frame  = CGRectMake(10, kMainScreenWidth>320?20:10, size.width, size.height);
            [contentView addSubview:titleLabel];
            
            UIButton *calculatorBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.right+15, titleLabel.top, titleLabel.height-2, titleLabel.height)];
            [calculatorBtn setImage:[UIImage imageNamed:@"calculator"] forState:UIControlStateNormal];
            [calculatorBtn addTarget:self action:@selector(fangDaiClick:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:calculatorBtn];
            
            NSString *str = [NSString stringWithFormat:@"[%@]",_houseMo.saleStatus.length>0?_houseMo.saleStatus:@"其他"];
            CGSize saleSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            UILabel *saleStatusL = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width-10-saleSize.width, calculatorBtn.top, saleSize.width, saleSize.height)];
            saleStatusL.backgroundColor = [UIColor clearColor];
            saleStatusL.font = [UIFont boldSystemFontOfSize:16];
            saleStatusL.text = str;
            if (_houseMo.saleStatus.length>0) {
                if ([_houseMo.saleStatus isEqualToString:@"可售"]) {
                    saleStatusL.textColor = UIColorFromRGB(0x00d319);
                }else if ([_houseMo.saleStatus isEqualToString:@"预售"]){
                    saleStatusL.textColor = UIColorFromRGB(0xff9900);
                }else if ([_houseMo.saleStatus isEqualToString:@"已售"]){
                    saleStatusL.textColor = UIColorFromRGB(0xff3a2f);
                }else{
                    saleStatusL.textColor = UIColorFromRGB(0x1fbdf7);
                }
            }else
            {
                saleStatusL.hidden = YES;
            }
            
            [contentView addSubview:saleStatusL];
            
            
            AutoLabel *youHuiDanJialabel = [[AutoLabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+(kMainScreenWidth>320?20:10), (kMainScreenWidth-20)/2, 14) andTitle:@"优惠单价:  " andContent: [NSString stringWithFormat:@"%@", _houseMo.cheapSinglePrice]];
            youHuiDanJialabel.titleLabel.textColor = UIColorFromRGB(0x333333);
            youHuiDanJialabel.contentLabel.textColor =ORIGCOLOR;
            [contentView addSubview:youHuiDanJialabel];
            
            UILabel *yuanDanJiaLabel = [UILabel createDeleteLabelWithFrame:CGRectMake(kMainScreenWidth/2, youHuiDanJialabel.top, (kMainScreenWidth-20)/2, 13) text:[NSString stringWithFormat:@"原单价:  %@", _houseMo.unitPrice] textAlignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x888888) fontSize:13.f];
            [contentView addSubview:yuanDanJiaLabel];
            
            
            
            AutoLabel *youHuiZongJiaLable = [[AutoLabel alloc]initWithFrame:CGRectMake(youHuiDanJialabel.left, youHuiDanJialabel.bottom+8, (kMainScreenWidth-20)/2, 13) andTitle:@"优惠总价:  " andContent:[NSString stringWithFormat:@"%@", _houseMo.cheapTotalPrice]];
            youHuiZongJiaLable.titleLabel.textColor = UIColorFromRGB(0x333333);
            youHuiZongJiaLable.contentLabel.textColor = ORIGCOLOR;
            [contentView addSubview:youHuiZongJiaLable];
            
            
            UILabel *yuanZongJiaLabel = [UILabel createDeleteLabelWithFrame:CGRectMake(kMainScreenWidth/2, youHuiZongJiaLable.top, (kMainScreenWidth-20)/2, 13) text:[NSString stringWithFormat:@"原总价:  %@",_houseMo.totalPrice] textAlignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x888888) fontSize:13.f];
            [contentView addSubview:yuanZongJiaLabel];
            
            AutoLabel *startAndEndTimeLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(youHuiZongJiaLable.left, youHuiZongJiaLable.bottom+8, kMainScreenWidth-20, 13) andTitle:@"起止时间:  " andContent:[NSString stringWithFormat:@"%@至%@",_houseMo.cheapBeginTime,_houseMo.cheapEndTime]];
            startAndEndTimeLabel.titleLabel.textColor = UIColorFromRGB(0x333333);
            startAndEndTimeLabel.contentLabel.textColor =UIColorFromRGB(0x333333);
            [contentView addSubview:startAndEndTimeLabel];
            
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, startAndEndTimeLabel.bottom+(kMainScreenWidth>320?15:5), kMainScreenWidth-10, 0.5)];
            lineV.backgroundColor = VIEWBGCOLOR;
            [contentView addSubview:lineV];
            
            NSMutableArray *titleArr = [[NSMutableArray alloc] init];
            NSMutableArray *titleContent = [[NSMutableArray alloc] init];
            if (![self isBlankString:_houseMo.saleArea]) {
                [titleArr appendObject:@"销售面积"];
                [titleContent appendObject:_houseMo.saleArea];
            }
            if (![self isBlankString:_houseMo.insideArea]) {
                [titleArr appendObject:@"套内面积"];
                [titleContent appendObject:_houseMo.insideArea];
            }
            if (![self isBlankString:_houseMo.shareArea]) {
                [titleArr appendObject:@"分摊面积"];
                [titleContent appendObject:_houseMo.shareArea];
            }else
            {
                [titleArr appendObject:@"分摊面积"];
                [titleContent appendObject:@"无"];
            }
            if (![self isBlankString:_houseMo.giftArea]) {
                [titleArr appendObject:@"赠送面积"];
                [titleContent appendObject:_houseMo.giftArea];
            }else
            {
                [titleArr appendObject:@"赠送面积"];
                [titleContent appendObject:@"无"];
            }
            if (![self isBlankString:_houseMo.decoration]) {
                [titleArr appendObject:@"装修"];
                [titleContent appendObject:_houseMo.decoration];
            }
            if (![self isBlankString:_houseMo.orientation]) {
                [titleArr appendObject:@"朝向"];
                [titleContent appendObject:_houseMo.orientation];
            }
            CGFloat width = 0;
            BOOL bHasThree = NO;
            for (int j=0; j<titleArr.count; j++) {
                CGSize labelSize = [[NSString stringWithFormat:@"%@: %@",titleArr[j],titleContent[j]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                if (width<labelSize.width) {
                    width = labelSize.width;
                }
                if (j > 0 && j%2 != 0) {
                    if (width*3+10<=contentView.width-20) {
                        bHasThree = YES;
                    }
                }
            }
            
            for (int j = 0; j < titleArr.count; j ++)
            {
                CGSize labelSize = [[titleArr objectForIndex:j] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10+(bHasThree?j%3*((contentView.width-30)/3+5):j%2*((contentView.width-25)/2+5)), lineV.bottom+(bHasThree?15+j/3*(labelSize.height+8):5+j/2*(labelSize.height+8)), bHasThree?j%3*(contentView.width-30)/3:j%2*(contentView.width-25)/2,labelSize.height) andTitle:[NSString stringWithFormat:@"%@: ",titleArr[j]] andContent:titleContent[j]];
                autoLabel.tag = 9800+j;
                autoLabel.titleLabel.textColor = NAVIGATIONTITLE;
                [contentView addSubview:autoLabel];
            }
            AutoLabel *endLabel = (AutoLabel *)[contentView viewWithTag:9800+titleContent.count-1];
            
            _scrollView.contentSize =CGSizeMake(kMainScreenWidth*_building.specialHouseList.count, kFrame_YHeight(endLabel)+kFrame_YHeight(_houseImageView));
            
            DLog(@"kFrame_YHeight(endLabel)+kFrame_YHeight(contentView)======%f",kFrame_YHeight(endLabel));
            
            contentView.frame = CGRectMake(i*kMainScreenWidth, kFrame_YHeight(_houseImageView), kMainScreenWidth, kFrame_YHeight(endLabel) );
            
            //add by wangzz 161216
            CGSize blSize = [@"左右滑动查看其它户型" sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
            UILabel *bottomL = [[UILabel alloc] initWithFrame:CGRectMake(i*kMainScreenWidth, _scrollView.height-15-blSize.height, kMainScreenWidth, blSize.height)];
            bottomL.backgroundColor = [UIColor clearColor];
            bottomL.textColor = [UIColor colorWithHexString:@"999999"];
            bottomL.font = FONT(13);
            bottomL.textAlignment = NSTextAlignmentCenter;
            bottomL.text = @"左右滑动查看其它户型";
            [_scrollView addSubview:bottomL];
            
            if (_building.specialHouseList.count <= 1) {
                bottomL.hidden = YES;
            }
            //end
        }
    }else if (_vcType == kAllBuilding)
    {
        for (NSInteger i = 0; i <_building.roomLayoutArray.count; i ++)
        {
            
            _roomMo = _building.roomLayoutArray[i];
            
            _houseImageView = [[BuildingImageView alloc]initWithFrame:CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenWidth*0.75) andBuildingId:_building.buildingId];
            _houseImageView.contentMode = UIViewContentModeScaleAspectFill;
            _houseImageView.clipsToBounds = YES;
            
            [_houseImageView setImageWithUrlString:_roomMo.imgUrl placeholderImage:[UIImage imageNamed:@"默认图片.png"]];
            _houseImageView.userInteractionEnabled = YES;
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, _houseImageView.height - 35, kMainScreenWidth, 35)];
            bgView.alpha = 0.5;
            bgView.backgroundColor = [UIColor blackColor];
            [_houseImageView addSubview:bgView];
            
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgView.width-80, bgView.height)];
            namelabel.textColor = [UIColor whiteColor];
            namelabel.backgroundColor = [UIColor clearColor];
            namelabel.text = _roomMo.name;
            namelabel.font = FONT(16);
            [bgView addSubview:namelabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigIamge:)];
            [_houseImageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:_houseImageView];
            
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(i*kMainScreenWidth, kFrame_YHeight(_houseImageView), kMainScreenWidth, kMainScreenHeight-kFrame_YHeight(_houseImageView))];
            
            [_scrollView addSubview:contentView];
            [self EditNullValue];

            UILabel *titleLabel =[[UILabel alloc]init];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.numberOfLines = 0;
            titleLabel.font = [UIFont systemFontOfSize:16.f];
            titleLabel.textColor = UIColorFromRGB(0x3a3a3a);
    //        titleLabel.text = [NSString stringWithFormat:@"%@   %@",_roomMo.name,_roomMo.type];
            titleLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫%@厨",_roomMo.bedroomNum,_roomMo.livingroomNum,_roomMo.toiletNum,_roomMo.kitchenNum];//[NSString stringWithFormat:@"%@   %@",[NSString stringWithFormat:@"%@",_roomMo.name.length==0?@"":[NSString stringWithFormat:@"%@",_roomMo.name]],[NSString stringWithFormat:@"%@",_roomMo.type.length==0?@"":[NSString stringWithFormat:@"%@",_roomMo.type]]];
            CGSize size = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT(16)}];//[titleLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth-40, 0)];
            titleLabel.frame  = CGRectMake(10, kMainScreenWidth>320?20:10, size.width, size.height);
            [contentView addSubview:titleLabel];
            
            CGSize priceSize = [[NSString stringWithFormat:@"%@",_roomMo.totalPrice] sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+11, titleLabel.top, priceSize.width, priceSize.height)];
            priceL.textColor = ORIGCOLOR;
            priceL.font = [UIFont boldSystemFontOfSize:16];
            priceL.text = [NSString stringWithFormat:@"%@",_roomMo.totalPrice];
            priceL.backgroundColor = [UIColor clearColor];
            [contentView addSubview:priceL];
            
            UIButton *calculatorBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceL.right+15, titleLabel.top, titleLabel.height-2, titleLabel.height)];
            [calculatorBtn setImage:[UIImage imageNamed:@"calculator"] forState:UIControlStateNormal];
            [calculatorBtn addTarget:self action:@selector(fangDaiClick:) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:calculatorBtn];
            
            UILabel *promptLabel = [UILabel createLabelWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+10, kMainScreenWidth, 10) text:@"实际价格以售楼处为准" textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:[UIColor colorWithHexString:@"999999"]];
            
            [contentView addSubview:promptLabel];
            
            
            NSString *str = [NSString stringWithFormat:@"[%@]",_roomMo.status.length>0?_roomMo.status:@"其他"];
            CGSize saleSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            UILabel *saleStatusL = [[UILabel alloc] initWithFrame:CGRectMake(contentView.width-10-saleSize.width, calculatorBtn.top, saleSize.width, saleSize.height)];
            saleStatusL.backgroundColor = [UIColor clearColor];
            saleStatusL.font = [UIFont boldSystemFontOfSize:16];
            saleStatusL.text = str;
            if (_roomMo.status.length>0) {
                if ([_roomMo.status isEqualToString:@"可售"]) {
                    saleStatusL.textColor = UIColorFromRGB(0x00d319);
                }else if ([_roomMo.status isEqualToString:@"预售"]){
                    saleStatusL.textColor = UIColorFromRGB(0xff9900);
                }else if ([_roomMo.status isEqualToString:@"已售"]){
                    saleStatusL.textColor = UIColorFromRGB(0xff3a2f);
                }else{
                    saleStatusL.textColor = UIColorFromRGB(0x1fbdf7);
                }
            }else
            {
                saleStatusL.hidden = YES;
            }
            [contentView addSubview:saleStatusL];
            
        
            NSMutableArray *titleArr = [[NSMutableArray alloc] init];
            
            NSMutableArray *titleContent = [[NSMutableArray alloc] init];
            if (![self isBlankString:_roomMo.saleArea]) {
                [titleArr appendObject:@"销售面积"];
                [titleContent appendObject:_roomMo.saleArea];
            }
            if (![self isBlankString:_roomMo.innerArea]) {
                [titleArr appendObject:@"套内面积"];
                [titleContent appendObject:_roomMo.innerArea];
            }
            if (![self isBlankString:_roomMo.shareArea]) {
                [titleArr appendObject:@"分摊面积"];
                [titleContent appendObject:_roomMo.shareArea];
            }else
            {
                [titleArr appendObject:@"分摊面积"];
                [titleContent appendObject:@"无"];
            }
            if (![self isBlankString:_roomMo.presentArea]) {
                [titleArr appendObject:@"赠送面积"];
                [titleContent appendObject:_roomMo.presentArea];
            }else
            {
                [titleArr appendObject:@"赠送面积"];
                [titleContent appendObject:@"无"];
            }
            if (![self isBlankString:_roomMo.decoration]) {
                [titleArr appendObject:@"装修"];
                [titleContent appendObject:_roomMo.decoration];
            }
            if (![self isBlankString:_roomMo.towardsType]) {
                [titleArr appendObject:@"朝向"];
                [titleContent appendObject:_roomMo.towardsType];
            }
            CGFloat width = 0;
            BOOL bHasThree = NO;
            for (int j=0; j<titleArr.count; j++) {
                CGSize labelSize = [[NSString stringWithFormat:@"%@: %@",titleArr[j],titleContent[j]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                if (width<labelSize.width) {
                    width = labelSize.width;
                }
                if (j > 0 && j%2 != 0) {
                    if (width*3+10<=contentView.width-20) {
                        bHasThree = YES;
                    }
                }
            }
            for (int j = 0; j < titleArr.count; j ++)
            {
//                NSInteger lastNum = i;
//                AutoLabel *lastlabel = (AutoLabel *)[contentView viewWithTag:9800+lastNum-1];
                CGSize labelSize = [[titleArr objectForIndex:j] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//                if (iPhone4)
//                {
                    AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(10+(bHasThree?j%3*((contentView.width-30)/3+5):j%2*((contentView.width-20)/2)+5), 15+titleLabel.bottom+(bHasThree?20+j/3*(labelSize.height+8):10+j/2*(labelSize.height+8)), bHasThree?j%3*(contentView.width-30)/3:j%2*(contentView.width-25)/2,labelSize.height) andTitle:[NSString stringWithFormat:@"%@: ",titleArr[j]] andContent:titleContent[j]];
                    autoLabel.tag = 9800+j;
                autoLabel.titleLabel.textColor = NAVIGATIONTITLE;
                    [contentView addSubview:autoLabel];
//                }else
//                {
//                AutoLabel *autoLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(20, i==0?12+kFrame_YHeight(titleLabel):kFrame_YHeight(lastlabel)+12, kMainScreenWidth-18-10,20) andTitle:[NSString stringWithFormat:@"%@: ",titleArr[i]] andContent:titleContent[i]];
//                    autoLabel.tag = 9800+i;
//                    [contentView addSubview:autoLabel];
//                }
               
            }
            AutoLabel *endLabel = (AutoLabel *)[contentView viewWithTag:9800+titleContent.count-1];
            
            _scrollView.contentSize =CGSizeMake(kMainScreenWidth*_building.roomLayoutArray.count, kFrame_YHeight(endLabel)+kFrame_YHeight(_houseImageView));
            
            DLog(@"kFrame_YHeight(endLabel)+kFrame_YHeight(contentView)======%f",kFrame_YHeight(endLabel));
            
            contentView.frame = CGRectMake(i*kMainScreenWidth, kFrame_YHeight(_houseImageView), kMainScreenWidth, kFrame_YHeight(endLabel) );
            
            //add by wangzz 161216
            CGSize blSize = [@"左右滑动查看其它户型" sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
            UILabel *bottomL = [[UILabel alloc] initWithFrame:CGRectMake(i*kMainScreenWidth, _scrollView.height-15-blSize.height, kMainScreenWidth, blSize.height)];
            bottomL.backgroundColor = [UIColor clearColor];
            bottomL.textColor = [UIColor colorWithHexString:@"999999"];
            bottomL.font = FONT(13);
            bottomL.textAlignment = NSTextAlignmentCenter;
            bottomL.text = @"左右滑动查看其它户型";
            [_scrollView addSubview:bottomL];
            //end
            if (_building.roomLayoutArray.count <= 1) {
                bottomL.hidden = YES;
            }
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
//    这个方法在Uisrollview有位移的时候调用，用来输出偏移量测试
    NSLog(@"contentOffset.x====%f",scrollView.contentOffset.x);
    NSLog(@"contentOffset.y====%f",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.x < -60)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger numerPage = scrollView.contentOffset.x /kMainScreenWidth;
    _currentIndex = numerPage;
    _page.currentPage = numerPage;
//    _numberLabel.text =[NSString stringWithFormat:@"%zd/%zd",numerPage+1,self.building.roomLayoutArray.count];
//    RoomLayout *layout = (RoomLayout*)[_building.roomLayoutArray objectForIndex:_currentIndex];
//    _nameLabel.text = layout.name;
//    if (_vcType == kSpecialPriceBuilding) {
//        _numberLabel.text =[NSString stringWithFormat:@"%zd/%zd",numerPage+1,self.building.specialHouseList.count];
//        SpecialHouse *layout = (SpecialHouse*)[_building.specialHouseList objectForIndex:_currentIndex];
//        _nameLabel.text = layout.houseTypeName;
//    }
}

-(void)showBigIamge:(UITapGestureRecognizer *)tap
{
    ShowBigImageViewController *VC = [[ShowBigImageViewController alloc]init];
    
    UIImage *image;
    
    if (_vcType == kSpecialPriceBuilding) {
        
        SpecialHouse *houseMo = self.building.specialHouseList[_currentIndex];
        
        image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:houseMo.pathImgUrl]]];
    }else if (_vcType == kAllBuilding){
        
        RoomLayout *roomMo = self.building.roomLayoutArray[_currentIndex];
        image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:roomMo.imgUrl]]];
    }
    if (image) {
        
        VC.bigImage = image;
        
    }else{
        VC.bigImage = [UIImage imageNamed:@"默认图片.png"];
    }
    [self presentViewController:VC animated:NO completion:nil];
//    ShowBigImageViewController *VC = [[ShowBigImageViewController alloc]init];
//    
//    RoomLayout *roomMo = self.building.roomLayoutArray[_currentIndex];
//    
//    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:roomMo.imgUrl]]];
//    
//    if (_vcType == kSpecialPriceBuilding) {
//        SpecialHouse *houseMo = self.building.specialHouseList[_currentIndex];
//        
//        image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:houseMo.pathImgUrl]]];
//    }
//    
//    if (image) {
//      
//        VC.bigImage = image;
//        
//    }else{
//        VC.bigImage = [UIImage imageNamed:@"默认图片.png"];
//        
//    }
//
//    
//    [self presentViewController:VC animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)EditNullValue
{
    if ([self isBlankString:_roomMo.saleArea]) {
        _roomMo.saleArea = @"";
    }
    
    if ([self isBlankString:_roomMo.innerArea]) {
        _roomMo.innerArea = @"";
    }
    
    if ([self isBlankString:_roomMo.shareArea]) {
        _roomMo.shareArea = @"";
    }
    
    if ([self isBlankString:_roomMo.presentArea]) {
        _roomMo.presentArea = @"";
    }
    
    
    if ([self isBlankString:_roomMo.decoration]) {
        _roomMo.decoration = @"";
    }
    
    if ([self isBlankString:_roomMo.towardsType]) {
        _roomMo.towardsType = @"";
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

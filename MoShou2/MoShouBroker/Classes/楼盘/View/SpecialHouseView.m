//
//  SpecialHouseView.m
//  MoShou2
//
//  Created by Mac on 2016/12/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "AutoLabel.h"
#import "SpecialHouseView.h"
#import "SpecialHouse.h"
#import "HouseTypeViewController.h"
#import "DataFactory+User.h"

//默认366/2
#define NOMALHEIGHT 366/2

@implementation SpecialHouseView
{
    
    NSArray *_array;
    
    UIView *_baseView;
    UIButton *_moreViewBtn;
    
    BOOL _openStyle;
    
}
-(id)initWithFrame:(CGRect)frame WithSpeciaHouseArray:(NSArray *)array AndOpenStyle:(BOOL)openStyle
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
       
        _array = array;
        _openStyle = openStyle;
        [self loadUI];
    }
    
    return self;

}

-(void)loadUI
{
    SpecialHouse *houseModel = _array[0];
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 116/2, 45/2)];
//    imageView.image = [UIImage imageNamed:@"特价房"];
//    [self addSubview:imageView];
    
    UILabel *specialLabel = [[UILabel alloc]init];
    specialLabel.textColor = [UIColor whiteColor];
    specialLabel.backgroundColor = UIColorFromRGB(0xFF6969);
    specialLabel.font = FONT(14.f);
    if (_array.count>1) {
        specialLabel.text = [NSString stringWithFormat:@"特价房(%zd)",_array.count];
    }else{specialLabel.text = @"特价房";}
    specialLabel.textAlignment = NSTextAlignmentCenter;
    CGSize size = [specialLabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 0)];
    specialLabel.frame = CGRectMake(10, 0, size.width+20, 45/2);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:specialLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = specialLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    specialLabel.layer.mask = maskLayer;
    
    [self addSubview:specialLabel];
    
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, specialLabel.bottom+15, kMainScreenWidth, 0)];
    
    [self addSubview:_baseView];
    
    if (!_openStyle) {
        UIButton *houseView = [self creatOneSpeciaHouserNomalViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0) WithSpecialHouseModel:houseModel];
        [_baseView addSubview:houseView];
        houseView.tag = 7000;
        [houseView addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        _baseView.height = houseView.height;
        
    }else{
        
        for (NSInteger i = 0 ; i < _array.count; i ++) {
            
            SpecialHouse *houseModel = _array[i];
            
            UIButton *houseView = [self creatOneSpeciaHouserNomalViewWithFrame:CGRectMake(0, i*120, kMainScreenWidth, 0) WithSpecialHouseModel:houseModel];
            houseView.tag = 7000+i;
            [houseView addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            [_baseView addSubview:houseView];
            _baseView.height = _array.count*110;
            self.height = _baseView.height;
            }
    }
    
    if(_array.count>1){
        
        CGFloat moreViewBtnY = _openStyle?_baseView.bottom+25:_baseView.bottom+15;
        
        _moreViewBtn = [[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-170/2)/2, moreViewBtnY, 170/2, 45/2)];
        _moreViewBtn.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
        _moreViewBtn.layer.borderWidth = 0.5;
        _moreViewBtn.layer.cornerRadius = 4;
        _moreViewBtn.layer.masksToBounds = YES;
        _moreViewBtn.selected = _openStyle;
        [_moreViewBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [_moreViewBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreViewBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_moreViewBtn setImage:[UIImage imageNamed:@"筛选三角"] forState:UIControlStateNormal];
        [_moreViewBtn setImage:[UIImage imageNamed:@"筛选三角up"] forState:UIControlStateSelected];
        _moreViewBtn.titleLabel.font = FONT(13.f);
        [_moreViewBtn addTarget:self action:@selector(moreViewBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        [_moreViewBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        [_moreViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [self addSubview:_moreViewBtn];
        
        self.height = _moreViewBtn.bottom+15;
    }
   
    
    
}

-(void)bgBtnClick:(UIButton *)btn
{
    
    [MobClick event:@"lpxq_tejf"];
    
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_TJF" andPageId:@"PAGE_LPXQ"];
    
    NSInteger index = btn.tag-7000;
    
    Building *building = [[Building alloc]init];
    
    building.specialHouseList = [NSArray arrayWithArray:_array];
    
    HouseTypeViewController *VC = [[HouseTypeViewController alloc]init];
    VC.building =self.building;;
    VC.currentIndex = index;
    VC.vcType = kSpecialPriceBuilding;
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:VC animated:YES];
        
}


-(void)moreViewBtnClik:(UIButton *)btn
{
    DLog(@"........btn click");

    if (!btn.selected) {
        //初始状态  点击展开
        [_baseView removeAllSubviews];
        
        for (NSInteger i = 0 ; i < _array.count; i ++) {
            
            SpecialHouse *houseModel = _array[i];

            UIView *houseView = [self creatOneSpeciaHouserNomalViewWithFrame:CGRectMake(0, i*110, kMainScreenWidth, 0) WithSpecialHouseModel:houseModel];

            [_baseView addSubview:houseView];

            }
        _baseView.height = _array.count*110;

        
    }else{
        //点击收起
        [_baseView removeAllSubviews];
        SpecialHouse *houseModel = _array[0];

        UIView *houseView = [self creatOneSpeciaHouserNomalViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0) WithSpecialHouseModel:houseModel];
        [_baseView addSubview:houseView];

        _baseView.height = houseView.height;


        
    }
    _moreViewBtn.centerY = _baseView.height+_baseView.top+20;
    self.height = _moreViewBtn.bottom+20;
    btn.selected = !btn.selected;

    self.openAndCloseSpeciaHouseViewBlock(self.height,btn.selected);
}

-(UIButton *)creatOneSpeciaHouserNomalViewWithFrame:(CGRect)frame WithSpecialHouseModel:(SpecialHouse *)houseModel
{

    UIButton *nomalView = [[UIButton alloc]initWithFrame:frame];
    [self addSubview:nomalView];
    
    NSString *houseTypeString = [NSString stringWithFormat:@"%@室%@厅%@卫%@",houseModel.bedroomNum,houseModel.livingroomNum,houseModel.toiletNum,houseModel.saleArea];
    UILabel *houseTypelabel = [UILabel createLabelWithFrame:CGRectMake(10, 0, kMainScreenWidth/2, 13) text:houseTypeString textAlignment:NSTextAlignmentLeft fontSize:13.f textColor:UIColorFromRGB(0x333333)];
    CGSize size =  [houseTypelabel boundingRectWithSize:CGSizeMake(kMainScreenWidth/2, 13)];
    houseTypelabel.width =size.width;
    [nomalView addSubview:houseTypelabel];
    
    UILabel *sellStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(houseTypelabel.right+15, houseTypelabel.top, 100, houseTypelabel.height)];
    sellStyleLabel.text =[NSString stringWithFormat:@"[%@]",houseModel.saleStatus];
    sellStyleLabel.textAlignment = NSTextAlignmentLeft;
    sellStyleLabel.font = FONT(13.f);
    if (houseModel.saleStatus.length>0) {
        if ([houseModel.saleStatus isEqualToString:@"可售"]) {
            sellStyleLabel.textColor = UIColorFromRGB(0x00d319);
        }else if ([houseModel.saleStatus isEqualToString:@"预售"]){
            sellStyleLabel.textColor = UIColorFromRGB(0xff9900);
        }else if ([houseModel.saleStatus isEqualToString:@"已售"]){
            sellStyleLabel.textColor = UIColorFromRGB(0xff3a2f);
        }else{
            sellStyleLabel.textColor = UIColorFromRGB(0x1fbdf7);
        }
    }else{
        sellStyleLabel.hidden = YES;
    }
    
        [nomalView addSubview:sellStyleLabel];    
    AutoLabel *youHuiDanJialabel = [[AutoLabel alloc]initWithFrame:CGRectMake(houseTypelabel.left, houseTypelabel.bottom+15/2, (kMainScreenWidth-20)/2, 14) andTitle:@"优惠单价:  " andContent: [NSString stringWithFormat:@"%@", houseModel.cheapSinglePrice]];
    youHuiDanJialabel.titleLabel.textColor = UIColorFromRGB(0x333333);
    youHuiDanJialabel.contentLabel.textColor =UIColorFromRGB(0x333333);
    youHuiDanJialabel.userInteractionEnabled = NO;
    [nomalView addSubview:youHuiDanJialabel];
    
    UILabel *yuanDanJiaLabel = [UILabel createDeleteLabelWithFrame:CGRectMake(kMainScreenWidth/2, youHuiDanJialabel.top, (kMainScreenWidth-20)/2, 13) text:[NSString stringWithFormat:@"原单价: %@", [NSString stringWithFormat:@"%@", houseModel.unitPrice]] textAlignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x888888) fontSize:13.f];
    yuanDanJiaLabel.userInteractionEnabled = NO;
    [nomalView addSubview:yuanDanJiaLabel];
    
    
    AutoLabel *youHuiZongJiaLable = [[AutoLabel alloc]initWithFrame:CGRectMake(youHuiDanJialabel.left, youHuiDanJialabel.bottom+15/2, (kMainScreenWidth-20)/2, 13) andTitle:@"优惠总价:  " andContent:[NSString stringWithFormat:@"%@", houseModel.cheapTotalPrice]];
    youHuiZongJiaLable.titleLabel.textColor = UIColorFromRGB(0x333333);
    youHuiZongJiaLable.contentLabel.textColor = UIColorFromRGB(0x333333);
    youHuiZongJiaLable.userInteractionEnabled = NO;

    [nomalView addSubview:youHuiZongJiaLable];
    
    UILabel *yuanZongJiaLabel = [UILabel createDeleteLabelWithFrame:CGRectMake(kMainScreenWidth/2, youHuiZongJiaLable.top, (kMainScreenWidth-20)/2, 13) text:[NSString stringWithFormat:@"原总价: %@", [NSString stringWithFormat:@"%@", houseModel.totalPrice]] textAlignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x888888) fontSize:13.f];
    yuanZongJiaLabel.userInteractionEnabled = NO;
    [nomalView addSubview:yuanZongJiaLabel];
    
    AutoLabel *startAndEndTimeLabel = [[AutoLabel alloc]initWithFrame:CGRectMake(youHuiZongJiaLable.left, youHuiZongJiaLable.bottom+15/2, kMainScreenWidth-20, 13) andTitle:@"起止时间:  " andContent:[NSString stringWithFormat:@"%@至%@",houseModel.cheapBeginTime,houseModel.cheapEndTime]];
    startAndEndTimeLabel.userInteractionEnabled = NO;
    startAndEndTimeLabel.titleLabel.textColor = UIColorFromRGB(0x333333);
    startAndEndTimeLabel.contentLabel.textColor =UIColorFromRGB(0x333333);
    [nomalView addSubview:startAndEndTimeLabel];
    
    UIButton *checkDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(startAndEndTimeLabel.left, startAndEndTimeLabel.bottom+15/2, 55, 14)];
    [checkDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [checkDetailBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
//    [checkDetailBtn addTarget:self action:@selector(checkDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    checkDetailBtn.titleLabel.font = FONT(13.f);
    checkDetailBtn.userInteractionEnabled = NO;
    checkDetailBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [nomalView addSubview:checkDetailBtn];

    nomalView.height = checkDetailBtn.bottom+5;

    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nomalView.height-1, kMainScreenWidth-10, 1)];
    lineLabel.backgroundColor = _openStyle==YES?UIColorFromRGB(0xefeff4):[UIColor clearColor];
    [nomalView addSubview:lineLabel];
    
    return nomalView;
}


@end

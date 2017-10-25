//
//  XTTopFunctionView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTTopFunctionView.h"
#import "UserData.h"

@interface XTTopFunctionView()

@property (nonatomic,weak)XTTopFunctionButton* quickRecommendBtn;

@property (nonatomic,weak)XTTopFunctionButton* addCustomerBtn;

@property (nonatomic,weak)XTTopFunctionButton* workReportBtn;

@property (nonatomic,weak)XTTopFunctionButton* recommendRecordBtn;

@property (nonatomic,weak)XTTopFunctionButton* carBtn;

@property (nonatomic,weak)XTTopFunctionButton* mapFindRoomBtn;

@property (nonatomic,weak)XTTopFunctionButton* overseasEasteBtn;

@property (nonatomic,weak)XTTopFunctionButton* neighborPropertieBtn;




@end

@implementation XTTopFunctionView

-(instancetype)initWithEventBlock:(XTTopFunctionViewEventBlock)eventBlock{
    if (self = [super init]) {
        _block = eventBlock;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFunctionView) name:@"refreshFunctionView" object:nil];
    }
    return self;
}

+ (instancetype)topFunctionViewWith:(XTTopFunctionViewEventBlock)eventBlock{
    return [[self alloc]initWithEventBlock:eventBlock];
}

- (void)refreshFunctionView{
    [self setNeedsLayout];
}



-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self quickRecommendBtn];
    [self addCustomerBtn];
    [self workReportBtn];
    [self recommendRecordBtn];
    [self carBtn];
    [self mapFindRoomBtn];
    [self overseasEasteBtn];
    [self neighborPropertieBtn];
}

- (void)layoutSubviews{
    BOOL showCarBtn = [UserData sharedUserData].trystCarEnable;
    BOOL showoverseasEasteBtn = [UserData sharedUserData].overseasEstateEnable;
    
    
#warning 测试
//    showCarBtn =YES;     //arc4random() %(0+2);
//    showoverseasEasteBtn =   YES;//    arc4random() %(0+2);
    
    NSMutableArray *allBtnArray = [NSMutableArray arrayWithObjects:_quickRecommendBtn,_addCustomerBtn,_workReportBtn,_recommendRecordBtn,_mapFindRoomBtn, nil];
   
    if ([UserData sharedUserData].storeId.length>0) {
        [allBtnArray addObject:_neighborPropertieBtn];
        _neighborPropertieBtn.hidden = NO;
    }else{
        _neighborPropertieBtn.hidden = YES;

    }
    
    if (showoverseasEasteBtn) {
        [allBtnArray addObject:_overseasEasteBtn];
    }
    _overseasEasteBtn.hidden = !showoverseasEasteBtn;

    if (showCarBtn) {
        [allBtnArray addObject:_carBtn];
    }
    _carBtn.hidden = !showCarBtn;

    
    
    for (NSInteger i = 0; i < allBtnArray.count; i ++) {
        
        NSInteger row = i / 4;
        NSInteger column = i % 4;
        
        NSInteger with = self.frame.size.width / 4;
        NSInteger height = self.frame.size.height/2;
        
        NSInteger x = with * column;
        NSInteger y = height * row;
        
        XTTopFunctionButton *btn = (XTTopFunctionButton *)allBtnArray[i];
        
        btn.frame = CGRectMake(x, y, with, height);
        
        
    }
    
    
    
    
    
//    NSInteger num = 4;       //4 + (showCarBtn?1:0);
//    CGFloat itemW = self.frame.size.width / num;
//    CGFloat itemH = self.frame.size.height/2;
//    CGFloat itemX = 0;
//    CGFloat itemY = 0;
//    
//    _quickRecommendBtn.frame = CGRectMake(itemX,itemY,itemW,itemH);
//    
//    itemX += itemW;
//    _addCustomerBtn.frame = CGRectMake(itemX,itemY,itemW,itemH);
//    
//    itemX += itemW;
//    _workReportBtn.frame = CGRectMake(itemX,itemY,itemW,itemH);
//    
//    itemX += itemW;
//    _recommendRecordBtn.frame = CGRectMake(itemX,itemY,itemW,itemH);
//    
//    itemX += itemW;
//    _carBtn.frame = CGRectMake(itemX,itemY,itemW,itemH);
//    _carBtn.hidden = !showCarBtn;
    
    
//    home-mapFindRoom@3x   //地图找房
//    home-overseasEaste@3x //海外楼盘
    
    
}

#pragma mark - getter

-(XTTopFunctionButton *)quickRecommendBtn{
    if (!_quickRecommendBtn) {
        XTTopFunctionButton* quickRB = [XTTopFunctionButton topFunctionButtonWithTitle:@"快速报备" normalImage:@"home-kuaisubaobei" selectedImage:@"home-kuaisubaobei"];
        quickRB.tag = 10000;
        [quickRB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quickRB];
        _quickRecommendBtn = quickRB;
    }
    return _quickRecommendBtn;
}

- (XTTopFunctionButton *)addCustomerBtn{
    if (!_addCustomerBtn) {
        XTTopFunctionButton* addCB = [XTTopFunctionButton topFunctionButtonWithTitle:@"添加客户" normalImage:@"home-addcustomer" selectedImage:@"home-addcustomer"];
        addCB.tag = 10001;
        [addCB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addCB];
        _addCustomerBtn = addCB;
    }
    return _addCustomerBtn;
}

- (XTTopFunctionButton *)workReportBtn{
    if (!_workReportBtn) {
        XTTopFunctionButton* workRB = [XTTopFunctionButton topFunctionButtonWithTitle:@"工作报表" normalImage:@"home-gongzuobaobiao" selectedImage:@"home-gongzuobaobiao"];
        workRB.tag = 10002;
        [workRB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:workRB];
        _workReportBtn = workRB;
    }
    return _workReportBtn;
}

- (XTTopFunctionButton *)recommendRecordBtn{
    if (!_recommendRecordBtn) {
        XTTopFunctionButton* recommendRB = [XTTopFunctionButton topFunctionButtonWithTitle:@"报备记录" normalImage:@"home-baobei" selectedImage:@"home-baobei"];
        recommendRB.tag = 10003;
        [recommendRB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recommendRB];
        _recommendRecordBtn = recommendRB;
    }
    return _recommendRecordBtn;
}


- (XTTopFunctionButton *)mapFindRoomBtn{
    if (!_mapFindRoomBtn) {
        XTTopFunctionButton* mapFindRoomB = [XTTopFunctionButton topFunctionButtonWithTitle:@"地图找房" normalImage:@"home-mapFindRoom" selectedImage:@"home-mapFindRoom"];
        mapFindRoomB.tag = 10004;
        [mapFindRoomB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mapFindRoomB];
        _mapFindRoomBtn = mapFindRoomB;
    }
    return _mapFindRoomBtn;
}


- (XTTopFunctionButton *)overseasEasteBtn{
    if (!_overseasEasteBtn) {
        XTTopFunctionButton* overseasEasteB = [XTTopFunctionButton topFunctionButtonWithTitle:@"海外房产" normalImage:@"home-overseasEaste" selectedImage:@"home-overseasEaste"];
        overseasEasteB.tag = 10005;
        [overseasEasteB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:overseasEasteB];
        _overseasEasteBtn = overseasEasteB;
    }
    return _overseasEasteBtn;
}





- (XTTopFunctionButton *)carBtn{
    if (!_carBtn) {
        XTTopFunctionButton* carRB = [XTTopFunctionButton topFunctionButtonWithTitle:@"约车看房" normalImage:@"home-kanfangzhuanche" selectedImage:@"home-kanfangzhuanche"];
        carRB.tag = 10006;
        [carRB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:carRB];
        _carBtn = carRB;
    }
    return _carBtn;
}

- (XTTopFunctionButton *)neighborPropertieBtn{
    if (!_neighborPropertieBtn) {
        XTTopFunctionButton* nerghberRB = [XTTopFunctionButton topFunctionButtonWithTitle:@"邻城置业" normalImage:@"home-neighborPropertie" selectedImage:@"home-neighborPropertie"];
        nerghberRB.tag = 10007;
        [nerghberRB addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nerghberRB];
        _neighborPropertieBtn = nerghberRB;
    }
    return _neighborPropertieBtn;
}

#pragma mark - action
- (void)functionBtnClick:(XTTopFunctionButton*)funcBtn{
    if (_block) {
        switch (funcBtn.tag) {
            case 10000:{
                _block(funcBtn,XTTopFunctionTypeQuickRecommend);
            }
                break;
            case 10001:{
                _block(funcBtn,XTTopFunctionTypeAddCustomer);
            }
                break;
            case 10002:{
                _block(funcBtn,XTTopFunctionTypeWorkReport);
            }
                break;
            case 10003:{
                _block(funcBtn,XTTopFunctionTypeRecommendRecord);
            }
                break;
            case 10004:{//地图找房
                _block(funcBtn,XTTopFunctionTypeMapFindRoom);
            }
                break;
            case 10005:{  //海外房产
                _block(funcBtn,XTTopFunctionTypeOverseasEasteBtn);

            }
                break;
            case 10006:{ // 看房专车
                _block(funcBtn,XTTopFunctionTypeCar);

            }
            case 10007:{ //邻城置业
                _block(funcBtn,XTTopFunctionTypeNeighborPropertie);
                
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end

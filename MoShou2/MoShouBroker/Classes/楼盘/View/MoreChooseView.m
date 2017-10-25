//
//  MoreChooseView.m
//  MoShou2
//
//  Created by strongcoder on 16/8/3.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "MoreChooseView.h"
#import "Standard.h"
#import "SysDic.h"
#import "OptionData.h"
#import "UserData.h"

@implementation MoreChooseView

{
    UIScrollView *_mainScrollView;
    
    UIView *_featureTagView;  //特色标签View
    
    UIView *_propertyView ;  //物业类型  VIew
    
    UIView *_bedroomView;  //居室View
    
    UIView *_trystCarView;  //看房约车View

    
    NSInteger _featureTagIndex;
    
    NSInteger _propertyIndex;

    NSInteger _bedroomIndex;
    
    NSInteger _trystCarIndex;
    
    CityFirstResult *_cityFirstResult;
    
    
    
        
}




-(id)initWithFrame:(CGRect)frame andCityFirstResult:(CityFirstResult*)CityFirstResult;
{

    self = [super initWithFrame:frame];
        
    if (self) {
        
        _cityFirstResult = CityFirstResult;
        Standard * feature = CityFirstResult.feature;
        Standard * property = CityFirstResult.property;
        NSArray * bedrooms = CityFirstResult.bedroomList;
        NSArray *trystCars = CityFirstResult.trystCarLists;
        _featureTagIndex = -1;
        _propertyIndex = -1;
        _bedroomIndex = -1;
        _trystCarIndex = -1;
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.contentSize = CGSizeMake(self.width, self.height);
      
#pragma mark - 特色

        _featureTagView = [[UIView alloc]init];
        [self addSubview:_mainScrollView];
        _mainScrollView.height = self.height - 40;
        
        [_mainScrollView addSubview:_featureTagView];
        
        NSInteger btnHeight = 30;
        CGFloat btnWith = (kMainScreenWidth-15*5)/4;
        CGFloat spaceWith = 15; //上下间距都是15
//        // 行间距
//        CGFloat rowHeight =15;
//        // 列间距
//        NSInteger columnWidth =15;
        
        UILabel *featureTagTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceWith, 15, 80, 13)];
        featureTagTitleLabel.text = @"特色";
        featureTagTitleLabel.font =FONT(13.f);
        featureTagTitleLabel.textColor = UIColorFromRGB(0x888888);
        featureTagTitleLabel.textAlignment = NSTextAlignmentLeft;
        
        [_featureTagView addSubview:featureTagTitleLabel];
  
        for (NSInteger i = 0; i<feature.sysDics.count; i++) {
            SysDic* sysDic = feature.sysDics[i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(spaceWith+i%4*(btnWith+spaceWith), featureTagTitleLabel.bottom+spaceWith+i/4*(btnHeight+spaceWith), btnWith, btnHeight);
            
            [button setTitle:sysDic.label forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xf3f3f3)] forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:BLUEBTBCOLOR] forState:UIControlStateSelected];
            [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = FONT(12.f);
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 5000+i;
            
            [_featureTagView addSubview:button];
        }
        
        UIButton *lastButton = (UIButton *)[_featureTagView viewWithTag:feature.sysDics.count-1+5000];
        [_featureTagView setFrame:CGRectMake(0, 0, kMainScreenWidth, lastButton.bottom+15)];
        [_featureTagView addSubview:[self creatLinelabelWithHeight:lastButton.bottom+14]];
#pragma mark -  物业类型
        _propertyView = [[UIView alloc]init];
        
        [_mainScrollView addSubview:_propertyView];
        UILabel *propertyLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceWith, 0, 80, 13)];
        propertyLabel.text = @"物业类型";
        propertyLabel.font =FONT(13.f);
        propertyLabel.textColor = LABELCOLOR;
        propertyLabel.textAlignment = NSTextAlignmentLeft;
        [_propertyView addSubview:propertyLabel];
        
        for (NSInteger i = 0; i<property.sysDics.count; i++) {
            SysDic* sysDic = property.sysDics[i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(spaceWith+i%4*(btnWith+spaceWith), propertyLabel.bottom+spaceWith+i/4*(btnHeight+spaceWith), btnWith, btnHeight);
            
            [button setTitle:sysDic.label forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xf3f3f3)] forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:BLUEBTBCOLOR] forState:UIControlStateSelected];
            [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = FONT(12.f);
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 6000+i;
            
            [_propertyView addSubview:button];
        }
        
        UIButton *propertyViewLastBtn = (UIButton *)[_propertyView viewWithTag:property.sysDics.count-1+6000];
        [_propertyView setFrame:CGRectMake(0, _featureTagView.bottom+15, kMainScreenWidth, propertyViewLastBtn.bottom+15)];

        [_propertyView addSubview:[self creatLinelabelWithHeight:propertyViewLastBtn.bottom+14]];
        
#pragma mark -  居室
  
        _bedroomView = [[UIView alloc]init];
        [_mainScrollView addSubview:_bedroomView];

        UILabel *bedRoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceWith, 0, 80, 13)];
        bedRoomLabel.text = @"居室";
        bedRoomLabel.font =FONT(13.f);
        bedRoomLabel.textColor = LABELCOLOR;
        bedRoomLabel.textAlignment = NSTextAlignmentLeft;
        [_bedroomView addSubview:bedRoomLabel];

        
        for (NSInteger i = 0; i<bedrooms.count; i++) {
            OptionData* data = bedrooms[i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(spaceWith+i%4*(btnWith+spaceWith), bedRoomLabel.bottom+spaceWith+i/4*(btnHeight+spaceWith), btnWith, btnHeight);
            
            [button setTitle:data.itemName forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xf3f3f3)] forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:BLUEBTBCOLOR] forState:UIControlStateSelected];
            [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = FONT(12.f);
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 7000+i;
            
            [_bedroomView addSubview:button];
        }
        
        UIButton *bedRoomViewLastBtn = (UIButton *)[_bedroomView viewWithTag:bedrooms.count-1+7000];
        [_bedroomView setFrame:CGRectMake(0, _propertyView.bottom+15, kMainScreenWidth, bedRoomViewLastBtn.bottom+15)];
        [_bedroomView addSubview:[self creatLinelabelWithHeight:bedRoomViewLastBtn.bottom+14]];

#pragma mark - 看房车
        if ([UserData sharedUserData].trystCarEnable) {
            
            _trystCarView = [[UIView alloc]init];
            [_mainScrollView addSubview:_trystCarView];
            
            UILabel *trystCarLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceWith, 0, 80, 13)];
            trystCarLabel.text = @"约车看房";
            trystCarLabel.font =FONT(13.f);
            trystCarLabel.textColor = LABELCOLOR;
            trystCarLabel.textAlignment = NSTextAlignmentLeft;
            [_trystCarView addSubview:trystCarLabel];
            
            for (NSInteger i = 0; i<trystCars.count; i++) {
                OptionData* data = trystCars[i];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(spaceWith+i%4*(btnWith+spaceWith), trystCarLabel.bottom+spaceWith+i/4*(btnHeight+spaceWith), btnWith, btnHeight);
                
                [button setTitle:data.itemName forState:UIControlStateNormal];
                [button setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xf3f3f3)] forState:UIControlStateNormal];
                [button setBackgroundImage:[self createImageWithColor:BLUEBTBCOLOR] forState:UIControlStateSelected];
                [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [button setBackgroundColor:[UIColor whiteColor]];
                button.titleLabel.font = FONT(12.f);
                button.layer.cornerRadius = 4;
                button.layer.masksToBounds = YES;
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 8000+i;
                
                [_trystCarView addSubview:button];
            }
            
            UIButton *trsyCarLastBtn = (UIButton *)[_trystCarView viewWithTag:trystCars.count-1+8000];
            [_trystCarView setFrame:CGRectMake(0, _bedroomView.bottom+15, kMainScreenWidth, trsyCarLastBtn.bottom)];
        }
       
        UILabel*lineView;
        if ([UserData sharedUserData].trystCarEnable)
        {
            lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, _trystCarView.bottom, kMainScreenWidth, 0.5)];
 
        }else{
            
            lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, _bedroomView.bottom, kMainScreenWidth, 0.5)];
        }
        
        lineView.backgroundColor = [UIColor clearColor];
        
        [_mainScrollView addSubview:lineView];
        
        
        for (NSInteger i = 0 ; i< 2; i ++) {
            NSInteger buttonWith = kMainScreenWidth/2;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(i*buttonWith, _mainScrollView.bottom, buttonWith, 40);
            [button setTitle:i==0?@"重置":@"确认" forState:UIControlStateNormal];
            button.backgroundColor = i==0?UIColorFromRGB(0xf3f3f3):BLUEBTBCOLOR;
            [button setTitleColor:i==0?BLUEBTBCOLOR:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
            button.tag = i+9000;
            [button addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            
        }
        
//        UIButton *endLastBtn = (UIButton *)[self viewWithTag:9001];

        
        [_mainScrollView setContentSize:CGSizeMake(kMainScreenWidth, lineView.bottom)];
                
        
    }
    
    
    return self;
    
}


-(void)btnClick:(UIButton *)button
{
    
    button.selected = !button.selected;
    if (button.selected) {
        [button setBackgroundColor:BLUEBTBCOLOR];
    }else{
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (button.tag>=5000 && button.tag<6000) {
        //特色标签
        UIButton *lastChooseBtn = (UIButton*)[_featureTagView viewWithTag:_featureTagIndex];
      
        if (_featureTagIndex !=button.tag ) {
            lastChooseBtn.selected = !lastChooseBtn.selected;
            
            if (lastChooseBtn.selected) {
                [lastChooseBtn setBackgroundColor:BLUEBTBCOLOR];
            }else{
                [lastChooseBtn setBackgroundColor:[UIColor whiteColor]];
            }
            
            _featureTagIndex = button.tag;

        }else{
            _featureTagIndex = -1;
        }

        
        
    }else if (button.tag>=6000 && button.tag<7000){
        //物业类型
        UIButton *lastChooseBtn = (UIButton*)[_propertyView viewWithTag:_propertyIndex];
        
        if (_propertyIndex !=button.tag ) {
            lastChooseBtn.selected = !lastChooseBtn.selected;
            
            if (lastChooseBtn.selected) {
                [lastChooseBtn setBackgroundColor:BLUEBTBCOLOR];
            }else{
                [lastChooseBtn setBackgroundColor:[UIColor whiteColor]];
            }
            
            _propertyIndex = button.tag;
            
        }else{
            _propertyIndex = -1;
        }
        
        
    }else if (button.tag>=7000 && button.tag<8000){
       //居室
        UIButton *lastChooseBtn = (UIButton*)[_bedroomView viewWithTag:_bedroomIndex];
        
        if (_bedroomIndex !=button.tag ) {
            lastChooseBtn.selected = !lastChooseBtn.selected;
            
            if (lastChooseBtn.selected) {
                [lastChooseBtn setBackgroundColor:BLUEBTBCOLOR];
            }else{
                [lastChooseBtn setBackgroundColor:[UIColor whiteColor]];
            }
            _bedroomIndex = button.tag;
            
        }else{
            _bedroomIndex = -1;
        }

        
    }else if(button.tag >=8000){
        
        //看房车
        UIButton *lastChooseBtn = (UIButton*)[_trystCarView viewWithTag:_trystCarIndex];
        
        if (_trystCarIndex !=button.tag ) {
            lastChooseBtn.selected = !lastChooseBtn.selected;
            
            if (lastChooseBtn.selected) {
                [lastChooseBtn setBackgroundColor:BLUEBTBCOLOR];
            }else{
                [lastChooseBtn setBackgroundColor:[UIColor whiteColor]];
            }
            _trystCarIndex = button.tag;
            
        }else{
            _trystCarIndex = -1;
        }
        
        
        
        
        
    }
    
    
    
}

-(void)refreshBtnStyleWithChooseDic:(NSDictionary *)moreDic;
{
    
//    _featureTagIndex = -1;
//    _propertyIndex = -1;
//    _bedroomIndex = -1;
//    _trystCarIndex = -1;

    if (moreDic) {
        
        if ([moreDic valueForKey:@"featureTagIndex"]) {
            _featureTagIndex =[[moreDic valueForKey:@"featureTagIndex"] integerValue];
            UIButton *lastFeatuerChooseBtn = (UIButton*)[_featureTagView viewWithTag:[[moreDic valueForKey:@"featureTagIndex"] integerValue]];
            if (!lastFeatuerChooseBtn.selected) {
                
                lastFeatuerChooseBtn.selected = YES;
                lastFeatuerChooseBtn.backgroundColor = BLUEBTBCOLOR;
                
            }
            
        }
        
        if ([moreDic valueForKey:@"propertyIndex"]) {
            _propertyIndex =[[moreDic valueForKey:@"propertyIndex"] integerValue];

            UIButton *lastPropertyChooseBtn = (UIButton*)[_propertyView viewWithTag:[[moreDic valueForKey:@"propertyIndex"] integerValue]];

            if (!lastPropertyChooseBtn.selected) {
                
                lastPropertyChooseBtn.selected = YES;
                lastPropertyChooseBtn.backgroundColor = BLUEBTBCOLOR;
                
            }
        }
        
        if ([moreDic valueForKey:@"bedroomIndex"]) {
          
            _bedroomIndex =[[moreDic valueForKey:@"bedroomIndex"] integerValue];

            UIButton *lastBedRoomChooseBtn = (UIButton*)[_bedroomView viewWithTag:[[moreDic valueForKey:@"bedroomIndex"] integerValue]];

            if (!lastBedRoomChooseBtn.selected) {
                
                lastBedRoomChooseBtn.selected = YES;
                lastBedRoomChooseBtn.backgroundColor = BLUEBTBCOLOR;
                
            }
        }
        
        if ([moreDic valueForKey:@"trystCarIndex"]) {
            
            _trystCarIndex =[[moreDic valueForKey:@"trystCarIndex"] integerValue];
            
            UIButton *lastTrysCarChooseBtn = (UIButton*)[_trystCarView viewWithTag:[[moreDic valueForKey:@"trystCarIndex"] integerValue]];
            
            if (!lastTrysCarChooseBtn.selected) {
                
                lastTrysCarChooseBtn.selected = YES;
                lastTrysCarChooseBtn.backgroundColor = BLUEBTBCOLOR;
                
            }
        }
    }
    
}


#pragma mark - 重置和确认 点击

-(void)bottomBtnClick:(UIButton *)button
{
   
    Standard * feature = _cityFirstResult.feature;
    Standard * property = _cityFirstResult.property;
    NSArray * bedrooms = _cityFirstResult.bedroomList;
    NSArray * trysCars = _cityFirstResult.trystCarLists;
    if (button.tag== 9000) {
        
        DLog(@"清空");
        UIButton *lastFeatuerChooseBtn = (UIButton*)[_featureTagView viewWithTag:_featureTagIndex];
        UIButton *lastPropertyChooseBtn = (UIButton*)[_propertyView viewWithTag:_propertyIndex];
        UIButton *lastBedRoomChooseBtn = (UIButton*)[_bedroomView viewWithTag:_bedroomIndex];
        UIButton *lastTrysCarChooseBtn = (UIButton*)[_trystCarView viewWithTag:_trystCarIndex];

        
        lastFeatuerChooseBtn.selected = NO;
        lastPropertyChooseBtn.selected = NO;
        lastBedRoomChooseBtn.selected = NO;
        lastTrysCarChooseBtn.selected = NO;
        [lastFeatuerChooseBtn setBackgroundColor:[UIColor whiteColor]];
        [lastPropertyChooseBtn setBackgroundColor:[UIColor whiteColor]];
        [lastBedRoomChooseBtn setBackgroundColor:[UIColor whiteColor]];
        [lastTrysCarChooseBtn setBackgroundColor:[UIColor whiteColor]];

        _featureTagIndex = -1;
        _propertyIndex = -1;
        _bedroomIndex = -1;
        _trystCarIndex = -1;
             
    }else if (button.tag == 9001){
        
        DLog(@"确认");
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if (_featureTagIndex >=5000) {
            
            SysDic *sys = feature.sysDics[_featureTagIndex-5000];
            [dic setValue:sys.code forKey:@"featureId"];
            [dic setValue:[NSString stringWithFormat:@"%zd",_featureTagIndex] forKey:@"featureTagIndex"];
        }
        
        
        if (_propertyIndex >=6000) {
            
            SysDic *sys = property.sysDics[_propertyIndex-6000];
            [dic setValue:sys.code forKey:@"propertyId"];
            [dic setValue:[NSString stringWithFormat:@"%zd",_propertyIndex] forKey:@"propertyIndex"];

        }
        
        if (_bedroomIndex >= 7000) {
            
            OptionData *data = bedrooms[_bedroomIndex-7000];
            
            [dic setValue:data.itemValue forKey:@"bedroomId"];
            [dic setValue:[NSString stringWithFormat:@"%zd",_bedroomIndex] forKey:@"bedroomIndex"];

            
        }
        
        if (_trystCarIndex>=8000) {
            OptionData *data = trysCars[_trystCarIndex-8000];
            
            [dic setValue:data.itemValue forKey:@"trystCarId"];
            [dic setValue:[NSString stringWithFormat:@"%zd",_trystCarIndex] forKey:@"trystCarIndex"];
        }
     
        if ([self.delegate respondsToSelector:@selector(didcommintBtnWithMoreChooseDic:)]) {
            [self.delegate didcommintBtnWithMoreChooseDic:dic];
        }
        
        
        
    }
    
    
    
    
    
}

- (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}


- (UILabel *)creatLinelabelWithHeight:(CGFloat )height
{
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, height, kMainScreenWidth-10, 1)];
    lineLabel.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    return lineLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

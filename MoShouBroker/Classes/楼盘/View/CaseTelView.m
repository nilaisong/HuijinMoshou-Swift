//
//  CaseTelView.m
//  MoShou2
//
//  Created by strongcoder on 16/9/18.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CaseTelView.h"
#define kCaseTelHeight 55  // 单行的高度


@interface CaseTelView ()

@property (nonatomic,strong)Building *buildingMo;

@property (nonatomic,assign)CaseTelViewStyle caseTelViewStyle;

@end

@implementation CaseTelView

-(id)initWithBuilding:(Building *)building AndCaseTelViewStyle:(CaseTelViewStyle)caseTelViewStyle;
{
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    
    if (self) {
        
        self.buildingMo = building;
        self.caseTelViewStyle = caseTelViewStyle;
        [self loadUI];
    }
    
    return self;
    
}

-(void)loadUI;
{

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.3;
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelfClick)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    CGFloat telListViewHeight;
    
    if (self.caseTelViewStyle == OnLineChatStyle) {
        telListViewHeight = (self.buildingMo.easemobConfirmList.count+1)*kCaseTelHeight;
    }else if (self.caseTelViewStyle == ContactFieldStyle){
        telListViewHeight = (self.buildingMo.caseTelList.count+1)*kCaseTelHeight;
    }
        if (telListViewHeight > kCaseTelHeight*6)
        {

            telListViewHeight = kCaseTelHeight*6;
        }
    
    UIView *telListView = [[UIView alloc]initWithFrame:CGRectMake(0.1*kMainScreenWidth, (kMainScreenHeight-telListViewHeight)/2, 0.8*kMainScreenWidth, telListViewHeight)];
    telListView.backgroundColor = [UIColor whiteColor];
    telListView.layer.cornerRadius = 10;
    telListView.layer.masksToBounds = YES;
    telListView.userInteractionEnabled = YES;
    [self addSubview:telListView];
    
    
    
    UILabel *titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, telListView.width, kCaseTelHeight)];
    
    if (self.caseTelViewStyle == OnLineChatStyle) {
        titileLabel.text = @"在线咨询";

    }else if (self.caseTelViewStyle == ContactFieldStyle){
        titileLabel.text = @"联系驻场";

    }
    titileLabel.font = [UIFont boldSystemFontOfSize:20.f];
    titileLabel.tintColor = [UIColor blackColor];
    titileLabel.backgroundColor = BACKGROUNDCOLOR;
    titileLabel.textAlignment = NSTextAlignmentCenter;
    
    [telListView addSubview:titileLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kCaseTelHeight-0.5, telListView.width, 0.5)];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.alpha = 0.5;
    [telListView addSubview:lineLabel];
    
    
    UIScrollView *telListScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kCaseTelHeight, telListView.width, telListView.height-kCaseTelHeight)];
    
    if (self.caseTelViewStyle == OnLineChatStyle) {
        telListScrollView.contentSize = CGSizeMake(kCaseTelHeight, self.buildingMo.easemobConfirmList.count*kCaseTelHeight);
        
    }else if (self.caseTelViewStyle == ContactFieldStyle){
        telListScrollView.contentSize = CGSizeMake(kCaseTelHeight, self.buildingMo.caseTelList.count*kCaseTelHeight);
   
    }
    
    [telListView addSubview:telListScrollView];
    
    
    if (self.caseTelViewStyle == OnLineChatStyle) {
        //在线咨询
        for (NSInteger i = 0; i < self.buildingMo.easemobConfirmList.count; i ++) {
            
            EasemobConfirmModel  * easemobConfirmMo = self.buildingMo.easemobConfirmList[i];
            
            UIButton *easemobConfirmViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*kCaseTelHeight, telListView.width, kCaseTelHeight)];
            easemobConfirmViewBtn.tag = i+6000;
            [easemobConfirmViewBtn addTarget:self action:@selector(easemobConfirmViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [telListScrollView addSubview:easemobConfirmViewBtn];
            
            UILabel *nameLabel = [[UILabel alloc]init];
//                                  WithFrame:CGRectMake(15, 15, telListView.width-60, 16)];
            nameLabel.text = easemobConfirmMo.nickname;
            nameLabel.font = FONT(18.f);
            nameLabel.textColor = NAVIGATIONTITLE;
            nameLabel.textAlignment = NSTextAlignmentLeft;
            CGSize size = [nameLabel boundingRectWithSize:CGSizeMake(telListView.width-50-22*SCALE-10, 0)];
            nameLabel.frame = CGRectMake(15, 0, size.width, kCaseTelHeight);
            [easemobConfirmViewBtn addSubview:nameLabel];
            
            UILabel *onLineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+5, 0, 50, kCaseTelHeight)];
            if ([easemobConfirmMo.status isEqualToString:@"offline"]) {
                onLineTypeLabel.text = [NSString stringWithFormat:@"[离线]"];
                onLineTypeLabel.textColor =NAVIGATIONTITLE;
            }else if ([easemobConfirmMo.status isEqualToString:@"online"]){
                onLineTypeLabel.text = [NSString stringWithFormat:@"[在线]"];
                onLineTypeLabel.textColor =BLUEBTBCOLOR;
            }
            onLineTypeLabel.font = FONT(12.f);
            [easemobConfirmViewBtn addSubview:onLineTypeLabel];
            
            
            UIImageView *callImageView = [[UIImageView alloc]initWithFrame:CGRectMake(telListView.width-15-22*SCALE, (kCaseTelHeight-22*SCALE)/2, 22*SCALE, 22*SCALE)];
            callImageView.image = [UIImage imageNamed:@"咨询蓝.png"];
            [easemobConfirmViewBtn addSubview:callImageView];
            
            if (i!=self.buildingMo.easemobConfirmList.count-1) {
                
                UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kCaseTelHeight-0.5, telListView.width, 0.5)];
                lineLabel.backgroundColor = [UIColor grayColor];
                lineLabel.alpha = 0.5;
                [easemobConfirmViewBtn addSubview:lineLabel];
            }
        }
        
        
        
    }else if (self.caseTelViewStyle == ContactFieldStyle ){
        //联系案场
        for (NSInteger i = 0; i < self.buildingMo.caseTelList.count; i ++) {
            
            CaseTelList  * caseTelListMo = self.buildingMo.caseTelList[i];
            
            UIButton *caseTelOnlyView = [[UIButton alloc]initWithFrame:CGRectMake(0, i*kCaseTelHeight, telListView.width, kCaseTelHeight)];
            caseTelOnlyView.tag = i+5000;
            [caseTelOnlyView addTarget:self action:@selector(caseTelOnlyViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [telListScrollView addSubview:caseTelOnlyView];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, telListView.width-60, 16)];
            nameLabel.text = caseTelListMo.caseUsername;
            nameLabel.font = FONT(14.f);
            nameLabel.textColor = NAVIGATIONTITLE;
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [caseTelOnlyView addSubview:nameLabel];
            
            UILabel *telPhonelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10+10+10, telListView.width-60, 16)];
            telPhonelabel.text = caseTelListMo.caseTel;
            telPhonelabel.font  = FONT(14.f);
            telPhonelabel.textColor = LABELCOLOR;
            telPhonelabel.textAlignment = NSTextAlignmentLeft;
            [caseTelOnlyView addSubview:telPhonelabel];
            
            
            UIImageView *callImageView = [[UIImageView alloc]initWithFrame:CGRectMake(telListView.width-15-22*SCALE, (kCaseTelHeight-22*SCALE)/2, 22*SCALE, 22*SCALE)];
            callImageView.image = [UIImage imageNamed:@"button_call"];
            [caseTelOnlyView addSubview:callImageView];
            
            if (i!=self.buildingMo.caseTelList.count-1) {
                
                UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kCaseTelHeight-0.5, telListView.width, 0.5)];
                lineLabel.backgroundColor = [UIColor grayColor];
                lineLabel.alpha = 0.5;
                [caseTelOnlyView addSubview:lineLabel];
            }
        }
    
    }
    

}


-(void)caseTelOnlyViewClick:(UIButton *)btn
{
    
    
    self.DidSelectOneCaseTelViewBlock(self.buildingMo.caseTelList[btn.tag-5000]);
 
    [self removeAllSubviews];

    [self removeFromSuperview];

}

-(void)easemobConfirmViewBtnClick:(UIButton *)btn
{
    
    
    self.DidSelectOneEasemobConfirmBlock(self.buildingMo.easemobConfirmList[btn.tag-6000]);
    
    [self removeAllSubviews];

    [self removeFromSuperview];

    
    
}





-(void)tapSelfClick
{
 
    [self removeAllSubviews];

    [self removeFromSuperview];
    
    
}



@end

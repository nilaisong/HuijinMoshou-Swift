//
//  IntentionView.m
//  MoShou2
//
//  Created by strongcoder on 15/12/3.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "IntentionView.h"
#import "Estate.h"
@implementation IntentionView

-(id)initWithFrame:(CGRect)frame AndBuilding:(Building *)building AndBuildingCustomerCount:(NSString *)buildingCustomerCount;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
//           新版不需要这个参数    buildingCustomerCount
//        DLog(@"buildingCustomerCount=====%@",buildingCustomerCount);
//        if ([self isBlankString:buildingCustomerCount]) {
//            buildingCustomerCount = @"0";
//        }
//        NSString *CustomerCount = [NSString stringWithFormat:@"%@",buildingCustomerCount];
//        if ([self isBlankString:CustomerCount])
//        {
//            CustomerCount = @"0";
//        }else if([CustomerCount isEqualToString:@"null"]){
//            CustomerCount = @"0";
//
//        }
//        NSArray *titleContentArr = @[building.recommendationNum,building.signNum,building.visitNum,building.shipAgencyNum,tempEstate.saleHouse];

        Estate *tempEstate = building.estate;
        
        
        if ([self isBlankString:building.recommendationNum])
        {
            building.recommendationNum = @"0";
        }
        if ([self isBlankString:building.signNum])
        {
           building.signNum = @"0";
        }
        
        if ([self isBlankString:building.visitNum])
        {
            building.visitNum = @"0";
        }
        
        if ([self isBlankString:building.shipAgencyNum])
        {
            building.shipAgencyNum = @"0";
        }
        
        if ([self isBlankString:tempEstate.saleHouse])
        {
           tempEstate.saleHouse = @"0";
        }
        
        

        
        NSArray *titleArr = @[@"报备客户",@"带看客户",@"成交客户",@"合作经纪人",@"在售房源"];

        NSArray *titleContentArr = [NSArray arrayWithObjects: building.recommendationNum,building.visitNum,building.signNum,building.shipAgencyNum,tempEstate.saleHouse, nil];

        
        for (NSInteger i = 0; i < titleArr.count; i ++)
        {
            
            UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(kMainScreenWidth/titleArr.count), 15, kMainScreenWidth/titleArr.count, 14)];
            numberLabel.text =  [NSString stringWithFormat:@"%@", titleContentArr[i]];
            numberLabel.font = FONT(13.f);
            numberLabel.textColor = UIColorFromRGB(0x333333);
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:numberLabel];

            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(kMainScreenWidth/titleArr.count), numberLabel.bottom+10, kMainScreenWidth/titleArr.count, 14)];
            titleLabel.text = titleArr[i];
            titleLabel.font = FONT(13.f);
            titleLabel.textColor = UIColorFromRGB(0x888888);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:titleLabel];
            
            if (i<4) {
                UILabel *shuLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth/titleArr.count*(i+1), 15, 1, (124/2)-30)];
                shuLineLabel.backgroundColor = UIColorFromRGB(0xefeff4);
                [self addSubview:shuLineLabel];
            }
           
            
        }
        
    }
    
    
    
    
    
    
    return self;
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
    
    if ([string isEqualToString:@"null"] ||[string isEqualToString:@"NULL"]) {
        return YES;
    }
    
    if (string.length==0) {
        return YES;
    }
    
    return NO;
}





@end

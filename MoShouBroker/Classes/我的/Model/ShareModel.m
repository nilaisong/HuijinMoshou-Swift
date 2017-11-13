//
//  ShareDataModel.m
//  TuluAuction
//
//  Created by haoxiangfeng on 15-3-30.
//  Copyright (c) 2015年 artron. All rights reserved.
//

#import "ShareModel.h"
#import <ShareSDK/ShareSDK.h>
@implementation ShareModel

//-(NSString *)districtName
//{
//    if (_districtName.length>0) {
//        return [NSString stringWithFormat:@"【%@】",_districtName];
//    }
//
//    return _districtName;
//
//}

-(NSString *)district
{
    
    if (_district.length>0) {
        
        return _district;
    }else{
        
        return @"";
    }
    
}


-(NSString *)plate
{
    
    if (_plate.length>0) {
        
        return _plate;
    }else{
        
        return @"";
    }
    
}
-(NSString *)houseType
{
    
    if (_houseType.length>0) {
        
        return _houseType;
    }else{
        
        return @"";
    }
    
}

-(NSString *)AllPrice
{
    
    if (_AllPrice.length>0) {
        
        return [NSString stringWithFormat:@"%@起",_AllPrice];;
    }else{
        
        return @"";
    }
    
}

-(NSString *)acreageType
{
    
    if (_acreageType.length>0) {
        
        return _acreageType;
    }else{
        
        return @"";
    }
    
}




@end

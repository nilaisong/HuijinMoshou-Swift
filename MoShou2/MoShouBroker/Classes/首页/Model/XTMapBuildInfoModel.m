//
//  XTMapBuildInfoModel.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapBuildInfoModel.h"
#import "BuildingListData.h"
#import "Functions.h"
@implementation XTMapBuildInfoModel

- (void)setBuildingListData:(BuildingListData *)data{
    _address = data.address;
    _estateId = data.buildingId;//楼盘编号
    _name = data.name;//楼盘名称
    _price = data.price;//均价
    
    _url = data.url;//后台返回原图
    data.thmUrl;//缩略图
    data.imgUrl;//大图
    
    
    
    _districtName = data.districtName;//楼盘所在区域
    _estateLongitude = data.saleLongitude;//坐标经度
    _estateLatitude = data.saleLatitude; //坐标纬度
    //@property(nonatomic,copy) NSString* housePrice; //房子均价
    _commissionStandard = data.commissionStandard;//佣金字段
    
//     data.formatCommissionStandard; //自己手动拼接的佣金字段
    
    _commissionType = data.commissionType;    //佣金类型
    _commissionBegin = data.commissionBegin;    // 佣金开始字段
    _commissionEnd = data.commissionEnd;    //佣金结束字段
    _commissionDisplay =  data.commissionDisplay;    //--楼盘列表不显示   0 显示    1不显示
    
    _platName = data.plateName;  // 商圈

}

- (NSString *)thmUrl{
    if (_url.length > 0) {
//        375 400
        return  mapBuildingSmallUrl(_url);
    }
    return _url;
}


-(NSString*)formatCommissionStandard  //自己手动拼接的佣金字段
{
    
    //"commissionType": "1",
    //"commissionBegin": "1234.11",
    //"commissionEnd": "2345.22",
    
    if (![self isBlankString:self.commissionType]) {
        
        if ([self.commissionType isEqualToString:@"1"]) { //万
            
            if (![self isBlankString:self.commissionBegin] && ![self isBlankString:self.commissionEnd]) {
                
                return [NSString stringWithFormat:@"%@-%@万",self.commissionBegin,self.commissionEnd];
            }else if(![self isBlankString:self.commissionBegin]){
                
                return [NSString stringWithFormat:@"%@万",self.commissionBegin];
            }else if(![self isBlankString:self.commissionEnd]){
                
                return [NSString stringWithFormat:@"%@万",self.commissionEnd];
            }
            
        }else if ([self.commissionType isEqualToString:@"0"]){ //%%%%%
            
            if (![self isBlankString:self.commissionBegin] && ![self isBlankString:self.commissionEnd]) {
                
                return [NSString stringWithFormat:@"%@-%@%@",self.commissionBegin,self.commissionEnd,@"%"];
            }else if(![self isBlankString:self.commissionBegin]){
                
                return [NSString stringWithFormat:@"%@%@",self.commissionBegin,@"%"];
            }else if(![self isBlankString:self.commissionEnd]){
                
                return [NSString stringWithFormat:@"%@%@",self.commissionEnd,@"%"];
            }
            
        }else if ([self.commissionType isEqualToString:@"2"]){
            
            if (![self isBlankString:self.commissionBegin] && ![self isBlankString:self.commissionEnd]) {
                
                return [NSString stringWithFormat:@"%@%@+%@%@",self.commissionBegin,@"%",self.commissionEnd,@"万"];
            }else if(![self isBlankString:self.commissionBegin]){
                
                return [NSString stringWithFormat:@"%@%@",self.commissionBegin,@"%"];
            }else if(![self isBlankString:self.commissionEnd]){
                
                return [NSString stringWithFormat:@"%@%@",self.commissionEnd,@"万"];
            }
            
            
            
            
        }
        
    }else{
        
        return @"";
    }
    
    return @"";
    
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

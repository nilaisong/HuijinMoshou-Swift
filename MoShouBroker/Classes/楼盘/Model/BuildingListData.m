//
//  BuildingListData.m
//  MoShouQueke
//
//  Created by strongcoder on 15/10/29.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//

#import "BuildingListData.h"

@implementation BuildingListData



-(DownloadStateType)downloadState
{
    return [[DownloaderManager sharedManager] getDownloadStateWithItemId:_buildingId];
}


-(NSString*)fullName
{
    if (self.districtName.length>0&& self.name.length>0) {
        return [NSString stringWithFormat:@"%@%@",self.districtName,self.name];
    }
    
    return self.name;
}

-(NSString *)showPriceString{
    return [NSString stringWithFormat:@"%@%@",@"",self.priceValue];
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



-(NSString*) thmUrl
{
    if (_url.length>0) {
        
        return smallImgUrl(_url);
    }
    return @"";
}

-(NSString*) imgUrl
{
    if (_url.length>0) {
        
        NSLog(@"bigImgUrl(_imgUrl)=====%@",bigImgUrl(_url));
        
        return bigImgUrl(_url);
        
        
    }
    return @"";
}


- (NSString *)districtplateName
{
    if (_districtName.length>0 && _plateName.length>0 ) {
     
        return [NSString stringWithFormat:@"%@-%@",_districtName,_plateName];
    }else if(_districtName.length>0){
        return _districtName;
        
    }else if(_plateName.length>0){
        return _plateName;
    }else{
        return @"";
    }
}

//bedroomSegment
//saleAreaSegment

-(NSString*) bedroomSegment
{
    if ([self isBlankString:_bedroomSegment]) {
        
        return @"";
    }else{
        return _bedroomSegment;
    }
}

-(NSString*) saleAreaSegment
{
    if ([self isBlankString:_saleAreaSegment]) {
        
        return @"";
    }else{
        return _saleAreaSegment;
    }
}




//-(NSString *)districtName
//{
//    if (_districtName.length>0) {
//        return [NSString stringWithFormat:@"[%@]",_districtName];
//    }
//    
//    return _districtName;
//    
//}
@end

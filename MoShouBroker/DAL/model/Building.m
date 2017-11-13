//
//  Building.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "Building.h"

@implementation Building

-(DownloadStateType)downloadState
{
    return [[DownloaderManager sharedManager] getDownloadStateWithItemId:_buildingId];
}

//-(NSString*)fullName
//{
//    if (self.districtName.length>0&& self.name.length>0) {
//        return [NSString stringWithFormat:@"%@%@",self.districtName,self.name];
//    }
//    
//    return self.name;
//}

//-(NSString *)districtName
//{
//    if (_districtName.length>0) {
//        return [NSString stringWithFormat:@"【%@】",_districtName];
//    }
//    
//    return _districtName;
//    
//}

//-(NSString*)featureTag
//{
//    if (_featureTag.length>0) {
//        NSMutableString* tag = [NSMutableString string];
//        [tag appendString:@"【"];
//        [tag appendString:_featureTag];
//        [tag appendString:@"】"];
//        return [tag stringByReplacingOccurrencesOfString:@"," withString:@"】【"];
//    }
//    return _featureTag;
//}

//
//-(NSString*)formatCommissionStandard  //自己手动拼接的佣金字段
//{
//    
//    //"commissionType": "1",
//    //"commissionBegin": "1234.11",
//    //"commissionEnd": "2345.22",
//    
//    if (![self isBlankString:self.commissionType]) {
//        
//        if ([self.commissionType isEqualToString:@"1"]) { //万
//            
//            if (![self isBlankString:self.commissionBegin] && ![self isBlankString:self.commissionEnd]) {
//                
//                return [NSString stringWithFormat:@"%@-%@万",self.commissionBegin,self.commissionEnd];
//            }else if(![self isBlankString:self.commissionBegin]){
//                
//                return [NSString stringWithFormat:@"%@万",self.commissionBegin];
//            }else if(![self isBlankString:self.commissionEnd]){
//                
//                return [NSString stringWithFormat:@"%@万",self.commissionEnd];
//            }
//            
//        }else if ([self.commissionType isEqualToString:@"0"]){ //%%%%%
//            
//            if (![self isBlankString:self.commissionBegin] && ![self isBlankString:self.commissionEnd]) {
//                
//                return [NSString stringWithFormat:@"%@-%@%@",self.commissionBegin,self.commissionEnd,@"%"];
//            }else if(![self isBlankString:self.commissionBegin]){
//                
//                return [NSString stringWithFormat:@"%@%@",self.commissionBegin,@"%"];
//            }else if(![self isBlankString:self.commissionEnd]){
//                
//                return [NSString stringWithFormat:@"%@%@",self.commissionEnd,@"%"];
//            }
//            
//        }
//        
//    }else{
//        
//        return @"";
//    }
//    
//    return @"";
//    
//}



-(NSString*)onsellHouseCount
{
    if (_onsellHouseCount.length>0) {
        
        return [NSString stringWithFormat:@"%@个",_onsellHouseCount];
    }else{
        return _onsellHouseCount;
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




@end

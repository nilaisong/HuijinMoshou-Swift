//
//  Estate.m
//  MoShou2
//
//  Created by strongcoder on 16/4/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "Estate.h"

@implementation Estate




-(NSString*) thmUrl
{
    if (_pathUrl.length>0) {
        
        return smallImgUrl(_pathUrl);
    }
    return @"";
}

-(NSString*) imgUrl
{
    if (_pathUrl.length>0) {
        
        NSLog(@"bigImgUrl(_imgUrl)=====%@",bigImgUrl(_pathUrl));
        
        return bigImgUrl(_pathUrl);
        
    }
    return @"";
}


-(NSString*) builtUpArea
{
    if (_builtUpArea.length>0) {
        
        return _builtUpArea;
//        return [NSString stringWithFormat:@"%@平米",_builtUpArea];
    }
    return @"";
}


-(NSString*) landArea
{
    if (_landArea.length>0) {
        
        return [NSString stringWithFormat:@"%@",_landArea];
    }
    return @"";
}


-(NSString*) saleRoomNumber
{
    if (_saleRoomNumber.length>0) {
        
        return [NSString stringWithFormat:@"%@个",_saleRoomNumber];
    }
    return @"";
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

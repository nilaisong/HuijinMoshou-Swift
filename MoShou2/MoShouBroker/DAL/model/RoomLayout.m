//
//  RoomLayout.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/6/19.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "RoomLayout.h"

@implementation RoomLayout

//@property(nonatomic,copy) NSString* saleArea;//销售面积
//@property(nonatomic,copy) NSString* innerArea;//套内面积
//@property(nonatomic,copy) NSString* shareArea;//分摊面积
//@property(nonatomic,copy) NSString* presentArea;//赠送面积

-(NSString*) thumUrl
{
    if (_imgUrl.length>0) {
        
        return smallImgUrl(_imgUrl);
    }
    return @"";
}

-(NSString*) imgUrl
{
    if (_imgUrl.length>0) {
        return bigImgUrl(_imgUrl);
    }
    return @"";
}


-(NSString *)saleArea
{
    if (_saleArea.length>0) {
        
        if (![self isPureInt:_saleArea]) {
            
            if ([self isPureFloat:_saleArea]) {
                
            return [self notRounding:[_saleArea floatValue] afterPoint:2];
                
            }
        }
    }
    return _saleArea;
}

-(NSString *)innerArea
{
    if (_innerArea.length>0) {
        
        if (![self isPureInt:_innerArea]) {
            
            if ([self isPureFloat:_innerArea]) {
                
                return [self notRounding:[_innerArea floatValue] afterPoint:2];
                
            }
        }
    }
    return _innerArea;
}

-(NSString *)shareArea
{
    if (_shareArea.length>0) {
        
        if (![self isPureInt:_shareArea]) {
            
            if ([self isPureFloat:_shareArea]) {
                
                return [self notRounding:[_shareArea floatValue] afterPoint:2];
                
            }
        }
    }
    return _shareArea;
}

-(NSString *)presentArea
{
    if (_presentArea.length>0) {
        
        if (![self isPureInt:_presentArea]) {
            
            if ([self isPureFloat:_presentArea]) {
                
                return [self notRounding:[_presentArea floatValue] afterPoint:2];
                
            }
        }
    }
    return _presentArea;
}



//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

-(NSString *)notRounding:(CGFloat)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end

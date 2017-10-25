//
//  XTMapPinView.m
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTMapPinView.h"

@interface XTMapPinView()
@property (nonatomic,assign)XTMapPinViewType pinType;

@end

@implementation XTMapPinView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier type:(XTMapPinViewType)type{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    [self setPinType:type];

    return self;
}

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    
    return self;
}

- (void)setPinType:(XTMapPinViewType)pinType{
    _pinType = pinType;
    NSString* imageName = @"pin-2";
    switch (_pinType) {
        case XTMapPinViewTypeBank:
        {
            imageName = @"building-bank";
        }
            break;
        case XTMapPinViewTypeShop:
        {
            imageName = @"building-shop";
        }
            break;
        case XTMapPinViewTypeSchool:
        {
            imageName = @"building-school";
        }
            break;
        case XTMapPinViewTypeSubway:
        {
           imageName = @"building-subway";
        }
            break;
        case XTMapPinViewTypeHospital:
        {
           imageName = @"building-hospital";
        }
            break;
        case XTMapPinViewTypeBus:{
            imageName = @"building-bus";
        }
            break;
        default:
            break;
    }
    self.image = [UIImage imageNamed:imageName];
}

@end

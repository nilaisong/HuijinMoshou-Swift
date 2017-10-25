//
//  XTEditCustomerView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTEditCustomerView.h"

@interface XTEditCustomerView()

@end

@implementation XTEditCustomerView

+ (instancetype)editCustomerView{
    NSString* className = NSStringFromClass([self class]);
    
    return  [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
}

+ (instancetype)editCustomerViewWithCallBack:(XTEditCustomerViewEventCallBack)callBack{
    XTEditCustomerView* view = [self editCustomerView];
    view.callBack = callBack;
    return view;
}

- (IBAction)manButtonClick:(UIButton *)sender {
    _manButton.selected = YES;
    _womanButton.selected = NO;
    if (_callBack) {
        _callBack(self,XTEditCustomerViewSexMan);
    }
}
- (IBAction)womanButtonClick:(UIButton *)sender {
    _manButton.selected = NO;
    _womanButton.selected = YES;
    if (_callBack) {
        _callBack(self,XTEditCustomerViewSexWoMan);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    _manButton.selected = YES;
    if (_callBack) {
        _callBack(self,XTEditCustomerViewSexMan);
    }
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.91, 0.91, 0.91, 1.0);//线条颜色
    CGContextMoveToPoint(context, 0, 0.5);
    CGContextSetLineWidth(context, 1);
    CGContextAddLineToPoint(context, self.frame.size.width,0);
    CGContextStrokePath(context);

    CGContextSetRGBStrokeColor(context, 0.91, 0.91, 0.91, 1.0);//线条颜色
    CGContextMoveToPoint(context, 16, self.frame.size.height / 2.0 - 1);
    CGContextSetLineWidth(context, 1);
    CGContextAddLineToPoint(context, self.frame.size.width,self.frame.size.height / 2.0 - 1);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 0.91, 0.91, 0.91, 1.0);//线条颜色
    CGContextMoveToPoint(context, 0, self.frame.size.height - 0.5);
    CGContextSetLineWidth(context, 1);
    CGContextAddLineToPoint(context, self.frame.size.width,self.frame.size.height - 0.5);
    CGContextStrokePath(context);
}
@end

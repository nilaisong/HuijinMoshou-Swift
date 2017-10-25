//
//  MyAlertView.m
//  MoShouBroker
//
//  Created by NiLaisong on 15/8/17.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "MyAlertView.h"
@interface MyAlertView ()

@property(atomic,assign) id<MyAlertViewDelegate> theDelegate;

@end

@implementation MyAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if(self = [super initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil])
    {
        self.delegate = self;
        self.theDelegate = delegate;
        self.parameters = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(myAlertView:clickedButtonAtIndex:)])
    {
        [_theDelegate myAlertView:(MyAlertView*)alertView clickedButtonAtIndex:buttonIndex];
    }
}

@end

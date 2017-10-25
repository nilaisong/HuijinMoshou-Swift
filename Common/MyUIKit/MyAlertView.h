//
//  MyAlertView.h
//  MoShouBroker
//
//  Created by NiLaisong on 15/8/17.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIAlertView<UIAlertViewDelegate>
@property (nonatomic,strong) NSMutableDictionary* parameters;
@end

@protocol MyAlertViewDelegate <NSObject>

-(void)myAlertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
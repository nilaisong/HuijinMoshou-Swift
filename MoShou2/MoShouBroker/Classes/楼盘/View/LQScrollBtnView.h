//
//  LQScrollBtnView.h
//  MoShouBroker
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQScrollBtnView;
@protocol LQScrollBtnViewDelegate <NSObject>
@optional
-(void)choosebtn:(LQScrollBtnView *)view withBtntag:(NSInteger)btnTag;

@end


@interface LQScrollBtnView : UIView
@property (nonatomic,weak) id <LQScrollBtnViewDelegate> delegate;

- (id)initWithTitles:(NSArray *)items;



@end

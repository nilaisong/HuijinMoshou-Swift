//
//  HMActionSheet.h
//  Enterprise
//
//  Created by Aminly on 15/10/15.
//  Copyright © 2015年 NiLaisong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMActionSheet;
@protocol HMActionSheetDelegate <NSObject>

@optional

-(void)backgroundViewTapClick;
-(void)firstBtnClickAction;
-(void)seconBtnClickAction;
@end
@interface HMActionSheet : UIView<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIButton *firstBtn;
@property(nonatomic,strong)UIButton *seconBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)UIView *actionSheetView;
@property(nonatomic,assign)BOOL hasContent;
@property (nonatomic,weak)id<HMActionSheetDelegate>delegate;
-(id)initWithDelegate:(id)delegate;

-(id)initWithDelegate:(id)delegate andTitle:(NSString *)title andContent:(NSString *)content;
-(void)disappear;


@end

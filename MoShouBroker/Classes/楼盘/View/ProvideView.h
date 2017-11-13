//
//  ProvideView.h
//  MoShou2
//
//  Created by strongcoder on 15/12/18.
//  Copyright © 2015年 5i5j. All rights reserved.
//

typedef NS_ENUM(NSInteger, ProvideViewStyle)
{
    
    gongjiStyle,
    shangyeStyle,
    
};

@class ProvideView;

@protocol ProvideViewDelegate <NSObject>

@optional

-(void)yearBtnClickWithSelf:(ProvideView *)provideView;


@end




#import <UIKit/UIKit.h>

@interface ProvideView : UIView<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *monelyTF;   //金额
@property (nonatomic,strong)UIButton *yearBtn;    //年数
@property (nonatomic,strong)UITextField *lilvTF;   //利率
@property (nonatomic,weak)id<ProvideViewDelegate>delegate;

@property (nonatomic,assign)ProvideViewStyle provideViewStyle;

-(id)initWithFrame:(CGRect)frame AndProvideViewStyle:(ProvideViewStyle)provideViewStyle;
@end

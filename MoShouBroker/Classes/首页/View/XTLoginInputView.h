//
//  XTLoginInputView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 16/12/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LoginInputViewType) {
    LoginInputViewPhone,//账号
    LoginInputViewPasswd,//密码
};

@class XTLoginInputView;

typedef void(^LoginInputViewCallBack)(XTLoginInputView* inputView,NSString* text);

typedef void(^LoginInputViewShowTips)(XTLoginInputView* inputView,NSString* message);

@interface XTLoginInputView : UIView

/**
 *  输入视图类型
 **/
@property (nonatomic,assign)LoginInputViewType type;

- (instancetype)initWithFrame:(CGRect)frame Type:(LoginInputViewType)type titleStr:(NSString*)title;

- (instancetype)initWithFrame:(CGRect)frame Type:(LoginInputViewType)type titleStr:(NSString *)title callBack:(LoginInputViewCallBack)callBack;


/**
 显示提示文本，回调
 */
@property (nonatomic,copy)LoginInputViewShowTips showTipsCallBack;

- (void)setEndEditing:(BOOL)end;

- (void)clearText;

@end

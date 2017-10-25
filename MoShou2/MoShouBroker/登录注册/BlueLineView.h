//
//  BlueLineView.h
//  MoShou2
//
//  Created by Aminly on 15/11/23.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BlueLineViewDelegate <NSObject>

@optional
-(void)textFieldDidChange:(UITextField *)textField;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;

@end
typedef NS_ENUM(NSInteger,BLVTextFieldStyle) {
    BLVPHONE,
    BLVVCODE,
    BLVPASSWORD,
};
typedef NS_ENUM(NSInteger,BLVLINEStyle) {
    BLVALLVIEW,
    BLVSPACEVIEW,
};
@interface BlueLineView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UIImageView *icon ;
@property(nonatomic ,strong)UITextField *textfield;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,assign)BOOL isPhoneTextField;
@property(nonatomic ,assign)NSInteger style;
@property(nonatomic,weak)id<BlueLineViewDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame andIconImage:(UIImage *)icon andPlaceholder:(NSString *)placeholder andIsPhoneTF:(BOOL)isPhoneTextField;
-(instancetype)initWithFrame:(CGRect)frame andIconImage:(UIImage *)icon andPlaceholder:(NSString *)placeholder andTextFieldStyle:(BLVTextFieldStyle)tfStyle andLineSyle:(BLVLINEStyle)lineStyle;
-(void)setPhoneText;


@end

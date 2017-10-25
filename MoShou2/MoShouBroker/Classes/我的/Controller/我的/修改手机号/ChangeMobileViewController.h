//
//  ChangeMobileViewController.h
//  MoShouQueke
//
//  Created by Aminly on 15/11/2.
//  Copyright © 2015年  5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "BlueLineView.h"
typedef NS_ENUM(NSInteger,CBTNTAG){
    CVCODEBTN=1000,
    CEYEBTN,
    CRESETBTN,
};
@interface ChangeMobileViewController : BaseViewController<UITextFieldDelegate,BlueLineViewDelegate>{
    BlueLineView *_phoneTF;//手机号
    UITextField *_querenTF;//确认密码
    BlueLineView *_yanzhengTF;//验证码
    UIButton *_getVerifCodeBtn;//获取验证码按钮
    int _countNum;//获取验证码倒计时数字
    NSTimer *countDownTimer;

}

@end

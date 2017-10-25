//
//  RegisterViewController.h
//  MoShou2
//
//  Created by Aminly on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "BlueLineView.h"
typedef NS_ENUM(NSInteger,BTNTAG){
    VCODEBTN=1000,
    EYEBTN,
    REGISTERBTN,
};
@interface RegisterViewController : BaseViewController<BlueLineViewDelegate>

@end

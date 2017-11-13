//
//  FindViewController.h
//  MoShou2
//
//  Created by Aminly on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "BlueLineView.h"
typedef NS_ENUM(NSInteger,FBTNTAG){
    FVCODEBTN=1000,
    FEYEBTN,
    FRESETBTN,
};
@interface FindViewController : BaseViewController<BlueLineViewDelegate>

@end

//
//  CaseTelView.h
//  MoShou2
//
//  Created by strongcoder on 16/9/18.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"
#import "CaseTelList.h"
#import "EasemobConfirmModel.h"

typedef NS_ENUM(NSInteger, CaseTelViewStyle)
{
    ContactFieldStyle,  // 联系案场 电话
    
    OnLineChatStyle    //在线咨询
    
};




typedef void (^GetDidSelectOneCaseTelViewBlock)(CaseTelList *caseTelListMo);

typedef void (^GetDidSelectEasemobConfirmModelBlock)(EasemobConfirmModel *easemobConfirmMo);



@interface CaseTelView : UIView

@property (nonatomic,copy)GetDidSelectOneCaseTelViewBlock DidSelectOneCaseTelViewBlock;
@property (nonatomic,copy)GetDidSelectEasemobConfirmModelBlock DidSelectOneEasemobConfirmBlock;


-(id)initWithBuilding:(Building *)building AndCaseTelViewStyle:(CaseTelViewStyle)caseTelViewStyle;



@end

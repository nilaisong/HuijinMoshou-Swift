//
//  ConfirmUserListView.h
//  MoShou2
//
//  Created by wangzz on 16/9/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmUserInfoObject.h"
//typedef enum {
//    kCustomerConfirm,  //根据楼盘报备客户
//    kBuildConfirm //根据客户报备楼盘
//}confirmType;

typedef void(^selectConfirmUserBlock)(ConfirmUserInfoObject*);
typedef void(^confirmCancelSelectedBlock)();

@interface ConfirmUserListView : UIView

//@property (nonatomic, assign) confirmType  confirmViewType;
@property (nonatomic, strong) NSMutableArray *confirmArray;
@property (nonatomic, strong) ConfirmUserInfoObject  *selectedData;

@property (nonatomic, copy) selectConfirmUserBlock didSelectConfirmUser;
@property (nonatomic, copy) confirmCancelSelectedBlock didCancleConfirmUser;

-(void)selectConfirmUserCellBlock:(selectConfirmUserBlock)ablock;
-(void)concelConfirmUserCellBlock:(confirmCancelSelectedBlock)ablock;

@end

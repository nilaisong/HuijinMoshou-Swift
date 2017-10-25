//
//  CustFollowSelectView.h
//  MoShou2
//
//  Created by wangzz on 2017/3/10.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^followTableViewSelectBlock)(NSString*,NSString*,NSInteger);

@interface CustFollowSelectView : UIView

@property (nonatomic ,strong) UITableView       *tableView;
@property (nonatomic, strong) NSArray           *dataArray;
@property (nonatomic, assign) BOOL              bIsEstate;
@property (nonatomic, assign) NSInteger         selctedRowIndex;
@property (nonatomic, copy) followTableViewSelectBlock    didSelected;

-(void)selectedFollowBlock:(followTableViewSelectBlock)ablock;

@end

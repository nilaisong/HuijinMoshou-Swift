//
//  CustomerSourceViewController.h
//  MoShou2
//
//  Created by manager on 2017/4/20.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomerSourceData.h"

typedef void (^CustomerSourceSelectBlock) (CustomerSourceData*);

@interface CustomerSourceViewController : BaseViewController

@property (nonatomic, strong) CustomerSourceData  *selectedData;
@property (copy, nonatomic)  CustomerSourceSelectBlock didSelectedSourceBlock;

- (void)selectCustomerSourceDataBlock:(CustomerSourceSelectBlock)ablock;

@end

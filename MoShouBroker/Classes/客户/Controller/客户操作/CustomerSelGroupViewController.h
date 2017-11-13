//
//  CustomerSelGroupViewController.h
//  MoShou2
//
//  Created by wangzz on 15/12/16.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFactory+Customer.h"

typedef void (^CustomerSelectGroupBlock) (OptionData*);

@interface CustomerSelGroupViewController : BaseViewController

@property (nonatomic, strong) NSString   *custId;
@property (nonatomic, assign) BOOL       bHasRequest;
@property (copy, nonatomic)  CustomerSelectGroupBlock didSelectedGroupBlock;

- (void)setData:(OptionData *)data andGroupBlock:(CustomerSelectGroupBlock)ablock;

@end

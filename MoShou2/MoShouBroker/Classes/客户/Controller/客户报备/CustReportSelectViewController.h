//
//  CustReportSelectViewController.h
//  MoShou2
//
//  Created by manager on 2017/4/26.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFactory+Customer.h"

typedef void (^CustomerReportSelectBlock) (Customer*);

@interface CustReportSelectViewController : BaseViewController

@property (nonatomic,copy) NSString     *buildingID;

@property(copy,nonatomic)CustomerReportSelectBlock custoemrSelectBlock;//传参block块

-(void)returnCustoemrResultBlock:(CustomerReportSelectBlock)ablock;


@end

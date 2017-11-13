//
//  SeeAboutCarViewController.h
//  MoShou2
//
//  Created by wangzz on 16/8/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFactory+Customer.h"

typedef enum {
    kHomePage,  //添加新客户
    kRecommendRecord//报备新客户
}SeeAboutCarViewControllerType;

@interface SeeAboutCarViewController : BaseViewController

@property (nonatomic, assign) SeeAboutCarViewControllerType  seeViewCtrlType;
@property (nonatomic, strong) SeeAboutTheCarObject           *carObject;

@end

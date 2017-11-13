//
//  PurchaseIntentionViewController.m
//  MoShou2
//
//  Created by manager on 2017/4/20.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "PurchaseIntentionViewController.h"

@interface PurchaseIntentionViewController ()

@end

@implementation PurchaseIntentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleLabel.text = @"购房意向";
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

- (void)hasNetwork
{
    __weak typeof(self) weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

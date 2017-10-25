//
//  XTCustomerProgressStatusImageView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCustomerProgressStatusImageView.h"

@implementation XTCustomerProgressStatusImageView

- (instancetype)initWithStatus:(XTCustomerProgressStatus)status{
    if (self = [super init]) {
        self.status = status;
    }
    return self;
}

- (void)setStatus:(XTCustomerProgressStatus)status{
    _status = status;
    switch (status) {
        case XTCustomerProgressStatusDisable:
            self.image = [UIImage imageNamed:@"gray-circle-6"];
            break;
        case XTCustomerProgressStatusPrepare:
            self.image = [UIImage imageNamed:@"bluecircle-copy-2"];
            break;
        case XTCustomerProgressStatusComplete:
            self.image = [UIImage imageNamed:@"bluecircle"];
            break;
        default:
            self.image = [UIImage imageNamed:@"gray-circle-6"];
            break;
    }
}

@end

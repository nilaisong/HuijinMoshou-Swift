//
//  PageData.m
//  MoShou2
//
//  Created by NiLaisong on 16/4/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "PageData.h"

@implementation PageData
-(BOOL) morePage
{
    if (self.pageNo && self.pageCount) {
        if (self.pageNo.intValue<self.pageCount.intValue) {
            return YES;
        }
    }
    return NO;
}
@end

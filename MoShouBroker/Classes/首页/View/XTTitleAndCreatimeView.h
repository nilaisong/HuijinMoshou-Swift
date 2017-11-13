//
//  XTTitleAndCreatimeView.h
//  MoShou2
//
//  Created by xiaotei's on 16/9/29.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTRecdDescModelItem.h"

@interface XTTitleAndCreatimeView : UIView

@property (nonatomic,strong)XTRecdDescModelItem* descModelItem;

+ (CGFloat)heightWith:(XTRecdDescModelItem*)itemModel;

@end

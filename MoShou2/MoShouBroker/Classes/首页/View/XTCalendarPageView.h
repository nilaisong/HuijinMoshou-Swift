//
//  XTCalendarPageView.h
//  LastCalendar
//
//  Created by xiaotei's on 15/12/11.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTCalendarPage.h"

@interface XTCalendarPageView : UIView <JTCalendarPage>


@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic) NSDate *date;

/*!
 * Must be call if override the class
 */
- (void)commonInit;


- (NSUInteger)weekIndexWithDate:(NSDate*)date;
@end

//
//  XTAppointmentRecordCell.h
//  MoShou2
//
//  Created by xiaotei's on 16/8/10.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAMEFONTSIZE 17
#define PHONEFONTSIZE 14
#define BUILDINGFONTSIZE 14
#define DATEFONTSIZE 12
#define NAMECOLOR @"333333"
#define PHONECOLOR @"777777"
#define BUILDINGCOLOR @"777777"
#define DATECOLOR @"777777"

@class CarRecordListModel;

@interface XTAppointmentRecordCell : UITableViewCell

@property (nonatomic,strong)CarRecordListModel* model;



@end

//
//  XTCustomerProgressCell.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTCustomerProgressStatusImageView.h"

@interface XTCustomerProgressCell : UITableViewCell

+ (instancetype)customerProgressCellWithTableView:(UITableView*)tableView;

@property (strong, nonatomic) IBOutletCollection(XTCustomerProgressStatusImageView) NSArray *statusImageArray;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *blueLineView;

@property (weak, nonatomic) IBOutlet UILabel *progressSubtitleLabelArray;



//cell的进度状态
@property (nonatomic,assign)XTCustomerProgressStatus status;
@end

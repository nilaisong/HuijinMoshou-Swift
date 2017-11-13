//
//  XTCustomerFollowRecordCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/28.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTCustomerFollowRecordCell.h"

@implementation XTCustomerFollowRecordCell

+ (instancetype)customerFollowRecordCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    XTCustomerFollowRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

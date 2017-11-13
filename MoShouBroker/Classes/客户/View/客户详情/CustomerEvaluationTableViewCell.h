//
//  CustomerEvaluationTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerEvaluation.h"

@interface CustomerEvaluationTableViewCell : UITableViewCell

//@property (nonatomic, strong) UILabel   *expectLabel;
@property (nonatomic, strong) UIButton  *evaluationDesBtn;//评级说明
@property (nonatomic, strong) UIButton  *chatBtn;//在线沟通
//@property (nonatomic, strong) UILabel   *timeLabel;


- (id)initWithCustomerEvaluation:(CustomerEvaluation*)data AndIndexPath:(NSIndexPath*)indexPath;

@end

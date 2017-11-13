//
//  XTUserScheduleInfoCell.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/10.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTUserScheduleInfoCell.h"
#import "MobileVisible.h"

@interface XTUserScheduleInfoCell()
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (nonatomic,weak)UIView* lineView;

@end

@implementation XTUserScheduleInfoCell
- (IBAction)addFollowBtnClick:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    if (_callBack) {
        _callBack(weakSelf,XTUserScheduleInfoCellAddFollow);
    }
}
- (IBAction)callBtnClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (_callBack) {
        _callBack(weakSelf,XTUserScheduleInfoCellCallEvent);
    }
}

+ (instancetype)userScheduleInfoCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTUserScheduleInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:className bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (instancetype)userScheduleInfoCellWithTableView:(UITableView *)tableView eventCallBack:(XTUserScheduleInfoCellCallBack)callBack{
    XTUserScheduleInfoCell* cell = [self userScheduleInfoCellWithTableView:tableView];
    cell.callBack = callBack;
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
    [self reloadInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)hiddenCallBtn:(BOOL)hidden{
    _callBtn.hidden = hidden;
}

- (void)reloadInfo{
    if (!_cellFrame)return;
    
    MobileVisible* mobile = [_cellFrame.remindResult.phoneList firstObject];
    _nameLabel.text = _cellFrame.remindResult.name;
    _callBtn.hidden = NO;
    if (mobile) {
        _phoneNumberLabel.text = mobile.hidingPhone;
        if ([mobile.hidingPhone rangeOfString:@"*"].location != NSNotFound) {
            _callBtn.hidden = YES;
        }
    }
    
    if (mobile.totalPhone.length > 0) {
        _phoneNumberLabel.text = mobile.totalPhone;
        _callBtn.hidden = NO;
    }
    
    
}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 0.93f, 0.93f, 0.94f, 1.0f);//线条颜色
//    CGContextSetLineWidth(context, 1);
//    CGContextMoveToPoint(context,0,self.frame.size.height - 1);
//    CGContextAddLineToPoint(context, kMainScreenWidth,self.frame.size.height - 1);
//    CGContextStrokePath(context);
//}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
        _lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return _lineView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}


- (void)setCellFrame:(XTUserScheduleCellFrame *)cellFrame{
    _cellFrame = cellFrame;
    [self reloadInfo];
}

@end



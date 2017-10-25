//
//  XTCustomerInfoHeaderView.m
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTCustomerInfoHeaderView.h"
#import "NSString+Extension.h"

@interface XTCustomerInfoHeaderView()

@property (nonatomic,copy)CustomerInfoHeaderActionResult callBack;

@property (nonatomic,weak)UILabel* nameLabel;

@property (nonatomic,weak)UILabel* sexLabel;

@property (nonatomic,weak)UIButton* clockButton;


@property (nonatomic,weak)UIView* lineView;
@end

@implementation XTCustomerInfoHeaderView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    
}

- (instancetype)initWithCallBack:(CustomerInfoHeaderActionResult)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
    }
    return self;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)customerInfoHeaderViewWithTableView:(UITableView *)tableView{
    
    NSString* className = NSStringFromClass([XTCustomerInfoHeaderView class]);
    
    XTCustomerInfoHeaderView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    
    if (view == nil) {
        [tableView registerClass:[XTCustomerInfoHeaderView class] forHeaderFooterViewReuseIdentifier:className];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    }

    return view;
}

+ (instancetype)customerInfoHeaderViewWithTableView:(UITableView *)tableView eventCallBack:(CustomerInfoHeaderActionResult)callBack{
    XTCustomerInfoHeaderView* view = [self customerInfoHeaderViewWithTableView:tableView];
    
    view.callBack = callBack;

    return view;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize nameSize = [self.nameLabel.text sizeWithfont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(200, 22)];
    self.nameLabel.frame = CGRectMake(16, 15, nameSize.width, 18);
    
    CGSize sexSize = [self.sexLabel.text sizeWithfont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(50, 12)];
    self.sexLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 8, CGRectGetMaxY(_nameLabel.frame) - 12, sexSize.width, 12);
    
    self.clockButton.frame = CGRectMake(kMainScreenWidth - 38, (self.frame.size.height - 22)/2.0, 22, 22);
    
//    self.lineView.frame = CGRectMake(16, 47.5, kMainScreenWidth, 0.5);
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"";
        label.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        [self addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)sexLabel{
    if (_sexLabel == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"";
        label.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        [self addSubview:label];
        _sexLabel = label;
    }
    return _sexLabel;
}

- (UIButton *)clockButton{
    if (_clockButton == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(clockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
        
        _clockButton = button;
    }
    return _clockButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
        [self addSubview:view];
        _lineView = view;
    }
    
    return _lineView;
}

- (void)clockButtonClick:(UIButton*)button{
    if (_callBack) {
        _callBack(CustomerInfoHeaderEventClock);
    }
}

- (void)setDetailModel:(CustomerReportedDetailModel *)detailModel{
    if (detailModel) {
        self.nameLabel.text = detailModel.customerName;
        self.sexLabel.text = detailModel.sex;
    }
}

@end

//
//  XTBuildingNameView.m
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTBuildingNameView.h"
#import "NSString+Extension.h"

@interface XTBuildingNameView()

@property (nonatomic,copy)BuildingNameViewActionResult callBack;

@property (nonatomic,weak)UIImageView* buildingImageView;

@property (nonatomic,weak)UILabel* buildingNameLabel;

@property (nonatomic,weak)UIButton* qrButton;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UIView* lineView2;

@property (nonatomic,weak)UIView* lineView3;

@property (nonatomic,weak)UIView* grayView;

@end

@implementation XTBuildingNameView

+ (instancetype)buildingNameViewWith:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTBuildingNameView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    
    if (!view) {
        [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:className];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    }
    return view;
}

+ (instancetype)buildingNameViewWith:(UITableView *)tableView eventCallBack:(BuildingNameViewActionResult)callBack{
    XTBuildingNameView* view = [XTBuildingNameView buildingNameViewWith:tableView];
    view.callBack = callBack;
    return view;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.lineView2.frame = CGRectMake(0, 0, kMainScreenWidth, 0.5);
    self.grayView.frame = CGRectMake(0, 0.5, kMainScreenWidth, 14);
    self.lineView3.frame = CGRectMake(0, 14.5, kMainScreenWidth, 0.5);
    
    self.buildingImageView.frame = CGRectMake(16, CGRectGetMaxY(self.lineView3.frame) + 15, 13, 15);
    
    
    CGSize size = [self.buildingNameLabel.text sizeWithfont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(250, 16)];
    
    self.buildingNameLabel.frame = CGRectMake(34, CGRectGetMaxY(self.lineView3.frame) + 14, size.width, 16);
    
    
    
    self.lineView.frame = CGRectMake(0,59.5, kMainScreenWidth, 0.5);
//    self.qrButton.frame = CGRectMake(CGRectGetMaxX(_buildingNameLabel.frame) + 4, (self.frame.size.height - 22)/2.0, 22, 22);
}

- (UILabel *)buildingNameLabel{
    if (_buildingNameLabel == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"";
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
        
        _buildingNameLabel = label;
    }
    return _buildingNameLabel;
}

- (UIButton *)qrButton{
    if (!_qrButton) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(qrButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"iconfont_erweima"] forState:UIControlStateNormal];
        [self addSubview:btn];
        
        _qrButton = btn;
    }
    return _qrButton;
}

- (void)qrButtonClick:(UIButton*)button{
    if (_callBack) {
        _callBack(BuildingNameViewEventQR);
    }
}

- (UIImageView *)buildingImageView{
    if (!_buildingImageView) {
        UIImageView* img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"building-icon"]];
        [self addSubview:img];
        _buildingImageView = img;
    }
    return _buildingImageView;
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

- (UIView *)lineView3{
    if (!_lineView3) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
        [self addSubview:view];
        _lineView3 = view;
    }
    
    return _lineView3;
}

- (UIView *)lineView2{
    if (!_lineView2) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
        [self addSubview:view];
        _lineView2 = view;
    }
    
    return _lineView2;
}

- (UIView *)grayView{
    if (!_grayView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        [self addSubview:view];
        
        _grayView = view;
    }
    return _grayView;
}

- (void)setBuilding:(ReportDetailBuilding *)building{
    if (building) {
    self.buildingNameLabel.text = building.buildingName;    
    }
    
}

- (void)setBuildingName:(NSString *)buildingName{
    if (buildingName.length > 0) {
        self.buildingNameLabel.text = buildingName;
    }
}

@end

//
//  XTBuildingHeaderProgressView.m
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTBuildingHeaderProgressView.h"
#import "XTBuildingProgressView.h"
#import "NSString+Extension.h"
#import "ReportDetailProgress.h"
#import "MoshouProgressView.h"

@interface XTBuildingHeaderProgressView()

@property (nonatomic,weak)MoshouProgressView* progressView;

@property (nonatomic,weak)UILabel* statusLabel;

@property (nonatomic,weak)UIButton* openButton;


@property (nonatomic,copy)BuildingHeaderProgressViewActionResult callBack;

@property (nonatomic,copy)UIView* baseLineView;

@end


@implementation XTBuildingHeaderProgressView

+ (instancetype)buildingHeaderProgressViewWith:(UITableView *)tableView{
    NSString* className = NSStringFromClass([self class]);
    
    XTBuildingHeaderProgressView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    
    if (!view) {
        [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:className];
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:className];
    }
    return view;
}

+ (instancetype)buildingHeaderProgressViewWith:(UITableView *)tableView eventCallBack:(BuildingHeaderProgressViewActionResult)callBack{
    XTBuildingHeaderProgressView* view = [self buildingHeaderProgressViewWith:tableView];
    
    view.callBack = callBack;
    
    return view;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    tap.numberOfTapsRequired = 1;
    
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UIGestureRecognizer*)gest{
    if (_callBack) {
        _callBack(BuildingHeaderProgressViewEventTap,_section,nil);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [self.statusLabel.text sizeWithfont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(300, 16)];
    
    self.statusLabel.frame = CGRectMake(15, 15, size.width, 13);
    
    self.openButton.frame = CGRectMake(kMainScreenWidth - 25, 15, 9, 17.5);
    
//    self.progressView.frame = CGRectMake(0, 34, kMainScreenWidth, 100);
    self.baseLineView.frame = CGRectMake(_isLast?0:16, self.frame.size.height - 0.5, kMainScreenWidth, 0.5);
}

- (void)setStatus:(ProgressStatus *)status{
    _status = status;
    [self.progressView removeFromSuperview];
    self.progressView = nil;
    self.progressView.progressDataSource = status;
    
    NSString* stringM = nil;
    switch ([status.status integerValue]) {
        case 0:
            stringM = status.confirmText;
            break;
        case 1:
            stringM = status.guideText;
            break;
        case 2:
            stringM = status.successText;
            break;
        case 3:
            stringM = status.commissionText;
            break;
        default:
            stringM = @"";
            break;
    }
    
    self.statusLabel.text = status.descriptionText;
    
    [self setNeedsDisplay];
}


- (MoshouProgressView *)progressView{
    if (!_progressView) {
        MoshouProgressView *progressView = [[MoshouProgressView alloc] initWithFrame:CGRectMake(0,34, kMainScreenWidth, 90)];
        progressView.progressDataSource = _status;
        [self addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:0.99f green:0.42f blue:0.20f alpha:1.00f];
        [self addSubview:label];
        
        label.text = @"已认购：23号楼2单元211";
        
        _statusLabel = label;
    }
    return _statusLabel;
}

- (UIButton *)openButton{
    if (!_openButton) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [button setBackgroundImage:[UIImage imageNamed:@"icon_jiantou_right"] forState:UIControlStateNormal];
//        [button setTitle:@"展开" forState:UIControlStateNormal];
        
        _openButton = button;
    }
    return _openButton;
}

- (void)openAction:(UIButton*)button{
    if (_callBack) {
        _callBack(BuildingHeaderProgressViewEventTap,_section,button);
    }
    
}

- (void)setIsOpen:(BOOL)isOpen{
    if (isOpen) {
//        [_openButton setTitle:@"收起" forState:UIControlStateNormal];
    }else{
//        [_openButton setTitle:@"展开" forState:UIControlStateNormal];
    }
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    [self setNeedsDisplay];
}

- (UIView *)baseLineView{
    if (!_baseLineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
        [self addSubview:view];
        _baseLineView = view;
    }
    return _baseLineView;
}

@end

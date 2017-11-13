//
//  XTBuildingProgressView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTBuildingProgressView.h"
#import "XTCustomerProgressStatusImageView.h"
#import "ReportDetailProgress.h"

@interface XTBuildingProgressView()

@property (nonatomic,strong)NSArray* statusDotViewArray;

@property (nonatomic,strong)NSArray* lineViewArray;

@property (nonatomic,strong)NSArray* tipsLabelArray;

@property (nonatomic,strong)NSArray* statusLabelArray;

@property (nonatomic,weak)UIView* lineView;

@end

@implementation XTBuildingProgressView

- (void)layoutSubviews{
    CGFloat dotStartX = 25.0f;
    CGFloat dotMargin = (self.frame.size.width - 50 - 14 * 4)/3.0;
    CGFloat dotY = (self.frame.size.height - 14) / 2.0;
    for (int i = 0; i < self.statusDotViewArray.count; i++) {
        XTCustomerProgressStatusImageView* dotView = _statusDotViewArray[i];
        dotView.frame = CGRectMake(dotStartX, dotY, 14, 14);
        dotStartX += dotMargin + 14;
        
        UILabel* label = self.tipsLabelArray[i];
        label.center = CGPointMake(dotView.center.x, dotView.center.y - 31);
        
        UILabel* statusLabel = self.statusLabelArray[i];
        statusLabel.center = CGPointMake(dotView.center.x, dotView.center.y + 31);
        if (i < self.statusLabelArray.count - 1) {
            UIView* view = self.lineViewArray[i];
            view.frame = CGRectMake(CGRectGetMaxX(dotView.frame), (self.frame.size.height - 4.0)/2.0, dotMargin, 4);
        }
    }

    [self lineView];
}


#pragma mark - getter
- (NSArray *)statusDotViewArray{
    if (!_statusDotViewArray) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            XTCustomerProgressStatusImageView* statusImageView = [[XTCustomerProgressStatusImageView alloc]initWithStatus:XTCustomerProgressStatusDisable];
            [arrayM appendObject:statusImageView];
            [self addSubview:statusImageView];
        }
        _statusDotViewArray = arrayM;
    }
    return _statusDotViewArray;
}

- (NSArray *)tipsLabelArray{
    if (!_tipsLabelArray) {
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 17)];
        label1.font = [UIFont systemFontOfSize:17];
        label1.text = @"报备";
        label1.textAlignment = NSTextAlignmentCenter;
        UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 17)];
        label2.font = [UIFont systemFontOfSize:17];
        label2.text = @"带看";
        label2.textAlignment = NSTextAlignmentCenter;
        UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 17)];
        label3.font = [UIFont systemFontOfSize:17];
        label3.text = @"成交";
        label3.textAlignment = NSTextAlignmentCenter;
        UILabel* label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 17)];
        label4.font = [UIFont systemFontOfSize:17];
        label4.text = @"结佣";
        label4.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        [self addSubview:label2];
        [self addSubview:label3];
        [self addSubview:label4];
        _tipsLabelArray = [NSArray arrayWithObjects:label1,label2,label3,label4, nil];
    }
    return _tipsLabelArray;
}

- (NSArray *)statusLabelArray{
    if (!_statusLabelArray) {
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 11)];
        label1.font = [UIFont systemFontOfSize:13];
        label1.textAlignment = NSTextAlignmentCenter;
        UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 11)];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textAlignment = NSTextAlignmentCenter;
        UILabel* label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 11)];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textAlignment = NSTextAlignmentCenter;
        UILabel* label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 11)];
        label4.font = [UIFont systemFontOfSize:13];
        label4.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        [self addSubview:label2];
        [self addSubview:label3];
        [self addSubview:label4];
        _statusLabelArray = [NSArray arrayWithObjects:label1,label2,label3,label4, nil];
    }
    return _statusLabelArray;
}

- (NSArray *)lineViewArray{
    if (!_lineViewArray) {
        NSMutableArray* arrayM = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            UIView* view = [[UIView alloc]init];
            [self addSubview:view];
            view.backgroundColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.88f alpha:1.00f];
            [arrayM appendObject:view];
        }
        _lineViewArray = arrayM;
    }
    return _lineViewArray;
}

- (void)setProgressList:(NSArray *)progressList{
    _progressList = progressList;
    [self reloadInfo];
}

- (void)reloadInfo{
    NSInteger maxComplite = 0;
    for (int i = 0; i < _progressList.count; i++) {
        ReportDetailProgress* status = _progressList[i];
        XTCustomerProgressStatusImageView* statusImageView = self.statusDotViewArray[i];
//        UILabel* tipsLabel = self.tipsLabelArray[i];
        switch (status.status) {
            case 0:
//                tipsLabel.text = status.name;
                break;
            case 1:
                
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                break;
            default:
                break;
        }
        UILabel* statusLabel = self.statusLabelArray[i];
        statusLabel.text = status.statusText;
        int nextSNumber = i + 1;
        if (nextSNumber < _progressList.count) {
            ReportDetailProgress* nextStatus = _progressList[nextSNumber];
            if (nextStatus.status == 4) {
                statusLabel.hidden = YES;
            }
        }
        
        
        switch (status.status) {
            case 0:
            {
                statusLabel.textColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.88f alpha:1.00f];
                statusImageView.status = XTCustomerProgressStatusDisable;
            }
                break;
            case 1:
            {
                statusLabel.textColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.88f alpha:1.00f];
                statusImageView.status = XTCustomerProgressStatusDisable;
            }
                break;
            case 2:
            {
                statusLabel.textColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.88f alpha:1.00f];
                statusImageView.status = XTCustomerProgressStatusPrepare;
            }
                break;
            case 3:
            {
                statusLabel.textColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
                statusImageView.status = XTCustomerProgressStatusPrepare;
            }
                break;
            case 4:
            {
                statusLabel.textColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
                statusImageView.status = XTCustomerProgressStatusComplete;
                maxComplite = i;
            }
                break;
            default:
                break;
        }
    }
    
    for (int i = 0; i < _statusLabelArray.count; i++) {
        switch (i) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                
                break;

            default:
                break;
        }
    }
    
    for (int i = 0; i < 4; i++) {
        switch (i) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            default:
                break;
        }
    }
    
    
    for (int i = 0; i < maxComplite && i < self.lineViewArray.count; i++) {
        UIView * lineView = self.lineViewArray[i];
        lineView.backgroundColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadInfo];
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(16, self.frame.size.height, kMainScreenWidth - 16, 1)];
        _lineView = view;
        view.backgroundColor = [UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f];
        [self addSubview:view];
    }
    return _lineView;
}

@end

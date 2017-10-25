//
//  XTReportMessageView.m
//  MoShou2
//
//  Created by xiaotei's on 16/1/6.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTReportMessageView.h"

#import "ReportDetailMessage.h"

#import "NSString+Extension.h"

@interface XTReportMessageView()

@property (nonatomic,strong)NSArray* messageLabelArray;

@property (nonatomic,strong)NSArray* dateLabelArray;

@property (nonatomic,strong)NSDateFormatter* formatter;

@property (nonatomic,strong)NSDateFormatter* inputFormatter;

@property (nonatomic,weak)UIView* lineView;
@end

@implementation XTReportMessageView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadInfo];
}

- (void)setMessageList:(NSArray *)messageList{
    _messageList = messageList;
    [self reloadInfo];
}

- (void)layoutSubviews{
    CGFloat startX = 16;
    CGFloat startY = 18;
    for (int i = 0; i < _messageLabelArray.count  ; i++) {
        UILabel* labelM = _messageLabelArray[i];
        UILabel* labelD = _dateLabelArray[i];
        CGSize sizeM = [NSString sizeWithString:labelM.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, 14)];
        CGSize sizeD = [NSString sizeWithString:labelD.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGFLOAT_MAX, 14)];
        labelM.frame = CGRectMake(startX, startY, sizeM.width, sizeM.height);
        labelD.frame = CGRectMake(CGRectGetMaxX(labelM.frame) + 5, startY, sizeD.width, sizeD.height);
        startY += 18 + 13;
    }
    self.lineView.frame = CGRectMake(16, self.frame.size.height, kMainScreenWidth - 16, 1);
}

- (void)reloadInfo{
    NSMutableArray* arrayM = [NSMutableArray array];
    NSMutableArray* arrayMD = [NSMutableArray array];
    [self removeAllSubviews];
    for (int i = 0; i < _messageList.count; i++) {
        ReportDetailMessage* message = _messageList[i];
        UILabel* label = [[UILabel alloc]init];
        UILabel* dateLabel = [[UILabel alloc]init];
        label.text = message.content;
        dateLabel.text = [self dateStringWithString:message.datetime];
        label.font = [UIFont systemFontOfSize:14];
        dateLabel.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:0.10f green:0.62f blue:0.92f alpha:1.00f];
        dateLabel.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        [arrayM appendObject:label];
        [arrayMD appendObject:dateLabel];
        [self addSubview:label];
        [self addSubview:dateLabel];
    }
    _messageLabelArray = arrayM;
    _dateLabelArray = arrayMD;
    [self setNeedsLayout];
}

- (NSString*)dateStringWithString:(NSString*)string{
    NSDate* inputDate = [self.inputFormatter dateFromString:string];
    return [NSString stringWithFormat:@"(%@)",[self.formatter stringFromDate:inputDate]];
}

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"MM月dd日 HH:mm";
    }
    return _formatter;
}

- (NSDateFormatter *)inputFormatter{
    if (!_inputFormatter) {
        _inputFormatter = [[NSDateFormatter alloc]init];
        _inputFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return _inputFormatter;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f];
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

@end

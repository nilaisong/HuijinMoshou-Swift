//
//  XTReportNumberCommonContentView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTReportNumberCommonContentView.h"
#import "XTReportNumberCommonView.h"

@interface XTReportNumberCommonContentView()

//常规数据View
@property (nonatomic,strong)NSArray* commonNumberViewArray;


@end

@implementation XTReportNumberCommonContentView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews{
    CGFloat cviewX = 0;
    CGFloat cviewY = 0;
    CGFloat cviewW = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat cviewH = self.frame.size.height / 2;
    for (int i = 0; i < self.commonNumberViewArray.count; i++) {
        UIView* commonView = _commonNumberViewArray[i];
        cviewX = i % 3 * cviewW;
        cviewY = i / 3 * cviewH;
        commonView.frame = CGRectMake(cviewX, cviewY, cviewW, cviewH);
    }
}

- (NSArray *)commonNumberViewArray{
    if (!_commonNumberViewArray || _commonNumberViewArray.count <= 0) {
        NSMutableArray* arrayM = [NSMutableArray array];
        NSArray* arrayTitle = @[@"认筹数",@"认购数",@"签约数",@"带看率",@"成交率"];
        NSArray* arrayNumber = @[@"--",@"--",@"--",@"--",@"--"];
        
        for (int i = 0; i < arrayTitle.count; i++) {
            XTReportNumberCommonView* commonView = [[XTReportNumberCommonView alloc]init];
            commonView.reportTitle = arrayTitle[i];
            commonView.reportNumber = arrayNumber[i];
            commonView.direction = XTTrendDirectionFair;
            [arrayM appendObject:commonView];
            [self addSubview:commonView];
        }
        _commonNumberViewArray = [NSArray arrayWithArray:arrayM];
    }
    return _commonNumberViewArray;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint aPoints[2];//坐标点
    aPoints[0] = CGPointMake(0, 1);//坐标1
    aPoints[1] = CGPointMake(self.frame.size.width,1);//坐标2
    //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
    //points[]坐标数组，和count大小
    //    0.94f green:0.94f blue:0.95f alpha:1.00f
    CGContextSetRGBStrokeColor(context,0.94f,0.94f,0.95f,1.0f);
    CGContextSetLineWidth(context, 1);
    CGContextAddLines(context, aPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)setReportModel:(WorkReportModel *)reportModel{
    _reportModel = reportModel;
    
    for (int i = 0; i < _commonNumberViewArray.count; i++) {
        XTReportNumberCommonView* commonView = _commonNumberViewArray[i];
        if ([commonView.reportTitle isEqualToString:@"成交转化率"]) {
            if([reportModel.completedRate isEqualToString:@""]){
                commonView.reportNumber = @"0.00%";
            }else
                commonView.reportNumber = reportModel.completedRate;
            commonView.direction = reportModel.completedRateChange;
        }else if([commonView.reportTitle isEqualToString:@"认筹数"]){
            commonView.reportNumber = [NSString stringWithFormat:@"%ld",reportModel.rowcardNum];
            commonView.direction = reportModel.rowcardChange;
        }else if([commonView.reportTitle isEqualToString:@"认购数"]){
            commonView.reportNumber = [NSString stringWithFormat:@"%ld",reportModel.subscribeNum];
            commonView.direction = reportModel.subscribeChange;
        }else if([commonView.reportTitle isEqualToString:@"签约数"]){
            commonView.reportNumber = [NSString stringWithFormat:@"%ld",reportModel.signNum];
            commonView.direction = reportModel.signChange;
        }else if([commonView.reportTitle isEqualToString:@"带看转化率"]){
            if([reportModel.completedRate isEqualToString:@""]){
                commonView.reportNumber = @"0.00%";
            }else
            commonView.reportNumber = reportModel.lookRate;
            commonView.direction = reportModel.lookRateChange;
        }


    }
}

@end

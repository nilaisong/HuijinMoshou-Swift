//
//  RecommendationRecordTableView.m
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "RecommendationRecordTableView.h"
#import "RecommendRecordOptionModel.h"
#import "CustomerReportedRecord.h"

#import "CustomerReportedRecord.h"

@interface RecommendationRecordTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UIView* nothingView;

//是否空数据
@property (nonatomic,assign)BOOL noResult;

@end

@implementation RecommendationRecordTableView

+ (instancetype)recommendRecordTableViewWithTableViewStyle:(UITableViewStyle)style eventCallBack:(RecommendationRecordTableViewEventCallBack)callBack{
    return [[self alloc]initWithTableViewStyle:UITableViewStylePlain eventCallBack:callBack];
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style eventCallBack:(RecommendationRecordTableViewEventCallBack)callBack{
    if (self = [super initWithFrame:CGRectZero style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        _callBack = callBack;
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        self.direction = TableViewAnimationDirectionNone;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - datasource
-(NSInteger)numberOfSections{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _noResult = _customerModelArray.count <= 0;
    if (_noResult) {
        return 1;
    }else return _customerModelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* noResultCellKey = @"noResultCellKey";
    if (_noResult) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:noResultCellKey];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noResultCellKey];
            UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-wenjian"]];
            imgView.frame = CGRectMake(0, 0, 98, 111);
            imgView.center = CGPointMake(kMainScreenWidth / 2.0f, (kMainScreenHeight - 116) / 2.0);
            [cell.contentView addSubview:imgView];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 21, kMainScreenWidth, 12)];
            label.text = @"什么都没有~";
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:0.69f green:0.69f blue:0.70f alpha:1.00f];
            [cell.contentView addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    __weak typeof(self) weakSelf = self;
    XTCustomerRecordCell* cell = [XTCustomerRecordCell customerRecordCellWithTableView:tableView eventCallBack:^(XTCustomerRecordCell *cell, BOOL touchQRBtn) {
        if (weakSelf.callBack) {
            weakSelf.callBack(cell,touchQRBtn);
        }
    }];
//    cell.customerName.text = _optionModel.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.customerReportedRecord = _customerModelArray[indexPath.row];
//    cell.customerName.text = record.customerName;

//    cell.textLabel.text = _optionModel.title;
//    cell.detailTextLabel.text = _optionModel.title;
//    CGFloat offsetX = 0;
//    cell.contentView.transform = CGAffineTransformMakeTranslation(offsetX, 0);
//    [UIView animateWithDuration:indexPath.row * 0.2 animations:^{
//        cell.contentView.transform =CGAffineTransformIdentity;
//    }];
//    cell.contentView.backgroundColor = [self randomColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noResult) {
        return NO;
    }else return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noResult) {
        return self.frame.size.height;
    }
    CustomerReportedRecord* model = nil;
    if (_customerModelArray.count > indexPath.row) {
        model = _customerModelArray[indexPath.row];
    }
    return [XTCustomerRecordCell heightWithCustomerModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_noResult) {
        return;
    }
    __weak XTCustomerRecordCell* cell = (XTCustomerRecordCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (_callBack) {
        _callBack(cell,NO);
    }
}

- (void)setOptionModel:(RecommendRecordOptionModel *)optionModel{
    _optionModel = optionModel;
    [self reloadData];
    self.contentOffset = CGPointZero;
}

-(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

- (void)setCustomerModelArray:(NSArray *)customerModelArray{
    _customerModelArray = customerModelArray;
    [self reloadData];
}

- (void)dealloc{

}

@end

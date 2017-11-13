//
//  RecommendationRecordView.m
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "RecommendationRecordView.h"
#import "RecommendRecordOptionModel.h"
#import "CustomerGroup.h"
#import "CustomerCountByGroup.h"


@interface RecommendationRecordView()<TopOptionsViewDelegate>



@end

@implementation RecommendationRecordView

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self topOptionsView];
    [self rrListView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - setter
- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    _rrListView.keyword = keyword;
}

#pragma mark - getter
//顶部选项视图懒加载
-(TopOptionsView *)topOptionsView{
    if (!_topOptionsView) {
        TopOptionsView* topView = [[TopOptionsView alloc]init];
        topView.currentIndex = _currentIndex != 0?_currentIndex:0;
        topView.optionsArray = self.optionsModelArray;
        [self addSubview:topView];
        _topOptionsView = topView;
        _topOptionsView.delegate = self;
        _topOptionsView.frame = CGRectMake(0, 0, self.frame.size.width, OptionItemHeight);
    }
    return _topOptionsView;
}

-(RecommendationRecordListView *)rrListView{
    if (!_rrListView) {
        __weak typeof(self) weakSelf = self;
        RecommendationRecordListView* listView = [[RecommendationRecordListView alloc]initWithEventCallBack:^(RecommendationRecordListViewEvent event, NSInteger listViewIndex, XTCustomerRecordCell *cell, BOOL touchQRBtn) {
            switch (event) {
                case RecommendationRecordListViewEventSwitchListView:
                {
                    weakSelf.topOptionsView.currentIndex = listViewIndex;
//                    if ([weakSelf.delegate respondsToSelector:@selector(recommendRecordView:requestOptionsModels:)]) {
//                        [weakSelf.delegate recommendRecordView:weakSelf requestOptionsModels:weakSelf.optionsModelArray];
//                    }
                }
                    break;
                case RecommendationRecordListViewEventSelectCell:{
                    if (touchQRBtn&&[weakSelf.delegate respondsToSelector:@selector(recommendRecordView:didTouchQRBtn:)]) {
                        [weakSelf.delegate recommendRecordView:weakSelf didTouchQRBtn:cell];
                    }else if([weakSelf.delegate respondsToSelector:@selector(recommendRecordView:didSelectedCell:)]){
                        [weakSelf.delegate recommendRecordView:weakSelf didSelectedCell:cell];
                    }
                }
                    break;
                case RecommendationRecordListViewEventNoNetWorkConnection:{
                    if ([weakSelf.delegate respondsToSelector:@selector(recommendRecordView:netWorkNoConnection:)]) {
                        [weakSelf.delegate recommendRecordView:weakSelf netWorkNoConnection:nil];
                    }
                }
                    break;
                case RecommendationRecordListViewEventRequestStart:{
                    if ([weakSelf.delegate respondsToSelector:@selector(recommendRecordView:startRqeust:)]) {
                        [weakSelf.delegate recommendRecordView:weakSelf startRqeust:nil];
                    }
                }
                    break;
                case RecommendationRecordListViewEventRequestEnd:{
                    if ([weakSelf.delegate respondsToSelector:@selector(recommendRecordView:stopRequest:)]) {
                        [weakSelf.delegate recommendRecordView:weakSelf stopRequest:nil];
                    }
                }
                    break;
                default:
                    break;
            }
            
        }];
        
//        listView.optionsArray = self.optionsModelArray;
        
        
        [self addSubview:listView];
        
        _rrListView = listView;
        _rrListView.frame = CGRectMake(0, OptionItemHeight, self.frame.size.width, self.frame.size.height - OptionItemHeight);

    }
    return _rrListView;
}

- (NSArray *)optionsModelArray{
    if (!_optionsModelArray) {
        __block NSMutableArray* optionArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            RecommendRecordOptionModel* model = [[RecommendRecordOptionModel alloc]init];
            model.title = @"";
            model.dataNumber = 0;
            [optionArray appendObject:model];
        }

        __weak typeof(self) weakSelf = self;
        if ([_delegate respondsToSelector:@selector(recommendRecordView:requestOptionsModels:)]) {
            [_delegate recommendRecordView:weakSelf requestOptionsModels:optionArray];
        }
        
        _optionsModelArray = optionArray;
        
    }
    return _optionsModelArray;
}

#pragma mark - topOptionsViewDelegate
-(void)topOptionsView:(TopOptionsView *)opView didSelectedOptions:(NSInteger)index{
    _rrListView.currentIndex = index;
//    __weak typeof(self) weakSelf = self;
//    if ([_delegate respondsToSelector:@selector(recommendRecordView:requestOptionsModels:)]) {
//        [_delegate recommendRecordView:weakSelf requestOptionsModels:weakSelf.optionsModelArray];
//    }
}

- (void)topOptionsView:(TopOptionsView *)opView requestOptionsWithCurrentIndeex:(NSInteger)index{
    __weak typeof(self) weakSelf = self;
    if ([_delegate respondsToSelector:@selector(recommendRecordView:requestOptionsModels:)]) {
        [_delegate recommendRecordView:weakSelf requestOptionsModels:_optionsModelArray];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
//    _rrListView.currentIndex = currentIndex;

}

- (void)dealloc{

}

@end

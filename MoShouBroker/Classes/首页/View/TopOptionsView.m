//
//  TopOptionsView.m
//  RecommendationRecord
//
//  Created by xiaotei's on 15/11/18.
//  Copyright © 2015年 xiaotei's. All rights reserved.
//

#import "TopOptionsView.h"
#import "RecommendationRecordTableView.h"
#import "RecommendRecordOptionModel.h"

#import "TopOptionItemView.h"

@interface TopOptionsView()

//承载滚动视图
@property (nonatomic,weak)UIScrollView* contentView;
 
@property (nonatomic,weak)UIButton* currentBtn;

@property (nonatomic,weak)UIView* bottomBlueView;

@property (nonatomic,strong)NSArray* topOptionItemArray;

@end

@implementation TopOptionsView

+ (instancetype)optionsViewWithArray:(NSArray *)options{
    return [[self alloc]initWithOptionsArray:options];
}

- (instancetype)initWithOptionsArray:(NSArray *)options{
    if (self = [super init]) {
        _optionsArray = options;
       
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
     self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    CGFloat OptionItemX = 0;
    CGFloat OptionItemY = 0;
    
    for (int i = 0; i < _optionsArray.count; i++) {
        TopOptionItemView* item = self.topOptionItemArray[i];
        
        OptionItemX = OptionMargin * 0.5;
        OptionItemY = 0;
        
        CGFloat itemW = [item.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : item.titleLabel.font} context:nil].size.width;
        if(itemW <= 50){
            itemW = 50.0f;
        }
        if (i == 0) {
        }else{
           TopOptionItemView* laterItem = self.topOptionItemArray[i - 1];
            OptionItemX = CGRectGetMaxX(laterItem.frame) + OptionMargin;
        }
        item.frame = CGRectMake(OptionItemX, OptionItemY, itemW, OptionItemHeight);
        
        
        item.optionModel = _optionsArray[i];
        
        [item addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        item.tag = i;
        if (i == _currentIndex) {
            item.selected = YES;
            _currentBtn = item;
            [_delegate topOptionsView:self didSelectedOptions:_currentIndex];
        }
    }
    [self bottomBlueView];
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, OptionItemHeight);
    TopOptionItemView* lastItem = [self.topOptionItemArray lastObject];
    _contentView.contentSize = CGSizeMake(CGRectGetMaxX(lastItem.frame) + OptionMargin * 0.5, 0);
}

-(void)itemTouch:(UIButton*)btn{
//    NSLog(@"%ld",btn.tag);
    if (btn.tag == _currentBtn.tag)return;
    _currentBtn.selected = NO;
    btn.selected = YES;
    self.currentIndex = btn.tag;
    _currentBtn = btn;
    if ([_delegate respondsToSelector:@selector(topOptionsView:didSelectedOptions:)]) {
        [_delegate topOptionsView:self didSelectedOptions:btn.tag];
    }
}

#pragma mark - setter 
//在赋予新值后，刷新视图
- (void)setOptionsArray:(NSArray *)optionsArray{
    _optionsArray = optionsArray;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - getter

- (NSArray *)topOptionItemArray{
    if (!_topOptionItemArray || _topOptionItemArray.count <= 0) {
        NSMutableArray* arrayM = [NSMutableArray array];
            for (int i = 0; i < 10; i++) {
                TopOptionItemView* item = [[TopOptionItemView alloc]init];
                [self.contentView addSubview:item];
                [item addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
                item.tag = i;
                if (i == _currentIndex) {
                    item.selected = YES;
                    _currentBtn = item;
                    [_delegate topOptionsView:self didSelectedOptions:_currentIndex];
                }
                [arrayM appendObject:item];
        }
        _topOptionItemArray = arrayM;
    }
    return _topOptionItemArray;
}

-(UIScrollView *)contentView{
    if (!_contentView) {
        UIScrollView* contentView = [[UIScrollView alloc]init];
        contentView.showsVerticalScrollIndicator = NO;
        contentView.showsHorizontalScrollIndicator = NO;
//        contentView.bounces = NO;
        _contentView = contentView;
        [self addSubview:contentView];
    }
    return _contentView;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if ([_delegate respondsToSelector:@selector(topOptionsView:requestOptionsWithCurrentIndeex:)]) {
        [_delegate topOptionsView:self requestOptionsWithCurrentIndeex:_currentIndex];
    }
    NSAssert(currentIndex >= 0 && currentIndex < 1000, @"索引值不合法");
    UIButton* selectedBtn = nil;
    for (UIButton* btn in _contentView.subviews) {
        if([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == currentIndex) {
                selectedBtn = btn;
            }
        }
    }
//    NSLog(@"%ld",currentIndex);
    if (_currentBtn.tag == selectedBtn.tag || _currentIndex < 0 || _currentIndex > _optionsArray.count - 1) return;
    _currentBtn.selected = NO;
    selectedBtn.selected = YES;
    _currentBtn = selectedBtn;
    _currentIndex = currentIndex;
    
    CGFloat offsetX = _currentBtn.center.x - _contentView.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    if (offsetX > (_contentView.contentSize.width - _contentView.size.width)) {
        offsetX = _contentView.contentSize.width - _contentView.size.width;
    }

    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.contentOffset = CGPointMake(offsetX, 0);
        [self bottomBlueView];
    }];
}

- (UIView *)bottomBlueView{
    if (!_bottomBlueView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.11f green:0.62f blue:0.92f alpha:1.00f];
        [self.contentView addSubview:view];
        _bottomBlueView = view;
    }
    _bottomBlueView.frame = CGRectMake(_currentBtn.frame.origin.x, self.frame.size.height - 3.5, _currentBtn.width, 3);
    
    return _bottomBlueView;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.47, 0.47, 0.47, 1.0);//线条颜色
    CGContextMoveToPoint(context, 0, self.frame.size.height - 0.5);
    CGContextSetLineWidth(context, 0.5);
    CGContextAddLineToPoint(context, self.frame.size.width,self.frame.size.height - 0.5);
    CGContextStrokePath(context);
}


- (void)dealloc{

}

@end

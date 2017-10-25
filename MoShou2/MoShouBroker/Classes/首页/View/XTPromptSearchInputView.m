//
//  XTPromptSearchInputView.m
//  MoShou2
//
//  Created by xiaotei's on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTPromptSearchInputView.h"
#import "FMDBSource+Broker.h"

@interface XTPromptSearchInputView() <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,weak)UITableView* historyTableView;

@end


@implementation XTPromptSearchInputView



- (instancetype)initWithFrame:(CGRect)frame selectBlock:(HistoryInputViewSelectCallBack)callBack{
    if (self = [super initWithFrame:frame]) {
        _callBack = callBack;
        
    }
    return self;
}

+ (instancetype)historyViewWithFrame:(CGRect)frame selectBlock:(HistoryInputViewSelectCallBack)callBack{
    return [[self alloc]initWithFrame:frame selectBlock:callBack];
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.promptsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellKey = NSStringFromClass([self class]);
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey];
    }
    
    cell.textLabel.text = self.promptsArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= self.promptsArray.count) {
        if (_callBack) {
            _callBack(indexPath.row,self.promptsArray[indexPath.row]);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HistoryCellHeight;
}

- (void)layoutSubviews{
    
}

- (UITableView *)historyTableView{
    if (!_historyTableView) {
        UITableView* tableView = [[UITableView alloc]init];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.bounces = YES;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self addSubview:tableView];
        
        _historyTableView = tableView;
    }
    return _historyTableView;
}

- (void)setPromptsArray:(NSArray *)promptsArray{
    _promptsArray = promptsArray;
    [self.historyTableView reloadData];
    [self setNeedsLayout];
    self.historyTableView.frame = CGRectMake(0, 0, self.frame.size.width, _promptsArray.count * HistoryCellHeight);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.superview endEditing:YES];
}

@end

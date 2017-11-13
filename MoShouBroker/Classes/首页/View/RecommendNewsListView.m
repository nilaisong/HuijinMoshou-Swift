//
//  RecommendNewsListView.m
//  MoShou2
//
//  Created by xiaotei's on 16/9/27.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "RecommendNewsListView.h"
#import "XTOperationModelItem.h"
#import "XTListOperationCell.h"
#import "XTButton.h"

@interface RecommendNewsListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UILabel* titleLabel;

@property (nonatomic,weak)XTButton* moreButton;

@property (nonatomic,weak)UITableView* tableView;

@property (nonatomic,copy)RecommendNewsListViewCallBack callBack;

@property (nonatomic,weak)UIView* baffleView;//挡板视图

@end

@implementation RecommendNewsListView

- (instancetype)initWithCallBack:(RecommendNewsListViewCallBack)callBack{
    if (self = [super init]) {
        _callBack = callBack;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.baffleView.frame = CGRectMake(0, 0, kMainScreenWidth, 10);
    self.titleLabel.frame = CGRectMake(12.5, _baffleView.bottom + 15, 100, 16);
    CGFloat mWidth = 70.0f* SCALE6;
    self.moreButton.frame = CGRectMake(self.width - mWidth - 16, _baffleView.bottom + 14, mWidth, 18);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 12.5, self.width,self.height - CGRectGetMaxY(_titleLabel.frame) - 12.5);
}

- (UIView *)baffleView{
    if (!_baffleView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
        view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, kMainScreenWidth, 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        [view addSubview:line1];
        [view addSubview:line2];
        [self addSubview:view];
        _baffleView = view;
    }
    return _baffleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel* lab = [[UILabel alloc]init];
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
        lab.font = [UIFont boldSystemFontOfSize:15];
        lab.text = @"相关推荐";
        [self addSubview:lab];
        _titleLabel = lab;
    }
    return _titleLabel;
}

- (XTButton *)moreButton{
    if (!_moreButton) {
        XTButton* btn = [[XTButton alloc]initWithNormalImage:@"contentoperation-more" highlightImage:@"contentoperation-more" imageFrame:CGRectMake(60.0 * SCALE6, 2, 14, 14)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        //        [btn setImage:[UIImage imageNamed:@"iconfont-jiantou-2-拷贝"] forState:UIControlStateNormal];
        //        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
        [btn setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:btn];
        _moreButton = btn;
    }
    return _moreButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc]init];
        [self addSubview:tableView];
        _tableView = tableView;
        [tableView registerClass:[XTListOperationCell class] forCellReuseIdentifier:NSStringFromClass([XTListOperationCell class])];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relateRecdArray.count > 3?3:_relateRecdArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* className = NSStringFromClass([XTListOperationCell class]);
    XTListOperationCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[XTListOperationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    cell.textLabel.text = @"";
    if (self.relateRecdArray.count > indexPath.row) {
        XTOperationModelItem* model = [_relateRecdArray objectForIndex:indexPath.row];
        if (model) {
            cell.titleStr = model.title;
            cell.itemModel = model;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineState = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f * SCALE6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_relateRecdArray.count > indexPath.row && _callBack) {
        _callBack(self,RecommendNewsListViewEventClick,_relateRecdArray[indexPath.row]);
    }
}

- (void)setRelateRecdArray:(NSArray *)relateRecdArray{
    _relateRecdArray = relateRecdArray;
    self.moreButton.hidden = _relateRecdArray.count <= 3;
    [self.tableView reloadData];
}

+ (CGFloat)heightWithRelateArray:(NSArray *)modelArray{
    if (modelArray.count > 3) {
        return 3 * 105 * SCALE6 + 53.5;
    }
    return 105 * SCALE6 * modelArray.count + 53.5;
}

- (void)buttonClick:(UIButton*)btn{
    if (_callBack) {
        _callBack(self,RecommendNewsListViewEventMore,nil);
    }
}

@end

//
//  CustFollowSelectView.m
//  MoShou2
//
//  Created by wangzz on 2017/3/10.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "CustFollowSelectView.h"
#import "CustomerFollowData.h"

@interface CustFollowSelectView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIImageView *imgView;
@end

@implementation CustFollowSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self layoutUI];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    if (_bIsEstate) {
        _imgView.left = self.width/2+30;
    }else
    {
        _imgView.left = 30;
    }
    [_tableView reloadData];
}

- (void)layoutUI
{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 11, 7)];
    [_imgView setImage:[UIImage imageNamed:@"icon_alertrect"]];
    [self addSubview:_imgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _imgView.bottom, self.width, self.height-11) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView.layer setMasksToBounds:YES];
    [_tableView.layer setCornerRadius:3];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *line = nil;
    UILabel *nameLabel = nil;
//    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 32.5, _tableView.width, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"d6d6d6"];
        [cell.contentView addSubview:line];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.width-30, 32.5)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = NAVIGATIONTITLE;
        nameLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:nameLabel];
    if (indexPath.row == _selctedRowIndex) {
        nameLabel.textColor = BLUEBTBCOLOR;
    }
        
        cell.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    if (indexPath.row == _dataArray.count-1) {
        line.hidden = YES;
    }
    CustomerFollowData *data = nil;
    if (_dataArray.count>indexPath.row) {
        data = (CustomerFollowData*)[_dataArray objectForIndex:indexPath.row];
    }
    if (_bIsEstate) {
        nameLabel.text = data.estateName;
    }else
    {
        nameLabel.text = data.userName;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerFollowData *data = (CustomerFollowData*)[_dataArray objectForIndex:indexPath.row];
    if (_bIsEstate) {
        _didSelected(data.estateId,data.estateName,indexPath.row);
    }else
    {
        _didSelected(data.userId,data.userName,indexPath.row);
    }
}

-(void)selectedFollowBlock:(followTableViewSelectBlock)ablock
{
    _didSelected = ablock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

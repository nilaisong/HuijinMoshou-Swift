//
//  ConfirmUserListView.m
//  MoShou2
//
//  Created by wangzz on 16/9/19.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "ConfirmUserListView.h"
#import "ConfirmUserListTableViewCell.h"


#define widthScale  710.0/750
#define heightScale 1110.0/1333
#define BUTTON_HEIGHT                  30               //按钮高

@interface ConfirmUserListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView          *customerView;
@property (nonatomic, strong) UITableView     *tableView;
//@property (nonatomic, strong) UILabel         *titleL;
@property (nonatomic, strong) NSIndexPath     *oldIndex;



@end

@implementation ConfirmUserListView
@synthesize customerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.3];
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    
    customerView = [[UIView alloc] initWithFrame:CGRectMake(self.width*(1-widthScale)/2, self.height*(1-heightScale)/2, self.width*widthScale, self.height*heightScale)];//(self.width*(1-widthScale)/2, self.height*(1-heightScale)/2, self.width*widthScale, MIN(self.height*heightScale, 50+66*_confirmArray.count))
    customerView.backgroundColor = BACKGROUNDCOLOR;
    [customerView.layer setCornerRadius:10.0];
    [customerView.layer setMasksToBounds:YES];
    [self addSubview:customerView];
    
//    customerView.centerY = (self.height-20)/2;
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 40, 40)];
    [cancleBtn setImage:[UIImage imageNamed:@"back_Button"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(toggleCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [customerView addSubview:cancleBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(customerView.width/2-90, 7, 180, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
//    if (_confirmViewType == kCustomerConfirm) {
        titleLabel.text = @"选择确客专员";
//    }
//    else if (_confirmViewType == kBuildConfirm)
//    {
//        titleLabel.text = @"选择确客";
//    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    titleLabel.textColor =NAVIGATIONTITLE;
    [customerView addSubview:titleLabel];
    
    [customerView addSubview:[self createLineView:49.5 WithX:0]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, customerView.width, customerView.height - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [customerView addSubview:self.tableView];
    
}

-(void)setConfirmArray:(NSMutableArray *)confirmArray
{
    if (_confirmArray != confirmArray) {
        _confirmArray = confirmArray;
    }
    
//    customerView.height = MIN(self.height*heightScale, 50+66*_confirmArray.count);
//    self.tableView.height = MIN(self.height*heightScale, 50+66*_confirmArray.count)-50;
//    customerView.centerY = (self.height-20)/2;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _confirmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ConfirmUserInfoObject *confirm = nil;
    if (_confirmArray.count>indexPath.row) {
        confirm = [_confirmArray objectForIndex:indexPath.row];
    }
    
    UIView *lineView = nil;

    ConfirmUserListTableViewCell *cell = [[ConfirmUserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    lineView = [self createLineView:66-0.5 WithX:10];
    lineView.tag = 100;
//    if (indexPath.row != _confirmArray.count-1) {
        [cell.contentView addSubview:lineView];
//    }
    
    cell.confirmNameL.text = confirm.confirmUserName;
    cell.confirmPhoneL.text = confirm.confirmUserMobile;
    if (_selectedData != nil) {
        if ([_selectedData.confirmUserId isEqualToString:confirm.confirmUserId]) {
            cell.selectImgView.hidden = NO;
            _oldIndex = indexPath;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_oldIndex];
    oldCell.imageView.hidden = YES;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.hidden = NO;
    
    ConfirmUserInfoObject *confirm = nil;
    if (_confirmArray.count>indexPath.row) {
        confirm = [_confirmArray objectForIndex:indexPath.row];
    }
    
    _didSelectConfirmUser(confirm);
}

- (void)toggleCancleButton:(UIButton*)sender
{
    _didCancleConfirmUser();
    [self removeFromSuperview];
}

-(void)selectConfirmUserCellBlock:(selectConfirmUserBlock)ablock
{
    self.didSelectConfirmUser = ablock;
}

-(void)concelConfirmUserCellBlock:(confirmCancelSelectedBlock)ablock
{
    self.didCancleConfirmUser = ablock;
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y WithX:(CGFloat)x
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.width*widthScale-x, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

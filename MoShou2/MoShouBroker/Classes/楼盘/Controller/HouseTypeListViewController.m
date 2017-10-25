//
//  HouseTypeListViewController.m
//  MoShou2
//
//  Created by wangzz on 2016/12/15.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "HouseTypeListViewController.h"
#import "HouseTypeViewController.h"
#import "HouseTypeListTableViewCell.h"
#import "DataFactory+User.h"
@interface HouseTypeListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger    currentIndex;
}
@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) UIScrollView       *headerView;
@property (nonatomic, strong) NSMutableArray     *itemTitleArray;
@property (nonatomic, strong) NSMutableArray     *houseTypeArray;
@property (nonatomic, strong) NSMutableArray     *btnItemArray;

@end

@implementation HouseTypeListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = [NSString stringWithFormat:@"全部户型 (%zd)",_building.roomLayoutArray.count];
    _itemTitleArray = [[NSMutableArray alloc] init];
    _houseTypeArray = [[NSMutableArray alloc] init];
    _btnItemArray = [[NSMutableArray alloc] init];
    currentIndex = 0;
    [self handleHouseTypeList];
    
    [self createHeaderView];
    
    [self createTableView];
    
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_HXLB" andPageId:@"PAGE_LPXQ"];;
    // Do any additional setup after loading the view.
}


- (void)handleHouseTypeList
{
    NSMutableArray *tempArr1 = [[NSMutableArray alloc] init];
    NSMutableArray *tempArr2 = [[NSMutableArray alloc] init];
    NSMutableArray *tempArr3 = [[NSMutableArray alloc] init];
    NSMutableArray *tempArr4 = [[NSMutableArray alloc] init];
    NSMutableArray *tempArr5 = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:_building.roomLayoutArray];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"bedroomNum" ascending:YES], nil];
    [array sortUsingDescriptors:sortDescriptors];
    
    [_itemTitleArray appendObject:@"全部"];
    for (int i=0; i<array.count; i++) {
        RoomLayout *houseType = (RoomLayout*)[array objectForIndex:i];
        NSString *tempStr = @"";
        if ([houseType.bedroomNum integerValue] > 0 && [houseType.bedroomNum integerValue] < 5) {
            tempStr = [NSString stringWithFormat:@"%@居",houseType.bedroomNum];
            if (![_itemTitleArray containsObject:tempStr]) {
                [_itemTitleArray appendObject:tempStr];
            }
            if ([houseType.bedroomNum isEqualToString:@"1"]) {
                [tempArr1 appendObject:houseType];
            }else if ([houseType.bedroomNum isEqualToString:@"2"]) {
                [tempArr2 appendObject:houseType];
            }else if ([houseType.bedroomNum isEqualToString:@"3"]) {
                [tempArr3 appendObject:houseType];
            }else if ([houseType.bedroomNum isEqualToString:@"4"]) {
                [tempArr4 appendObject:houseType];
            }else
            {
                [tempArr1 appendObject:houseType];
            }
        }else if ([houseType.bedroomNum integerValue] >= 5)
        {
            tempStr = @"5居及以上";
            if (![_itemTitleArray containsObject:tempStr]) {
                [_itemTitleArray appendObject:tempStr];
            }
            [tempArr5 appendObject:houseType];
        }
    }
    [_houseTypeArray appendObject:_building.roomLayoutArray];
    if (tempArr1.count>0) {
        [_houseTypeArray appendObject:tempArr1];
    }
    if (tempArr2.count>0) {
        [_houseTypeArray appendObject:tempArr2];
    }
    if (tempArr3.count>0) {
        [_houseTypeArray appendObject:tempArr3];
    }
    if (tempArr4.count>0) {
        [_houseTypeArray appendObject:tempArr4];
    }
    if (tempArr5.count>0) {
        [_houseTypeArray appendObject:tempArr5];
    }
}

- (void)createHeaderView
{
    _headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, kMainScreenWidth, 0)];
    _headerView.showsHorizontalScrollIndicator = NO;
    _headerView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:_headerView];
    CGFloat height = 0;
    CGFloat width = 0;
    for (int i=0; i<_itemTitleArray.count; i++) {
        CGSize btnSize = [[_itemTitleArray objectForIndex:i] sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10+width, 12.5, btnSize.width+30, btnSize.height+10)];
        [btn setTitle:[_itemTitleArray objectForIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:BACKGROUNDCOLOR];
        btn.titleLabel.font = FONT(13);
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:3];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"888888"].CGColor];
        [btn.layer setBorderWidth:0.5];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(toggleFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
        
        if (i==currentIndex) {
            btn.selected = YES;
            [btn.layer setBorderColor:BLUEBTBCOLOR.CGColor];
            [btn setBackgroundColor:BLUEBTBCOLOR];
        }
        
        [_btnItemArray appendObject:btn];
        
        height = 25+btn.height;
        width = btn.right;
    }
    _headerView.height = height;
    [self.view addSubview:[self createLineView:_headerView.bottom-0.5 withX:0 withColor:LINECOLOR]];
    _headerView.contentSize = CGSizeMake(width+10, height);
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kMainScreenWidth, self.view.bounds.size.height-_headerView.bottom) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:VIEWBGCOLOR];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 1;
    num = ((NSArray*)[_houseTypeArray objectForIndex:currentIndex]).count;
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseTypeListTableViewCell *cell = [[HouseTypeListTableViewCell alloc] init];
    RoomLayout *houseType = (RoomLayout*)[((NSArray*)[_houseTypeArray objectForIndex:currentIndex]) objectForIndex:indexPath.row];
    if (houseType.thumUrl.length>0) {
        [cell.picImgView setImageWithUrlString:houseType.thumUrl placeholderImage:[UIImage imageNamed:@"默认图片xiao"]];
    }else
    {
        [cell.picImgView setImage:[UIImage imageNamed:@"默认图片xiao"]];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫 %@",houseType.bedroomNum,houseType.livingroomNum,houseType.toiletNum,houseType.saleArea];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@  %@",houseType.name,houseType.decoration];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",houseType.totalPrice];
    if (indexPath.row < ((NSArray*)[_houseTypeArray objectForIndex:currentIndex]).count-1) {
        [cell.contentView addSubview:[self createLineView:104.5 withX:10 withColor:VIEWBGCOLOR]];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[DataFactory sharedDataFactory] addLogWithEventId:@"EVENT_HXLB_HXXQ" andPageId:@"PAGE_LPXQ"];
    
    
    RoomLayout *houseType = (RoomLayout*)[((NSArray*)[_houseTypeArray objectForIndex:currentIndex]) objectForIndex:indexPath.row];
    HouseTypeViewController *detailVC = [[HouseTypeViewController alloc] init];
    detailVC.vcType = kAllBuilding;
    detailVC.building = _building;
    for (int i=0; i<_building.roomLayoutArray.count; i++) {
        RoomLayout *roomType = (RoomLayout*)[_building.roomLayoutArray objectForIndex:i];
        if ([houseType.layoutId isEqualToString:roomType.layoutId]) {
            detailVC.currentIndex = i;
        }
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)toggleFilterButton:(UIButton*)sender
{
    NSInteger btnTag = sender.tag - 1000;
    for (UIButton *item in _btnItemArray) {
        item.selected = NO;
        [item setBackgroundColor:BACKGROUNDCOLOR];
        [item.layer setBorderColor:[UIColor colorWithHexString:@"888888"].CGColor];
        if (item == sender) {
            sender.selected = YES;
            [sender.layer setBorderColor:BLUEBTBCOLOR.CGColor];
            [sender setBackgroundColor:BLUEBTBCOLOR];
            currentIndex = btnTag;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x withColor:(UIColor*)color
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    line.backgroundColor = color;
    return line;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

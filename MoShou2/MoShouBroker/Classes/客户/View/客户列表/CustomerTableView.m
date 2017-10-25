//
//  CustomerTableView.m
//  MoShou2
//
//  Created by wangzz on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "CustomerTableView.h"
#import "CustomerListTableViewCell.h"
#import "CustomerEmptyView.h"
#import "ChineseString.h"
#import "ChineseToPinyin.h"
#import "NSString+Extension.h"
#import "UserData.h"
#import "MobileVisible.h"

@interface CustomerTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath    *telIndexPath;
    CGFloat        totalRowHeight;
    NSInteger      _customerType;
}
@property (nonatomic, strong) NSMutableArray *firstLetterArray;
@property (nonatomic, strong) NSMutableArray *addressSortedArray;//根据索引存储联系人数据

@property (nonatomic, strong) NSMutableArray *lastStatusArray;//客户是否被选中的状态记录数组，初始状态均为0
@property (nonatomic, strong) CustomerEmptyView *emptyView;
@property (nonatomic, strong) UIView       *emptyPageView;
@property (nonatomic, assign) NSInteger    tableType;
@property (nonatomic, strong) Customer     *customer;
@property (nonatomic, retain) NSString         *telString;
@property (nonatomic, assign) BOOL         hasShop;

@property (nonatomic, strong) NSMutableArray   *showVisitInfoArray;
@property (nonatomic, strong) NSMutableDictionary *visitInfoData;

@property (nonatomic, strong) NSMutableArray   *showConfirmInfoArray;
@property (nonatomic, strong) NSMutableDictionary *confirmInfoData;

@end

@implementation CustomerTableView
@synthesize firstLetterArray;
@synthesize addressSortedArray;
@synthesize emptyPageView;
@synthesize statusArray;
@synthesize lastStatusArray;
@synthesize customer;

@synthesize showVisitInfoArray;
@synthesize visitStatusArray;

@synthesize showConfirmInfoArray;
@synthesize confirmStatusArray;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithCustomer:(NSArray*)addressBookTemp ByCustomerType:(NSInteger)customerType AndFrame:(CGRect)frame tableType:(NSInteger)tableType withHasShop:(BOOL)hasShop{
    if (self = [super init]) {
        self.backgroundColor = BACKGROUNDCOLOR;;//[UIColor whiteColor];
        _tableType = tableType;
        _customerType = customerType;
        _hasShop = hasShop;
        addressSortedArray = [[NSMutableArray alloc] init];
        firstLetterArray = [[NSMutableArray alloc] init];
        showVisitInfoArray = [[NSMutableArray alloc] init];
        _visitInfoData = [[NSMutableDictionary alloc] init];
        showConfirmInfoArray = [[NSMutableArray alloc] init];
        _confirmInfoData = [[NSMutableDictionary alloc] init];
        
        totalRowHeight = 100 * addressBookTemp.count;
        if (_tableType) {
            statusArray = [[NSMutableArray alloc] init];
            lastStatusArray = [[NSMutableArray alloc] init];
            totalRowHeight = 70 * addressBookTemp.count;
        }
        customer = [[Customer alloc] init];
        [self sortDataWithSourceData:addressBookTemp];
        
        self.frame = frame;
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionIndexColor=[UIColor colorWithHexString:@"1b9fea"];
//        self.sectionIndexBackgroundColor = [UIColor clearColor];
        
        [self initHeaderView];
        
        if (_tableType != 0) {
            if (addressBookTemp.count==0 || addressBookTemp == nil) {
                if (emptyPageView != nil) {
                    [emptyPageView removeAllSubviews];
                    [emptyPageView removeFromSuperview];
                }
                if (_emptyView != nil) {
                    [_emptyView removeFromSuperview];
                }
                if (_tableType == 2) {
                    [self createEmptyViewWithTopY:44];
                }else
                {
                    [self createEmptyViewWithTopY:88];
                }
            }
        }else {
            if (addressBookTemp.count==0 || addressBookTemp == nil) {
                if (emptyPageView != nil) {
                    [emptyPageView removeAllSubviews];
                    [emptyPageView removeFromSuperview];
                }
                if (_emptyView != nil) {
                    [_emptyView removeFromSuperview];
                }
                if (!customerType) {
                    [self createEmptyPageView];
                }else {
                    [self createEarthEmptyPageView];
                }
            }
        }
    }
    return self;
}

- (void) initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 88)];
    if (_tableType == 2) {
        headerView.height = 44;
    }
    headerView.backgroundColor = BACKGROUNDCOLOR;//[UIColor whiteColor];
    self.tableHeaderView = headerView;
}

- (void)createEmptyPageView
{
    emptyPageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:emptyPageView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-95.0/375*kMainScreenWidth/2, (158.0/667)*kMainScreenHeight, (95.0/375)*kMainScreenWidth, (75.0/375)*kMainScreenWidth)];
    NSLog(@"emptyPageView.frame : %@",NSStringFromCGRect(emptyPageView.frame));
    [imgView setImage:[UIImage imageNamed:@"icon_customer"]];
    [emptyPageView addSubview:imgView];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]};
    CGSize size1 = [@"还没有客户哦，先" sizeWithAttributes:attributes];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85.0/375*kMainScreenWidth, imgView.bottom + 30.0/667*kMainScreenHeight, size1.width, size1.height)];
    label1.text = @"还没有客户哦，先";
    label1.textColor = LABELCOLOR;
    label1.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [emptyPageView addSubview:label1];
    
    CGSize size2 = [@"添加联系人" sizeWithAttributes:attributes];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"添加联系人"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(label1.right, label1.top-10, size2.width, size2.height+20);
    [btn2 setAttributedTitle:content forState:UIControlStateNormal];
    btn2.titleLabel.textColor = BLUEBTBCOLOR;
    btn2.titleLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [btn2 addTarget:self action:@selector(ToggleBtn2:) forControlEvents:UIControlEventTouchUpInside];
    [emptyPageView addSubview:btn2];
    
    
    CGSize size3 = [@"吧!" sizeWithAttributes:attributes];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(btn2.right, label1.top, size3.width, size3.height)];
    label3.text = @"吧!";
    label3.textColor = LABELCOLOR;
    label3.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [emptyPageView addSubview:label3];
    
    _searchEmptyL = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 30.0/667*kMainScreenHeight, emptyPageView.width, size1.height)];
    _searchEmptyL.text = @"没有符合要求客户";
    _searchEmptyL.font = FONT(14);
    _searchEmptyL.backgroundColor = BACKGROUNDCOLOR;
    _searchEmptyL.textColor = LINECOLOR;
    _searchEmptyL.textAlignment = NSTextAlignmentCenter;
    _searchEmptyL.hidden = YES;
    [emptyPageView addSubview:_searchEmptyL];
}

- (void)createEarthEmptyPageView
{
    emptyPageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:emptyPageView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-95.0/375*kMainScreenWidth/2, (158.0/667)*kMainScreenHeight, (95.0/375)*kMainScreenWidth, (75.0/375)*kMainScreenWidth)];
    NSLog(@"emptyPageView.frame : %@",NSStringFromCGRect(emptyPageView.frame));
    [imgView setImage:[UIImage imageNamed:@"icon_customer"]];
    [emptyPageView addSubview:imgView];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE]};
    CGSize size1 = [@"没有用户，" sizeWithAttributes:attributes];
    CGSize size2 = [@"请添加客户" sizeWithAttributes:attributes];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(emptyPageView.width/2-(size1.width+size2.width)/2, imgView.bottom + 30.0/667*kMainScreenHeight, size1.width, size1.height)];
    label1.text = @"没有用户，";
    label1.textColor = LABELCOLOR;
    label1.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [emptyPageView addSubview:label1];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"请添加客户"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(label1.right, label1.top-10, size2.width, size2.height+20);
    [btn2 setAttributedTitle:content forState:UIControlStateNormal];
    btn2.titleLabel.textColor = BLUEBTBCOLOR;
    btn2.titleLabel.font = [UIFont systemFontOfSize:CUSTOMER_LABEL_FONT_SIZE];
    [btn2 addTarget:self action:@selector(ToggleBtn3:) forControlEvents:UIControlEventTouchUpInside];
    [emptyPageView addSubview:btn2];
    
    _searchEmptyL = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 30.0/667*kMainScreenHeight, emptyPageView.width, size1.height)];
    _searchEmptyL.text = @"没有符合要求客户";
    _searchEmptyL.font = FONT(14);
    _searchEmptyL.backgroundColor = BACKGROUNDCOLOR;
    _searchEmptyL.textColor = LINECOLOR;
    _searchEmptyL.textAlignment = NSTextAlignmentCenter;
    _searchEmptyL.hidden = YES;
    [emptyPageView addSubview:_searchEmptyL];
}

- (void)createEmptyViewWithTopY:(CGFloat)topY
{
    _emptyView = [[CustomerEmptyView alloc] initWithFrame:CGRectMake(0, topY, self.width, self.height-topY)];
    [self addSubview:_emptyView];
}

- (void)ToggleBtn2:(UIButton*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(addLocalCustomer:)]) {
        [self.cellDelegate addLocalCustomer:self];
    }
}

- (void)ToggleBtn3:(UIButton*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(addGroupMember:)]) {
        [self.cellDelegate addGroupMember:self];
    }
}

-(void)refreshTableViewWithCustomer:(NSArray*)customerArray ByCustomerType:(NSInteger)customerType withStore:(BOOL)bHasStore
{
    _customerType = customerType;
    totalRowHeight = 70*customerArray.count;
    if (_tableType!=0) {
        
        if (customerArray.count==0 || customerArray == nil) {
            if (emptyPageView != nil) {
                [emptyPageView removeAllSubviews];
                [emptyPageView removeFromSuperview];
            }
            if (_emptyView != nil) {
                [_emptyView removeFromSuperview];
            }
            if (_tableType == 2) {
                [self createEmptyViewWithTopY:44];
            }else
            {
                [self createEmptyViewWithTopY:88];
            }
        }else
        {
            if (_emptyView != nil) {
                [_emptyView removeFromSuperview];
            }
        }
    }else {
//        totalRowHeight = 100*customerArray.count;
        _hasShop = bHasStore;
        if (customerArray.count==0 || customerArray == nil) {
            if (emptyPageView != nil) {
                [emptyPageView removeAllSubviews];
                [emptyPageView removeFromSuperview];
            }
            if (!customerType) {
                [self createEmptyPageView];
            }else {
                [self createEarthEmptyPageView];
            }
        }else
        {
            if (emptyPageView != nil) {
                [emptyPageView removeAllSubviews];
                [emptyPageView removeFromSuperview];
            }
        }
    }
    [addressSortedArray removeAllObjects];
    [firstLetterArray removeAllObjects];
    [statusArray removeAllObjects];
    [self sortDataWithSourceData:customerArray];
    
    [self reloadData];
}

-(void)refreshTableViewWithCustomer:(NSArray*)customerArray ByCustomerType:(NSInteger)customerType LastSelectedArray:(NSArray*)selectedArray
{
    _customerType = customerType;
    if (_bIsShowVisitInfo) {
        totalRowHeight = 150*visitStatusArray.count+70*(customerArray.count-visitStatusArray.count);
        if (_bIsShowConfirmInfo) {
            totalRowHeight = 170*visitStatusArray.count+70*(customerArray.count-visitStatusArray.count);
        }
    }else
    {
        totalRowHeight = 70*customerArray.count;
        if (_bIsShowConfirmInfo) {
            totalRowHeight = 120*confirmStatusArray.count+70*(customerArray.count-confirmStatusArray.count);
        }
    }
    [addressSortedArray removeAllObjects];
    [firstLetterArray removeAllObjects];
    [statusArray removeAllObjects];
    [showVisitInfoArray removeAllObjects];
    
    if (selectedArray != nil) {
        [lastStatusArray removeAllObjects];
        [lastStatusArray addObjectsFromArray:selectedArray];
    }
    
    [self sortDataWithSourceData:customerArray];
//    if (_tableType==1) {
    if (customerArray.count==0 || customerArray == nil) {
        if (emptyPageView != nil) {
            [emptyPageView removeAllSubviews];
            [emptyPageView removeFromSuperview];
        }
        if (_emptyView != nil) {
            [_emptyView removeFromSuperview];
        }
        if (_tableType == 2) {
            [self createEmptyViewWithTopY:44];
        }else
        {
            [self createEmptyViewWithTopY:88];
        }
    }else
    {
        if (_emptyView != nil) {
            [_emptyView removeFromSuperview];
        }
    }
//    }
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return firstLetterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (addressSortedArray.count > section) {
        count = ((NSArray*)[addressSortedArray objectForIndex:section]).count;
    }
    return count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return firstLetterArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [firstLetterArray objectForIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in self.firstLetterArray)
    {
        if([character isEqualToString:title])
        {
//            _selectedLetterAtIndex(title);
            if([self.cellDelegate respondsToSelector:@selector(customerTableView:FirstLetterSelecte:)])
            {
                [self.cellDelegate customerTableView:self FirstLetterSelecte:title];
            }
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:count]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
            return count;
        }
        count ++;
    }
    return 0;
}
#pragma mark - 创建一条细线
- (UIView *)createLineView:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, y, kMainScreenWidth-30, 0.5)];
    line.backgroundColor = LINECOLOR;
    return line;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CustomerListTableViewCell *cell = (CustomerListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    __weak CustomerTableView *weakSelf = self;
    if (addressSortedArray.count>indexPath.section && ((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count>indexPath.row) {
        customer = [(NSArray*)[addressSortedArray objectForIndex:indexPath.section] objectForIndex:indexPath.row];
    }
    cell.customerList = customer;
    BOOL isCallHidden = NO;
//    MobileVisible *mobile = (MobileVisible*)[customer.phone objectForIndex:0];
    MobileVisible *mobile = nil;
    if (customer.phoneList.count > 0) {
        mobile = (MobileVisible*)[customer.phoneList objectForIndex:0];
    }
    if ([self isBlankString:mobile.totalPhone] && [mobile.hidingPhone rangeOfString:@"****"].location != NSNotFound) {
        isCallHidden = YES;
    }
//    if ([customer.listPhone rangeOfString:@"****"].location != NSNotFound) {
//        isCallHidden = YES;
//    }
    //➢	如当前用户未绑定门店，电话和报备功能对其不可见；如是此用户所在机构录入客户方式是前3后4非全号段，则电话功能对其不可见
    UIView *lineView = nil;
    if (_tableType == 0) {
        cell = [[CustomerListTableViewCell alloc] initWithShop:_hasShop CallHidden:isCallHidden AndSelectedHidden:YES PurchaseHidden:NO];
        lineView = [self createLineView:70-0.5];
        if (addressSortedArray.count > indexPath.section) {
            if (indexPath.row == ((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count-1) {
                lineView.hidden = YES;
            }
        }
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [longGesture setMinimumPressDuration:0.4];
        cell.telLabel.userInteractionEnabled=YES;
        [cell.telLabel addGestureRecognizer:longGesture];
        [cell.contentView addSubview:lineView];
        CGSize nameSize;
        if (customer.name.length <= 9) {
            nameSize = [customer.name sizeWithAttributes:@{NSFontAttributeName:FONT(17)}];
        }else
        {
            nameSize = [[NSString stringWithFormat:@"%@...", [customer.name substringToIndex:9]] sizeWithAttributes:@{NSFontAttributeName:FONT(17)}];
        }
        cell.customerNameLabel.width = nameSize.width;
        CGSize tipSize = [@"店长分配" sizeWithAttributes:@{NSFontAttributeName:FONT(12)}];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.customerNameLabel.right+10, cell.customerNameLabel.centerY-tipSize.height/2-2, tipSize.width+20, tipSize.height +4)];
        tipLabel.textColor = ORIGCOLOR;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"店长分配";
        tipLabel.font = FONT(12);
        [tipLabel.layer setMasksToBounds:YES];
        [tipLabel.layer setCornerRadius:3];
        [tipLabel.layer setBorderColor:ORIGCOLOR.CGColor];
        [tipLabel.layer setBorderWidth:0.5];
        if (customer.managerAllocation) {
            [cell.contentView addSubview:tipLabel];
        }
    }else{
//        if (cell == nil) {
            if (_tableType == 1 || _tableType == 2)
            {
                cell = [[CustomerListTableViewCell alloc] initWithShop:_hasShop CallHidden:YES AndSelectedHidden:NO PurchaseHidden:YES];
                if (_bIsShowVisitInfo) {
                    
                    BOOL bIsShowInfo = NO;
                    if (showVisitInfoArray.count > indexPath.section && ((NSMutableArray*)[showVisitInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
                        bIsShowInfo = [[(NSArray*)[showVisitInfoArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
                    }
                    cell.bIsShowVisitInfo = bIsShowInfo;
                    BOOL bIsConfirmInfo = NO;
                    if (_bIsShowConfirmInfo) {
                        if (showConfirmInfoArray.count > indexPath.section && ((NSMutableArray*)[showConfirmInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
                            bIsConfirmInfo = [[(NSArray*)[showConfirmInfoArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
                        }
                        cell.bIsShowConfirmInfo = bIsConfirmInfo;
                    }
                    
                    if (!bIsShowInfo) {
                        lineView = [self createLineView:70-0.5];
                        
                    }else
                    {
                        
                        if (bIsConfirmInfo) {
                            lineView = [self createLineView:170-0.5];
                        }else
                        {
                            lineView = [self createLineView:150-0.5];
                        }
                        CustomerVisitInfoData *data = (CustomerVisitInfoData*)[_visitInfoData valueForKey:customer.customerId];
                        cell.showVisitInfoView.visitDateLabel.text = [NSString stringWithFormat:@"预计到访时间:%@—%@",data.startDateStr,data.endDateStr];
                        cell.showVisitInfoView.visitCountLabel.text = [NSString stringWithFormat:@"预计到访人数:%@",data.visitCount];
                        cell.showVisitInfoView.visitFuncLabel.text = [NSString stringWithFormat:@"到访交通方式:%@",data.transfFunc];
                        
                        ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[_confirmInfoData valueForKey:customer.customerId];
/*                        NSString *confirmMobile = @"";
                        if (confirmData.confirmUserMobile.length >= 11) {
                            confirmMobile = [NSString stringWithFormat:@"%@ %@ %@",[confirmData.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[confirmData.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[confirmData.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                        }*/
                        cell.showVisitInfoView.confirmUserLabel.text = [NSString stringWithFormat:@"服务确客专员:%@    %@",confirmData.confirmUserName,confirmData.confirmUserMobile];
                        
                    }
                }else
                {
                    
                    if (_bIsShowConfirmInfo) {
                        
                        BOOL bIsConfirmInfo = NO;
                        if (showConfirmInfoArray.count > indexPath.section && ((NSMutableArray*)[showConfirmInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
                            bIsConfirmInfo = [[(NSArray*)[showConfirmInfoArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
                        }
                        cell.bIsShowConfirmInfo = bIsConfirmInfo;
                        if (bIsConfirmInfo) {
                            lineView = [self createLineView:110-0.5];
                        }else
                        {
                            lineView = [self createLineView:70-0.5];
                        }
                        
                        ConfirmUserInfoObject *confirmData = (ConfirmUserInfoObject*)[_confirmInfoData valueForKey:customer.customerId];
/*                        NSString *confirmMobile = @"";
                        if (confirmData.confirmUserMobile.length >= 11) {
                            confirmMobile = [NSString stringWithFormat:@"%@ %@ %@",[confirmData.confirmUserMobile substringWithRange:NSMakeRange(0, 3)],[confirmData.confirmUserMobile substringWithRange:NSMakeRange(3, 4)],[confirmData.confirmUserMobile substringWithRange:NSMakeRange(7, 4)]];
                        }*/
                        cell.showVisitInfoView.confirmUserLabel.text = [NSString stringWithFormat:@"服务确客专员:%@    %@",confirmData.confirmUserName,confirmData.confirmUserMobile];//@"18888888888"
                    }else
                    {
                        lineView = [self createLineView:70-0.5];
                    }
                }
            }else if (_tableType == 3)
            {
                cell = [[CustomerListTableViewCell alloc] initWithShop:YES CallHidden:YES AndSelectedHidden:YES PurchaseHidden:YES];
                lineView = [self createLineView:70-0.5];
            }
        if (addressSortedArray.count > indexPath.section) {
            if (indexPath.row == ((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count-1) {
                lineView.hidden = YES;
            }
        }
//            lineView.tag = 100;
            [cell.contentView addSubview:lineView];
            
//        }else
//        {
//            lineView = (UIView *)[cell.contentView viewWithTag:100];
//        }
    }

    if (customer.name.length <= 9) {
        cell.customerNameLabel.text = customer.name;
    }else
    {
        cell.customerNameLabel.text = [NSString stringWithFormat:@"%@...", [customer.name substringToIndex:9]];
    }
//    cell.customerNameLabel.text = customer.name;
    cell.telLabel.text = customer.listPhone;
//    cell.purchaseIntentionLabel.text = customer.expect;
    [cell selectCallBlock:^(CustomerListTableViewCell*custCell){
        NSIndexPath *cellIndexPath = [weakSelf indexPathForCell:custCell];
        weakSelf.customer = nil;
        if (weakSelf.addressSortedArray.count > cellIndexPath.section && ((NSArray*)[weakSelf.addressSortedArray objectForIndex:cellIndexPath.section]).count > cellIndexPath.row) {
            weakSelf.customer = [(NSArray*)[weakSelf.addressSortedArray objectForIndex:cellIndexPath.section] objectForIndex:cellIndexPath.row];
        }
        if ([weakSelf.cellDelegate respondsToSelector:@selector(customerTableView:CallWithCustomer:)]) {
            [weakSelf.cellDelegate customerTableView:weakSelf CallWithCustomer:weakSelf.customer];
        }
    }];
//delete by wangzz 161020
//    [cell selectReportBlock:^(CustomerListTableViewCell*custCell){
//        NSIndexPath *cellIndexPath = [weakSelf indexPathForCell:custCell];
//        weakSelf.customer = nil;
//        if (weakSelf.addressSortedArray.count > cellIndexPath.section && ((NSArray*)[weakSelf.addressSortedArray objectForIndex:cellIndexPath.section]).count > cellIndexPath.row) {
//            weakSelf.customer = [(NSArray*)[weakSelf.addressSortedArray objectForIndex:cellIndexPath.section] objectForIndex:cellIndexPath.row];
//        }
//        if ([weakSelf.cellDelegate respondsToSelector:@selector(customerTableView:ReportWithCustId:)]) {
//            [weakSelf.cellDelegate customerTableView:weakSelf ReportWithCustId:weakSelf.customer];
//        }
//    }];
//end
    if (_tableType) {
        if (statusArray.count > indexPath.section && ((NSArray*)[statusArray objectForIndex:indexPath.section]).count > indexPath.row) {
            cell.selectedBtn.selected = [[(NSArray*)[statusArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
        }
        [cell selectCustomerBlock:^(CustomerListTableViewCell*custCell,BOOL bIsSelected){
            NSIndexPath *cellIndexPath = [weakSelf indexPathForCell:custCell];
            weakSelf.customer = nil;
            if (weakSelf.addressSortedArray.count > cellIndexPath.section && ((NSArray*)[weakSelf.addressSortedArray objectForIndex:cellIndexPath.section]).count > cellIndexPath.row) {
               weakSelf.customer =  [(NSArray*)[weakSelf.addressSortedArray objectForIndex:cellIndexPath.section] objectForIndex:cellIndexPath.row];
            }
            if (bIsSelected) {
                if (weakSelf.tableType==2) {
                    NSInteger count = 0;
                    for (int i=0; i<weakSelf.statusArray.count; i++) {
                        for (int j=0; j<((NSMutableArray*)[weakSelf.statusArray objectForIndex:i]).count; j++) {
                            NSString *str = (NSString*)[((NSMutableArray*)[weakSelf.statusArray objectForIndex:i]) objectForIndex:j];
                            if ([str isEqualToString:@"1"]) {
                                count++;
                            }
                        }
                    }
                    if (count < 10) {
                        if (weakSelf.statusArray.count > cellIndexPath.section && ((NSMutableArray*)[weakSelf.statusArray objectForIndex:cellIndexPath.section]).count > cellIndexPath.row) {
                            [((NSMutableArray*)[weakSelf.statusArray objectForIndex:cellIndexPath.section]) replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                        }
                        
                    }else if (count>=10)
                    {
                        cell.selectedBtn.selected = NO;
                    }
                }else
                {
                    if (weakSelf.statusArray.count > cellIndexPath.section && ((NSMutableArray*)[weakSelf.statusArray objectForIndex:cellIndexPath.section]).count > cellIndexPath.row) {
                        [((NSMutableArray*)[weakSelf.statusArray objectForIndex:cellIndexPath.section]) replaceObjectForIndex:cellIndexPath.row withObject:@"1"];
                    }
                }
            }else
            {
                if (weakSelf.statusArray.count > cellIndexPath.section && ((NSMutableArray*)[weakSelf.statusArray objectForIndex:cellIndexPath.section]).count > cellIndexPath.row) {
                    [((NSMutableArray*)[weakSelf.statusArray objectForIndex:cellIndexPath.section]) replaceObjectForIndex:cellIndexPath.row withObject:@"0"];
                }
            }
            
            if ([weakSelf.cellDelegate respondsToSelector:@selector(customerTableView:AndIndexPath:SelecteCustomerWithId:AndSeletedStatus:)]) {
                [weakSelf.cellDelegate customerTableView:weakSelf AndIndexPath:cellIndexPath SelecteCustomerWithId:weakSelf.customer.customerId AndSeletedStatus:bIsSelected];
            }
        }];
    }
//    DLog(@"indexPath.section = %ld,cell.selected = %d",(long)indexPath.section,cell.selected);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 70;
    if (_tableType == 2)
    {
        if (_bIsShowVisitInfo) {
            BOOL bIsShowInfo = NO;
            if (showVisitInfoArray.count > indexPath.section && ((NSArray*)[showVisitInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
                bIsShowInfo = [[(NSArray*)[showVisitInfoArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
            }
            
            if (bIsShowInfo) {
                height = 150;
            }
            if (_bIsShowConfirmInfo) {
                BOOL bIsConfirmInfo = NO;
                if (showConfirmInfoArray.count > indexPath.section && ((NSArray*)[showConfirmInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
                    bIsConfirmInfo = [[(NSArray*)[showConfirmInfoArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
                }
                if (bIsConfirmInfo) {
                    height = 170;
                }
            }
        }else
        {
            if (_bIsShowConfirmInfo) {
                BOOL bIsConfirmInfo = NO;
                if (showConfirmInfoArray.count > indexPath.section && ((NSArray*)[showConfirmInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
                    bIsConfirmInfo = [[(NSArray*)[showConfirmInfoArray objectForIndex:indexPath.section] objectForIndex:indexPath.row] boolValue];
                }
                if (bIsConfirmInfo) {
                    height = 110;
                }
            }
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle=[self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle==nil) {
        return nil;
    }
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(10, 0, 30, 30);
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    //    [label.layer setMasksToBounds:YES];
    //    [label.layer setCornerRadius:5];
    label.text=sectionTitle;
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:BACKGROUNDCOLOR];
    [sectionView addSubview:label];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableType < 1 || _tableType > 2) {
        Customer *cust=nil;
        if (addressSortedArray.count>indexPath.section && ((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count>indexPath.row) {
            cust = [(NSArray*)[addressSortedArray objectForIndex:indexPath.section] objectForIndex:indexPath.row];
        }
        if ([self.cellDelegate respondsToSelector:@selector(CustomerDidSelectedCell:AndIndexPath:Customer:)]) {
            [self.cellDelegate CustomerDidSelectedCell:self AndIndexPath:indexPath Customer:cust];
        }
    }
    if (_tableType == 2) {
        if (_bIsShowVisitInfo || _bIsShowConfirmInfo) {
            Customer *cust=nil;
            if (addressSortedArray.count>indexPath.section && ((NSArray*)[addressSortedArray objectForIndex:indexPath.section]).count>indexPath.row) {
                cust = [(NSArray*)[addressSortedArray objectForIndex:indexPath.section] objectForIndex:indexPath.row];
            }
            if ([self.cellDelegate respondsToSelector:@selector(CustomerDidSelectedCell:AndIndexPath:Customer:)]) {
                [self.cellDelegate CustomerDidSelectedCell:self AndIndexPath:indexPath Customer:cust];
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if([self.cellDelegate respondsToSelector:@selector(scrollWithTableView:ScrollView:)])
//    {
//        [self.cellDelegate scrollWithTableView:self ScrollView:scrollView];
//    }
//    DLog(@"totalRowHeight : %f, self.height : %f",totalRowHeight,self.height);
//    [[NSNotificationCenter defaultCenter] postNotificationName:UIMenuControllerWillHideMenuNotification object:nil];
    
    if (totalRowHeight > self.height) {
        _didScrollTableView(scrollView);
    }
}

-(void)refreshRowInSection:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath*)indexPath WithVisitData:(NSMutableDictionary*)visitInfoData
{
    _visitInfoData = visitInfoData;
    if (showVisitInfoArray.count > indexPath.section && ((NSMutableArray*)[showVisitInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
        [(NSMutableArray*)[showVisitInfoArray objectForIndex:indexPath.section] replaceObjectForIndex:indexPath.row withObject:@"1"];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)refreshRowInSection:(CustomerTableView*)tableView AndIndexPath:(NSIndexPath*)indexPath WithConfirmData:(NSMutableDictionary*)confirmInfoData
{
    _confirmInfoData = confirmInfoData;
    if (showConfirmInfoArray.count > indexPath.section && ((NSMutableArray*)[showConfirmInfoArray objectForIndex:indexPath.section]).count > indexPath.row) {
        [(NSMutableArray*)[showConfirmInfoArray objectForIndex:indexPath.section] replaceObjectForIndex:indexPath.row withObject:@"1"];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//联系人按照拼音首字母排序并分组
- (void)sortDataWithSourceData:(NSArray*)data1
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *specialArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data1 count]; i++) {
        Customer *customerList = [[Customer alloc] init];
        customerList = [data1 objectForIndex:i];
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string = customerList.name;
        chineseString.telNumber = customerList.listPhone;
        chineseString.custId = customerList.customerId;
        chineseString.purchaseInte = customerList.expect;
        chineseString.sex = customerList.sex;
        chineseString.count = customerList.count;
        chineseString.phone = customerList.phoneList;
        chineseString.bIsDefine = customerList.managerAllocation;
        chineseString.defineText = customerList.managerAllocationText;
        chineseString.cardId = customerList.cardId;
        chineseString.custSource = customerList.custSource;
        chineseString.custSourceLabel = customerList.custSourceLabel;
        
        if([self isBlankString:chineseString.string]){
            chineseString.string = @"";
        }
        if(![chineseString.string isEqualToString:@""])
        {
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *charStr=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:charStr];
            }
            chineseString.pinYin = pinYinResult;
        }else
        {
            chineseString.pinYin = @"";
        }
        char p = [ChineseToPinyin sortSectionTitle:chineseString.string];
        NSString* charStr = [[NSString alloc] initWithFormat:@"%c", p];
        if (![NSString isZimu:charStr]) {
            [specialArr appendObject:customerList];
        }else
        {
            [array appendObject:chineseString];
        }
    }
    //    NSLog(@"\n\n\n转换为拼音首字母后的NSString数组");
    //    for(int i=0;i<[array count];i++){
    //        ChineseString *chineseString=[array objectForIndex:i];
    //        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    //    }
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES], nil];
    [array sortUsingDescriptors:sortDescriptors];
    
    //Step3输出
    //    NSLog(@"\n\n\n按照拼音首字母后的NSString数组");
    //    for(int i=0;i<[array count];i++){
    //        ChineseString *chineseString=[array objectForIndex:i];
    //        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    //    }
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    
    for (int i = 0; i < [array count]; i++) {
        ChineseString *str=[array objectForIndex:i];
        char p = [ChineseToPinyin sortSectionTitle:str.string];
        NSString* charStr = [[NSString alloc] initWithFormat:@"%c", p];
//        if (![NSString isZimu:charStr]) {
//            charStr = @"#";
//        }
        if (![firstLetterArray containsObject:charStr]) {
            
            [firstLetterArray appendObject:charStr];
        }
    }
//    if ([firstLetterArray containsObject:@"#"]) {
//        [firstLetterArray removeObject:@"#"];
//        [firstLetterArray appendObject:@"#"];
//    }
    for (int i = 0; i < [firstLetterArray count]; i++) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        NSMutableArray *temArray = [[NSMutableArray alloc] init];
//        NSMutableArray *addInfoArray = [[NSMutableArray alloc] init];
        NSMutableArray *showInfoArray = [[NSMutableArray alloc] init];
        NSMutableArray *confirmInfoArray = [[NSMutableArray alloc] init];
        for (int j=0; j<array.count; j++) {
            ChineseString *str=[array objectForIndex:j];
            char p = [ChineseToPinyin sortSectionTitle:str.string];
            NSString* charStr = [[NSString alloc] initWithFormat:@"%c", p];
//            NSString *name = ((ChineseString*)[array objectForIndex:j]).string;
//            if (![NSString isZimu:charStr]) {
//                charStr = @"#";
//            }
            Customer *cust = [[Customer alloc] init];
            cust.name = ((ChineseString*)[array objectForIndex:j]).string;
            cust.listPhone = ((ChineseString*)[array objectForIndex:j]).telNumber;
            cust.customerId = ((ChineseString*)[array objectForIndex:j]).custId;
            cust.expect = ((ChineseString*)[array objectForIndex:j]).purchaseInte;
            cust.sex = ((ChineseString*)[array objectForIndex:j]).sex;
            cust.count = ((ChineseString*)[array objectForIndex:j]).count;
            cust.phoneList = ((ChineseString*)[array objectForIndex:j]).phone;
            cust.managerAllocation = ((ChineseString*)[array objectForIndex:j]).bIsDefine;
            cust.managerAllocationText = ((ChineseString*)[array objectForIndex:j]).defineText;
            cust.cardId = ((ChineseString*)[array objectForIndex:j]).cardId;
            cust.custSource = ((ChineseString*)[array objectForIndex:j]).custSource;
            cust.custSourceLabel = ((ChineseString*)[array objectForIndex:j]).custSourceLabel;

            if ([charStr isEqualToString:[firstLetterArray objectForIndex:i]]) {
                
                [sectionArray appendObject:cust];
                [temArray appendObject:@"0"];
                [showInfoArray appendObject:@"0"];
                [confirmInfoArray appendObject:@"0"];

                for (NSString *custId in visitStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [showInfoArray removeLastObject];
                        [showInfoArray appendObject:@"1"];
                    }
                }
                
                for (NSString *custId in confirmStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [confirmInfoArray removeLastObject];
                        [confirmInfoArray appendObject:@"1"];
                    }
                }
                for (NSString *custId in lastStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [temArray removeLastObject];
                        [temArray appendObject:@"1"];
                    }
                }
            }
        }
        [addressSortedArray appendObject:sectionArray];
        [statusArray appendObject:temArray];
        [showVisitInfoArray appendObject:showInfoArray];
        [showConfirmInfoArray appendObject:confirmInfoArray];
    }
    if (specialArr.count>0) {
        [firstLetterArray appendObject:@"#"];
        
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        NSMutableArray *showInfoArray = [[NSMutableArray alloc] init];
        NSMutableArray *temArray = [[NSMutableArray alloc] init];
        NSMutableArray *confirmInfoArray = [[NSMutableArray alloc] init];
        for (int i=0; i<specialArr.count; i++) {
            Customer *cust = (Customer*)[specialArr objectForIndex:i];
            if (_customerType != 0)
            {
                [sectionArray appendObject:cust];
                [temArray appendObject:@"0"];
                [showInfoArray appendObject:@"0"];
                
                for (NSString *custId in visitStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [showInfoArray removeLastObject];
                        [showInfoArray appendObject:@"1"];
                    }
                }
                for (NSString *custId in confirmStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [confirmInfoArray removeLastObject];
                        [confirmInfoArray appendObject:@"1"];
                    }
                }
                for (NSString *custId in lastStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [temArray removeLastObject];
                        [temArray appendObject:@"1"];
                    }
                }
            }else
            {
                if (i==0) {
                    [sectionArray appendObject:cust];
                    [temArray appendObject:@"0"];
                    [showInfoArray appendObject:@"0"];
                    [confirmInfoArray appendObject:@"0"];
                }else
                {
                    [sectionArray insertObject:cust forIndex:0];
                    [temArray insertObject:@"0" forIndex:0];
                    [showInfoArray insertObject:@"0" forIndex:0];
                    [confirmInfoArray appendObject:@"0"];
                }
                for (NSString *custId in visitStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [showInfoArray removeLastObject];
                        [showInfoArray appendObject:@"1"];
                        [showInfoArray removeObjectForIndex:0];
                        if (showInfoArray.count == 0) {
                            [showInfoArray appendObject:@"1"];
                        }else
                        {
                            [showInfoArray insertObject:@"1" forIndex:0];
                        }
                    }
                }
                for (NSString *custId in confirmStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [confirmInfoArray removeLastObject];
                        [confirmInfoArray appendObject:@"1"];
                        [confirmInfoArray removeObjectForIndex:0];
                        if (confirmInfoArray.count == 0) {
                            [confirmInfoArray appendObject:@"1"];
                        }else
                        {
                            [confirmInfoArray insertObject:@"1" forIndex:0];
                        }
                    }
                }
                for (NSString *custId in lastStatusArray) {
                    if ([custId isEqualToString:cust.customerId]) {
                        [temArray removeLastObject];
                        [temArray appendObject:@"1"];
                        [temArray removeObjectForIndex:0];
                        if (temArray.count == 0) {
                            [temArray appendObject:@"1"];
                        }else
                        {
                            [temArray insertObject:@"1" forIndex:0];
                        }
                    }
                }
            }
            
        }
        [addressSortedArray appendObject:sectionArray];
        [statusArray appendObject:temArray];
        [showVisitInfoArray appendObject:showInfoArray];
        [showConfirmInfoArray appendObject:confirmInfoArray];
    }
    totalRowHeight += 30*firstLetterArray.count;
}
#pragma mark - 长按手势
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    CustomerListTableViewCell *cell = nil;
    if (iOS8) {
        cell = (CustomerListTableViewCell *)[[longPress.view superview] superview];
    }else
    {
        cell = (CustomerListTableViewCell *)[[[longPress.view superview] superview] superview];
    }
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    if (telIndexPath != nil) {
        CustomerListTableViewCell *cell = [self cellForRowAtIndexPath:telIndexPath];
        cell.telLabel.backgroundColor = [UIColor clearColor];
    }
    DLog(@"view=%@,super=%@,ssuper=%@,sssuper=%@",longPress.view,[longPress.view superview],[[longPress.view superview] superview],[[[longPress.view superview] superview] superview]);
    //    if ([self.bubbleView.text hasSuffix:@".amr"] || [self isFileExist:self.bubbleView.text]) {
    //        return;
    //    }else
//    {
    
        telIndexPath = [self indexPathForCell:cell];
    if (addressSortedArray.count>telIndexPath.section && ((NSArray*)[addressSortedArray objectForIndex:telIndexPath.section]).count>telIndexPath.row) {
        customer = [(NSArray*)[addressSortedArray objectForIndex:telIndexPath.section] objectForIndex:telIndexPath.row];
        MobileVisible *mobile = (MobileVisible*)[customer.phoneList objectForIndex:0];
        if (![self isBlankString:mobile.totalPhone]) {
            if ([self.cellDelegate respondsToSelector:@selector(customerTableView:CopyWithCustomer:)]) {
                [self.cellDelegate customerTableView:self CopyWithCustomer:customer];
            }
        }else
        {
            _telString = cell.telLabel.text;
    
            UIMenuController *menu = [UIMenuController sharedMenuController];
            UIMenuItem *saveItem;
            //    if(self.bubbleView.data){
            //        saveItem = [[UIMenuItem alloc] initWithTitle:@"Save" action:@selector(saveImage:)];
            //    }else{
            //        saveItem = nil;
            //    }
    
            [menu setMenuItems:[NSArray arrayWithObjects:saveItem, nil]];
    
    //        CGRect targetRect = [cell convertRect:cell.telLabel.frame
    //                                     fromView:cell.telLabel];
    //        [menu setTargetRect:CGRectInset(CGRectMake(targetRect.origin.x/2-5, targetRect.origin.y-30, targetRect.size.width, targetRect.size.height),0.0f, 0.0f) inView:cell];
    
            CGRect targetRect = cell.telLabel.frame;
            [menu setTargetRect:CGRectInset(CGRectMake(targetRect.origin.x/2-5, targetRect.origin.y, targetRect.size.width, targetRect.size.height),0.0f, 0.0f) inView:[cell.telLabel superview]];
    
    
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleMenuWillShowNotification:)
                                                         name:UIMenuControllerWillShowMenuNotification
                                                       object:nil];
            [menu setMenuVisible:YES animated:YES];
            
            [menu update];
        }
        
    }

//    }
}

#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    //    self.bubbleView.selectedToShowCopyMenu = NO;
    CustomerListTableViewCell *cell = [self cellForRowAtIndexPath:telIndexPath];
    cell.telLabel.backgroundColor = [UIColor clearColor];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    //    self.bubbleView.selectedToShowCopyMenu = YES;
    CustomerListTableViewCell *cell = [self cellForRowAtIndexPath:telIndexPath];
    cell.telLabel.backgroundColor = bgViewColor;
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    //    NSMutableArray *messageRange = [[NSMutableArray alloc] init];
    //
    //    NSMutableString *messageStr = [NSMutableString string];
    //    NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] valueForKey:@"FaceMap"];
    //    for (int index = 0; index < [messageRange count]; index++) {
    //
    //        NSString *str = [messageRange objectForIndex:index];
    //
    //            [messageStr appendString:str];
    //
    //    }
    
    [[UIPasteboard generalPasteboard] setString:_telString];
    [self resignFirstResponder];
}

- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end

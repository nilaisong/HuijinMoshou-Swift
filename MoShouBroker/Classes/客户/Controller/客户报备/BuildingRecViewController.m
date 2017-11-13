//
//  BuildingRecViewController.m
//  MoShou2
//
//  Created by manager on 2017/4/21.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "BuildingRecViewController.h"
#import "BuildingDetailViewController.h"
#import "BuildingCell.h"
#import "DataFactory+Customer.h"
#import "MyBuildingViewController.h"

@class BuildingDetailViewController;

@interface BuildingRecViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray     *tempArr;
@property (nonatomic, strong) CustomerSourceData *custSourceData;

@end

@implementation BuildingRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"报备成功";
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-8-40, 20+5, 40, 34)];
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    [saveBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"166fa2"] forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [saveBtn addTarget:self action:@selector(toggleSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:saveBtn];
    
    _tempArr = [[NSMutableArray alloc] init];
    _custSourceData = [[CustomerSourceData alloc] init];
    [self hasNetwork];
    // Do any additional setup after loading the view.
}

- (void)hasNetwork
{
    __weak typeof(self) weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[weakSelf reloadView];}])
    {
        [self reloadView];
    }
}

- (void)reloadView
{
    [self createTableView];
    [self getfindRecommendEstate];
}

//展示推荐楼盘
-(void)getfindRecommendEstate
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (![self isBlankString:_buildingId]) {
        [dic setObject:_buildingId forKey:@"estateId"];
    }
    if (![self isBlankString:_custId]) {
        [dic setObject:_custId forKey:@"custId"];
    }
    [[DataFactory sharedDataFactory] getRecommenBuildWithDict:dic withCallBack:^(ActionResult *actionResult, CustomerSourceData *buildingData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (actionResult.success)
            {
                if (_tempArr.count > 0)
                {
                    [_tempArr removeAllObjects];
                }
                if (buildingData != nil) {
                    _custSourceData = buildingData;
                    if (buildingData.result.count >0)
                    {
                        [_tempArr addObjectsFromArray:buildingData.result];
                    }
                    [self createTableViewHeaderView];
                    [_tableView reloadData];
                }
            }else
            {
                [self showTips:actionResult.message];
                [self createTableViewHeaderView];
            }
        });
    }];
    
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSeparatorColor:UIColorFromRGB(0xefeff4)];
    [self.view addSubview:self.tableView];
}

-(void)createTableViewHeaderView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    
//    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+10, kMainScreenWidth, 13)];
//    titleLabel2.text = @"请换个筛选条件试试";
//    titleLabel2.font = FONT(12.f);
//    titleLabel2.textAlignment = NSTextAlignmentCenter;
//    titleLabel2.textColor = NAVIGATIONTITLE;
//    [view addSubview:titleLabel2];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake((kMainScreenWidth-105)/2, titleLabel2.bottom+15, 105, 56/2);
//    button.backgroundColor = BLUEBTBCOLOR;
//    button.titleLabel.font = FONT(13.f);
//    [button setTitle:@"返回楼盘列表" forState:UIControlStateNormal];
//    button.layer.cornerRadius = 5;
//    button.layer.masksToBounds = YES;
//    [button addTarget:self action:@selector(setSearchNomalStateBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
    UIView *theHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    theHeaderView.backgroundColor = [UIColor whiteColor];
    [view addSubview:theHeaderView];
    
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth-55*SCALE6)/2, 20, 55*SCALE6, 55*SCALE6)];
    [iconImgView setImage:[UIImage imageNamed:@"icon_buildingrecommed"]];
    [theHeaderView addSubview:iconImgView];
    
    NSString *tipStr = @"报备已成功，请等待案场专员的确认。";
    CGSize tipSize = [tipStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iconImgView.bottom+20, kMainScreenWidth-20, tipSize.height)];
    tipLabel.textColor = [UIColor colorWithHexString:@"1ac38f"];
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = tipStr;
    [theHeaderView addSubview:tipLabel];
    
    theHeaderView.height = tipLabel.bottom+20;
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, theHeaderView.bottom, kMainScreenWidth, 0)];
    middleView.backgroundColor = BACKGROUNDCOLOR;//[UIColor colorWithHexString:@"fafafa"];
    [view addSubview:middleView];
    
    NSString *labelStr1 = @"请注意该项目报备及带看规则";
    CGSize labelSize1 = [labelStr1 sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kMainScreenWidth-20, labelSize1.height)];
    label1.textColor = [UIColor colorWithHexString:@"888888"];
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.text = labelStr1;
    [middleView addSubview:label1];
    
    NSString *labelStr2 = @"报备时效:";
    CGSize labelSize2 = [labelStr2 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, label1.bottom+10, labelSize2.width, labelSize2.height)];
    label2.textColor = [UIColor colorWithHexString:@"888888"];
    label2.font = FONT(12);
    label2.text = labelStr2;
    [middleView addSubview:label2];
    
    UILabel *reportTimeL = [[UILabel alloc] initWithFrame:CGRectMake(label2.right+10, label2.top, kMainScreenWidth-label2.right-20, label2.height)];
    reportTimeL.textColor = NAVIGATIONTITLE;
    reportTimeL.font = FONT(12);
    if (![self isBlankString:_custSourceData.recomMess]) {
        reportTimeL.text = _custSourceData.recomMess;
        reportTimeL.numberOfLines = 0;
        reportTimeL.lineBreakMode = NSLineBreakByWordWrapping;
        [self setLabelSpace:reportTimeL withValue:reportTimeL.text withFont:FONT(12)];
        reportTimeL.height = [self getSpaceLabelHeight:reportTimeL.text withFont:FONT(12) withWidth:reportTimeL.width];
    }
    [middleView addSubview:reportTimeL];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, reportTimeL.bottom+10, labelSize2.width, labelSize2.height)];
    label3.textColor = [UIColor colorWithHexString:@"888888"];
    label3.font = FONT(12);
    label3.text = @"带看规则:";
    [middleView addSubview:label3];
    
    UILabel *daikanL = [[UILabel alloc] initWithFrame:CGRectMake(label3.right+10, label3.top, kMainScreenWidth-label3.right-20, label3.height)];
    daikanL.textColor = NAVIGATIONTITLE;
    daikanL.font = FONT(12);
    if (![self isBlankString:_custSourceData.customerVisteRule]) {
        daikanL.text = _custSourceData.customerVisteRule;
        daikanL.numberOfLines = 0;
        daikanL.lineBreakMode = NSLineBreakByWordWrapping;
        [self setLabelSpace:daikanL withValue:daikanL.text withFont:FONT(12)];
        daikanL.height = [self getSpaceLabelHeight:daikanL.text withFont:FONT(12) withWidth:daikanL.width];
    }
    [middleView addSubview:daikanL];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, daikanL.bottom+10, labelSize2.width, labelSize2.height)];
    label4.textColor = [UIColor colorWithHexString:@"888888"];
    label4.font = FONT(12);
    label4.text = @"客户保护:";
    [middleView addSubview:label4];
    
    UILabel *customerL = [[UILabel alloc] initWithFrame:CGRectMake(label4.right+10, label4.top, kMainScreenWidth-label4.right-20, label4.height)];
    customerL.textColor = NAVIGATIONTITLE;
    customerL.font = FONT(12);
    if (![self isBlankString:_custSourceData.customerEffective]) {
        customerL.text = _custSourceData.customerEffective;
        customerL.numberOfLines = 0;
        customerL.lineBreakMode = NSLineBreakByWordWrapping;
        [self setLabelSpace:customerL withValue:customerL.text withFont:FONT(12)];
        customerL.height = [self getSpaceLabelHeight:customerL.text withFont:FONT(12) withWidth:customerL.width];
    }
    [middleView addSubview:customerL];
    
    middleView.height = customerL.bottom+15;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, middleView.bottom, kMainScreenWidth, 44)];
    bgView.backgroundColor =[UIColor colorWithHexString:@"f0eff5"];
    [view addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (44-14)/2, 16, 14)];
    imageView.image = [UIImage imageNamed:@"为您推荐.png"];
    
    [bgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+15/2, 0, 200, 44)];
    label.textColor = NAVIGATIONTITLE;
    label.font = [UIFont boldSystemFontOfSize:15.f];
    label.text = @"更多楼盘为您推荐";
    label.textAlignment =NSTextAlignmentLeft;
    
    [bgView addSubview:label];
    
    if (_tempArr.count>0) {
        imageView.hidden = NO;
        label.hidden = NO;
        bgView.hidden = NO;
        view.height = bgView.bottom;
    }else{
        UIImageView *noDataImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-450.0/2)/2, bgView.bottom+(self.tableView.height-bgView.bottom-133.0/2-23)/2, 450.0/2, 133.0/2)];
        [noDataImgView setImage:[UIImage imageNamed:@"notFound"]];
        [view addSubview:noDataImgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, noDataImgView.bottom+10, kMainScreenWidth, 13)];
        titleLabel.text = @"没有可推荐楼盘";
        titleLabel.font = FONT(12.f);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = NAVIGATIONTITLE;
        [view addSubview:titleLabel];
        view.height = titleLabel.bottom;
    }
    self.tableView.tableHeaderView = view;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tempArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BuildingListData *listData;
    if (indexPath.row<_tempArr.count) {
        listData = [_tempArr objectForIndex:indexPath.row];
    }
    
    return [BuildingCell buildingCellHeightWithModel:listData WithbuildingStyle:HomeTableViewCellStyle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"_tempArr.count====%zd",_tempArr.count);
    BuildingListData *listData;
    if (indexPath.row<_tempArr.count) {
        listData = [_tempArr objectForIndex:indexPath.row];
    }
    BuildingCell *cell = [[BuildingCell alloc]initWithStyle:HomeTableViewCellStyle andBuildListData:listData];
    cell.isShouldStartImage = YES;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingListData *listData = [_tempArr objectForIndex:indexPath.row];
    
    if ([listData.status isEqualToString:@"expired"] || [listData.status isEqualToString:@"finished"]) {
        
        AlertShow(@"该楼盘合作已到期，无法查看楼盘详情。");
        return;
        
    }
    BuildingDetailViewController *VC = [[BuildingDetailViewController alloc]init];
    
    VC.buildingId = listData.buildingId;
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)toggleSaveBtn:(UIButton*)sender
{
    if (self.type == 2)
    {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[BuildingDetailViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else if (self.type == 3)
    {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[MyBuildingViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }
}

#define UILABEL_LINE_SPACE 5
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
    //                          };
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

-(void)setEvaluationLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
    //                          };
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"888888"]
                         range:NSMakeRange(0, 5)];
    label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
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

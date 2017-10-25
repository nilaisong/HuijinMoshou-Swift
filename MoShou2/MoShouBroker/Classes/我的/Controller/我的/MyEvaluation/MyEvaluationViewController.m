//
//  MyEvaluationViewController.m
//  MoShou2
//
//  Created by wangzz on 2017/3/6.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import "MyEvaluationViewController.h"
#import "MyEvaluationTableViewCell.h"
#import "UITableView+XTRefresh.h"
#import "DataFactory+Customer.h"
#import "UserData.h"

@interface MyEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView         *tableView;
@property (nonatomic, strong) NSMutableArray      *evaluationsArr;
@property (nonatomic, assign) int                  page;//加载更多时的页码
@property (nonatomic, assign) BOOL                 morePage;//是否有下一页

@end

@implementation MyEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleLabel.text = @"我的评价";
    self.view.backgroundColor = VIEWBGCOLOR;
    _evaluationsArr = [[NSMutableArray alloc] init];
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
    [self layoutUI];
    
//    for (int i=0; i<10; i++) {
//        EvaluationData *data = [[EvaluationData alloc] init];
//        data.custName = @"王fee";
//        data.create_time = @"2017-3-12 09:18:36";
//        data.mobile = @"13789021578";
//        data.customer_review_score = @"10.0";
//        NSString *contentStr = @"正文内容正文内容正文内容正文内容正文内容正文内容正文内容正文内容正文内容正文内容正文内容正文内容";
//        if (i == 2 || i == 5) {
//            contentStr = @"正文内容正文内容正文内容正";
//        }else if (i == 0 || i == 8)
//        {
//            contentStr = @"正文内容正文就够了空间啊刘哦俄罗斯片wilds；为少；为；点击从打开佛山肯定是疯了的反馈舒服是；都快烦死了的开发商；都快烦；是搭镂空防晒的是佛佩服小聪明 v的 v今个 v 了苏门答腊开发陌生的风景哦诶烦死了都快疯了谁的封建时代方式内容正文内容正文内容正文内容正文内容正文内容正文内容正文内容";
//        }
//        data.customer_review_summary = contentStr;
//        data.estateName = @"拉萨测试楼盘拉萨测试楼盘   拉萨测试楼盘拉萨测试楼盘   拉萨测试楼盘拉萨测试楼盘   拉萨测试楼盘拉萨测试楼盘";
//        [_evaluationsArr addObject:data];
//    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [UserData sharedUserData].userId;
    if (![self isBlankString:userId]) {
        [dic setValue:userId forKey:@"agencyUserId"];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [dic setValue:PAGESIZE forKey:@"pageSize"];
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getEvaluationWithDict:dic withCallBack:^(ActionResult *actionResult, DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (actionResult.success) {
//                if (_evaluationsArr.count > 0) {
//                    [_evaluationsArr removeAllObjects];
//                }
                if (result.dataArray.count > 0) {
                    [_evaluationsArr addObjectsFromArray:result.dataArray];
                    self.morePage = result.morePage;
                    [self.tableView setFooterViewHidden:!self.morePage];
                    [self.tableView reloadData];
                }
                else
                {
                    [self tempView];
                }
                
            }else
            {
                [self showTips:actionResult.message];
            }
        });
    }];
}

- (void)footerRereshing
{
    _page++;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [UserData sharedUserData].userId;
    if (![self isBlankString:userId]) {
        [dic setValue:userId forKey:@"agencyUserId"];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [dic setValue:PAGESIZE forKey:@"pageSize"];
    __weak typeof(self) weakSelf = self;
    if (![self createNoNetWorkViewWithReloadBlock:^{
        [weakSelf requestNextEvaluationWithDic:dic];
    }])
    {
        [self requestNextEvaluationWithDic:dic];
    }
}

- (void)requestNextEvaluationWithDic:(NSMutableDictionary*)dic
{
    UIImageView* loadingView = [self setRotationAnimationWithView];
    [[DataFactory sharedDataFactory] getEvaluationWithDict:dic withCallBack:^(ActionResult *actionResult, DataListResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeRotationAnimationView:loadingView];
            if (actionResult.success) {
                if (!actionResult.success) {
                    [self showTips:actionResult.message];
                }
                [self.evaluationsArr addObjectsFromArray:result.dataArray];
                self.morePage = result.morePage;
                [self.tableView setFooterViewHidden:!self.morePage];
                [self.tableView reloadData];
            }else
            {
                [self showTips:actionResult.message];
            }
        });
    }];
}

- (void)layoutUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, viewTopY, kMainScreenWidth, self.view.bounds.size.height-viewTopY) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf performSelector:@selector(footerRereshing) withObject:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _evaluationsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyEvaluationTableViewCell *cell = [[MyEvaluationTableViewCell alloc] init];
    
    EvaluationData *evalData = (EvaluationData*)[_evaluationsArr objectForIndex:indexPath.row];
    
    //姓名
    if(evalData.custName.length != 0)
    {
        CGSize nameLabelSize = [evalData.custName sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
        cell.nameLabel.width = nameLabelSize.width;
        cell.nameLabel.text = evalData.custName;
    }
    
    //手机号
    if(evalData.mobile.length != 0)
    {
        cell.telLabel.left = cell.nameLabel.right + 10;
        NSString *telStr = evalData.mobile;
        NSString *str = @"";
        if (![self isBlankString:telStr] && telStr.length==11) {
            str = [NSString stringWithFormat:@"%@ %@ %@",[telStr substringWithRange:NSMakeRange(0, 3)],[telStr substringWithRange:NSMakeRange(3, 4)],[telStr substringWithRange:NSMakeRange(7, 4)]];
            CGSize telLabelSize = [str sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
            cell.telLabel.width = telLabelSize.width;
        }
        else
        {
            str = telStr;
        }
        cell.telLabel.text = str;
    }
    
    //评分
    if (evalData.customer_review_score.length != 0)
    {
        NSString *title = [NSString stringWithFormat:@" %@分", evalData.customer_review_score];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT(15)}];
        CGSize contentSize = [@"评分:" sizeWithAttributes:@{NSFontAttributeName:FONT(10.0)}];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评分: %@分",evalData.customer_review_score]];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"888888"],NSFontAttributeName:[UIFont systemFontOfSize:10.0]} range:NSMakeRange(0, 3)];
        
        cell.scoreLabel.left = (cell.scoreLabel.left + 30) - (titleSize.width + contentSize.width + 10);
        cell.scoreLabel.width = titleSize.width + contentSize.width;
        cell.scoreLabel.bottom = cell.nameLabel.bottom;
        cell.scoreLabel.attributedText = attributeStr;
    }
    
    //适配下 姓名的宽度
    UIView *superView = cell.nameLabel.superview;
    CGFloat superViewWidth = superView.frame.size.width;
    CGFloat totalWidth = cell.nameLabel.left + cell.nameLabel.width + 10 + cell.telLabel.width + 10 + cell.scoreLabel.width + 10;
    if (totalWidth > superViewWidth)
    {
        cell.nameLabel.width = superViewWidth - (cell.nameLabel.left + 10 + cell.telLabel.width + 10 + cell.scoreLabel.width + 10);
        cell.telLabel.left = cell.nameLabel.right + 10;
    }
    
    //楼盘
    if (evalData.estateName.length != 0)
    {
        cell.buildLabel.text = evalData.estateName;
    }
    
    //评价内容
    NSString *title = [NSString stringWithFormat:@"带看评价:   %@", evalData.customer_review_summary];
    CGSize contentSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    cell.evaluationLabel.text = title;
    if (contentSize.width > cell.evaluationLabel.width) {
        [self setEvaluationLabelSpace:cell.evaluationLabel withValue:title withFont:FONT(13)];
        CGFloat titleHeight = [self getSpaceLabelHeight:title withFont:FONT(13) withWidth:cell.evaluationLabel.width];
        cell.evaluationLabel.height = titleHeight;
    }
    else
    {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"888888"]
                             range:NSMakeRange(0, 5)];
        cell.evaluationLabel.attributedText = attributeStr;
    }

    //日期
    NSDate *date = getNSDateWithDateTimeString(evalData.create_time);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    cell.dateTimeLabel.text = dateStr;
    CGSize dateSize = [dateStr sizeWithAttributes:@{NSFontAttributeName:FONT(10)}];
    cell.dateTimeLabel.top = cell.evaluationLabel.bottom + 15;
    cell.dateTimeLabel.width = dateSize.width;

    cell.lineLabel.top = cell.dateTimeLabel.bottom + 15;
//    if (indexPath.row == _evaluationsArr.count-1) {
//        cell.lineLabel.hidden = YES;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationData *evalData = (EvaluationData*)[_evaluationsArr objectForIndex:indexPath.row];
    
    MyEvaluationTableViewCell *cell = [[MyEvaluationTableViewCell alloc] init];

    UIImage *avaterImg = [UIImage imageNamed:@"客户默认头像"];
    
    NSString *title = [NSString stringWithFormat:@"带看评价:   %@", evalData.customer_review_summary];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];
    CGFloat titleHeight = titleSize.height;
    if (titleSize.width > cell.evaluationLabel.width) {
        titleHeight = [self getSpaceLabelHeight:title withFont:FONT(13) withWidth:cell.evaluationLabel.width];
    }
    
    CGSize dataSize = [@"2017-07-21" sizeWithAttributes:@{NSFontAttributeName:FONT(13)}];

    
    return 15 + avaterImg.size.height + 15 + titleHeight + 15 + dataSize.height + 25;
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

#pragma mark 空白也没有数据
-(void)tempView{
    [self.tableView setHidden:YES];
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, 64+44+(kMainScreenWidth-64-44-30)/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    //    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc]initWithString:@"没有数据"];
    //    [tipText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 11)];
    CGSize ss = [@"没有数据" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setText:@"没有数据"];
    [self.view addSubview:tip];
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

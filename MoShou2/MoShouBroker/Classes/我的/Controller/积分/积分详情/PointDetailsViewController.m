//
//  PointDetailsViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/1.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "PointDetailsViewController.h"
#import "HMTool.h"
#import "DataFactory+User.h"
//#import "MJRefresh.h"
#import "UITableView+XTRefresh.h"
#import "UserData.h"
#import "PointRulesViewController.h"
#import "QuickReportViewController.h"
#import "PointDetailCellTableViewCell.h"
@interface PointDetailsViewController ()

@end

@implementation PointDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self.table setHidden:YES];
    [self loadDefaultData];
    
}
-(void)initUI{
    self.navigationBar.titleLabel.text = @"积分明细";
   
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"积分规则" forState:UIControlStateNormal];
    [btn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    CGSize btnSize = [HMTool getTextSizeWithText:btn.titleLabel.text andFontSize:15];
    [btn setFrame:CGRectMake(kMainScreenWidth-9-btnSize.width, kFrame_Y(self.navigationBar.leftBarButton)+13, btnSize.width, btnSize.height)];
    [btn addTarget:self action:@selector(pointRuleView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:btn];
    
    self.table =[[UITableView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, self.view.bounds.size.height-kFrame_Height(self.navigationBar))];
    [self.table  setBackgroundColor:[UIColor whiteColor]];
    [self.table  setDelegate:self];
    [self.table  setDataSource:self];
    self.table .separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table ];
    [self addFooter];

    self.table.legendFooter.hidden = YES;
  
    

}
-(void)pointRuleView{
    PointRulesViewController *rules = [[PointRulesViewController alloc]init];
    [self.navigationController pushViewController:rules animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.pointDetailList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PointDetailCellTableViewCell *cell = [[PointDetailCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    PointsModel *pointDate =(PointsModel *)[self.pointDetailList objectForIndex:indexPath.row];
    if (pointDate) {
        [cell.titleLabel setTextColor:NAVIGATIONTITLE];
        [cell.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.titleLabel setText:pointDate.ruleName];
        CGSize size = [HMTool getTextSizeWithText:cell.titleLabel.text andFontSize:14];
        [cell.titleLabel setFrame:CGRectMake(25, 15, size.width, size.height)];
        
        [cell.timeLabel setTextColor:POINTMALLGRAYLABELCOLOR];
        [cell.timeLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.timeLabel setText:pointDate.operationTime];
        CGSize timeSize = [HMTool getTextSizeWithText:cell.timeLabel.text andFontSize:14];
        [cell.timeLabel setFrame:CGRectMake(25, kFrame_YHeight(cell.titleLabel)+10, timeSize.width, timeSize.height)];
        [cell.pointLabel setTextColor:BLUEBTBCOLOR];
        [cell.pointLabel setFont:[UIFont systemFontOfSize:14]];
       
        [cell.pointLabel setText:[NSString stringWithFormat:@"%@%@",pointDate.ruleOpt,pointDate.point ]];
        CGSize numSize = [HMTool getTextSizeWithText:cell.pointLabel.text andFontSize:14];
        [cell.pointLabel setFrame:CGRectMake(kMainScreenWidth-25-numSize.width, kFrame_YHeight(cell.titleLabel)+10, numSize.width, numSize.height)];
        if (size.width>(kMainScreenWidth-numSize.width)) {
            [cell.titleLabel setFrame:CGRectMake(25, 15,kMainScreenWidth-numSize.width, size.height)];
        }


    }
      return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *v =[[UIView alloc]init];
    UIView *l =[HMTool getLineWithFrame:CGRectMake(0, 60, kMainScreenWidth, 0.5) andColor:LINECOLOR];
    [v addSubview:l];
    [v setBackgroundColor:[UIColor whiteColor]];
    NSString *num =[UserData sharedUserData].userInfo.points;
    UILabel *title =[[UILabel alloc]init];
    [title setText:@"累计积分"];
    [title setTextColor:POINTMALLGRAYLABELCOLOR];
    [title setFont:[UIFont systemFontOfSize:12]];
    CGSize titleSize =[HMTool getTextSizeWithText:title.text andFontSize:12];
    [title setFrame:CGRectMake(kMainScreenWidth/2-titleSize.width, 30, titleSize.width, titleSize.height)];
    [v addSubview:title];

    UILabel *numLb =[[UILabel alloc]init];
    [numLb setFont:[UIFont systemFontOfSize:20]];
    [numLb setText:num];
    [numLb setTextColor:BLUEBTBCOLOR];
    CGSize numSze =[HMTool getTextSizeWithText:num andFontSize:20];
    [numLb setFrame:CGRectMake(kFrame_XWidth(title)+5, 20, numSze.width, numSze.height)];
    [v addSubview:numLb];
    numLb.centerY = title.centerY;
    
    return v;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshFirstPageDate{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        [[AccountDataProvider sharedInstance] getPointsListWithPageIndex:@"1" completionClosure:^(ResponseResult * result)
        {
            NSArray * array = result.data;
            if(array.count>0)
            {
                self.pointDetailList = [NSMutableArray arrayWithArray:array];
                self.morePage = result.page.morePage;
                if (self.morePage) {
                    self.table.legendFooter.hidden = NO;
                    
                }else{
                    self.table.legendFooter.hidden = YES;
                }
                self.page = 1;
                [self.table.legendHeader endRefreshing];
                
                [self.table reloadData];
                
            }else{
                
                self.table.legendFooter.hidden = YES;
                
                [self tempView];
                
            }
            
        }];
        /*
        [[DataFactory sharedDataFactory]getPointDataWithPage:[NSString stringWithFormat:@"%d",1] andCallBack:^(DataListResult *result) {
            if(result.dataArray.count>0){
                self.pointDetailList = [NSMutableArray arrayWithArray:result.dataArray];
                self.morePage = result.morePage;
                if (self.morePage) {
                    self.table.legendFooter.hidden = NO;
                    
                }else{
                    self.table.legendFooter.hidden = YES;
                }
                self.page = 1;
                [self.table.legendHeader endRefreshing];
                
                [self.table reloadData];
                
            }else{
                
                self.table.legendFooter.hidden = YES;
                
                [self tempView];
                
            }
            
        }];
*/
    }
}

-(void)getfirstDateList{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        UIImageView *loading = [self setRotationAnimationWithView];
        [[AccountDataProvider sharedInstance] getPointsListWithPageIndex:@"1" completionClosure:^(ResponseResult * result) {
            [self.table setHidden:NO];
            NSArray* array = result.data;
            if(array.count>0){
                self.pointDetailList = [NSMutableArray arrayWithArray:array];
                self.morePage = result.page.morePage;
                if (self.morePage) {
                    self.table.legendFooter.hidden = NO;
                    
                }else{
                    self.table.legendFooter.hidden = YES;
                }
                self.page = 1;
                //    [self.table.footer endRefreshing];
                [self.table.legendHeader endRefreshing];
                
                [self.table reloadData];
                [self addHeader];
                [self removeRotationAnimationView:loading];
            }else{
                //        [self.table.footer endRefreshing];
                
                self.table.legendFooter.hidden = YES;
                
                [self tempView];
                [self removeRotationAnimationView:loading];
                
            }
        }];
//        [[DataFactory sharedDataFactory]getPointDataWithPage:[NSString stringWithFormat:@"%d",1] andCallBack:^(DataListResult *result) {
//            [self.table setHidden:NO];
//
//            if(result.dataArray.count>0){
//                self.pointDetailList = [NSMutableArray arrayWithArray:result.dataArray];
//                self.morePage = result.morePage;
//                if (self.morePage) {
//                    self.table.legendFooter.hidden = NO;
//
//                }else{
//                    self.table.legendFooter.hidden = YES;
//                }
//                self.page = 1;
//                //    [self.table.footer endRefreshing];
//                [self.table.legendHeader endRefreshing];
//
//                [self.table reloadData];
//                [self addHeader];
//                [self removeRotationAnimationView:loading];
//            }else{
//                //        [self.table.footer endRefreshing];
//
//                self.table.legendFooter.hidden = YES;
//
//                [self tempView];
//                [self removeRotationAnimationView:loading];
//
//            }
//
//        }];

    }
}
-(void)getMorePintDataList{
    
    [[AccountDataProvider sharedInstance] getPointsListWithPageIndex:[NSString stringWithFormat:@"%d",self.page] completionClosure:^(ResponseResult * result)
    {
        NSArray * array = result.data;
        if(array.count>0){
            [self.pointDetailList  addObjectsFromArray:array];
            self.morePage = result.page.morePage;
            if (self.morePage) {
                self.table.legendFooter.hidden = NO;
                
            }else{
                self.table.legendFooter.hidden = YES;
            }
            [self.table.legendFooter endRefreshing];
            [self.table.legendHeader endRefreshing];
            
            [self.table reloadData];
        }else{
            self.table.legendFooter.hidden = YES;
            [self.table.legendFooter endRefreshing];
            [self.table.legendHeader endRefreshing];
            
            [self tempView];
        }
    }];
    
//    [[DataFactory sharedDataFactory]getPointDataWithPage:[NSString stringWithFormat:@"%d",self.page] andCallBack:^(DataListResult *result) {
//        if(result.dataArray.count>0){
//            [self.pointDetailList  addObjectsFromArray:result.dataArray];
//            self.morePage = result.morePage;
//            if (self.morePage) {
//                self.table.legendFooter.hidden = NO;
//
//            }else{
//                self.table.legendFooter.hidden = YES;
//            }
//            [self.table.legendFooter endRefreshing];
//            [self.table.legendHeader endRefreshing];
//
//            [self.table reloadData];
//        }else{
//            self.table.legendFooter.hidden = YES;
//            [self.table.legendFooter endRefreshing];
//            [self.table.legendHeader endRefreshing];
//
//            [self tempView];
//        }
//    }];
}
// 添加头部
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.table addLegendHeaderWithRefreshingBlock:^{
        vc.page = 1;
        [vc refreshFirstPageDate];
    }];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.table addLegendFooterWithRefreshingBlock:^{
        vc.page ++;
        [vc getMorePintDataList];
    }];
}
-(void)loadDefaultData{
    self.page = 1;
    self.morePage = NO;

    __weak typeof(self) blockSelf= self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[blockSelf getfirstDateList];}]) {
        [blockSelf getfirstDateList];
    }
}
-(void)tempView{
    [self.table setHidden:YES];
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, self.view.bounds.size.height/2-111/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc]initWithString:@"您还没有积分哦，先去报备客户赚取积分吧！"];
    [tipText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 11)];
    CGSize ss = [@"您还没有积分哦，先去报备客户赚取积分吧！" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setAttributedText:tipText];
    [self.view addSubview:tip];
    tip.userInteractionEnabled = YES;
    UIGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popToCustomerReportView)];
    [tip addGestureRecognizer:tap];
    
}
-(void)popToCustomerReportView{
    QuickReportViewController *cu =[[QuickReportViewController alloc]init];
    [self.navigationController pushViewController:cu animated:YES];
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

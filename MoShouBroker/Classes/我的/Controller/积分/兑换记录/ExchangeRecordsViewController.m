//
//  ExchangeRecordsViewController.m
//  MoShou2
//
//  Created by Aminly on 15/11/30.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "ExchangeRecordsViewController.h"
#import "HMTool.h"
#import "UIColor+Hex.h"
#import "UITableView+XTRefresh.h"
#import "DataFactory+User.h"
#import "ExchangeRecord.h"
#import "UITableViewRowAction+JZExtension.h"
#import "ExchangeRecordsCell.h"
@interface ExchangeRecordsViewController ()

@end

@implementation ExchangeRecordsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self loadDefaultData];
}
-(void)initUI{
    
    self.navigationBar.titleLabel.text = @"兑换记录";
   self.exchangeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, kMainScreenHeight-kFrame_Height(self.navigationBar))];
    [ self.exchangeTable setDelegate:self];
    [ self.exchangeTable setDataSource:self];
     self.exchangeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.exchangeTable];
    [self addFooter];
    [self.exchangeTable.legendFooter setHidden:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 105;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.exchangeListArr.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExchangeRecordsCell *cell = [[ExchangeRecordsCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    ExchangeRecord *record = (ExchangeRecord *)[self.exchangeListArr objectForIndex:indexPath.row];
    if (record) {

        [cell.exchangeImage setImageWithUrlString:record.thmUrl placeholderImage:[UIImage imageNamed:@"默认图片"]];
        [cell.nameLabel setText:record.goodsName];
        CGSize titleSize =[HMTool getTextSizeWithText:cell.nameLabel.text andFontSize:14];
        [cell.nameLabel setFrame:CGRectMake(kFrame_XWidth(cell.exchangeImage)+15, cell.exchangeImage.centerY-titleSize.height, titleSize.width, titleSize.height)];
        
        
        NSString *num =[record.costPoint stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *attriStr =[NSString stringWithFormat:@"%@ 积分",num];
        NSMutableAttributedString *attributeStr =[[NSMutableAttributedString alloc]initWithString:attriStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#fc6d33"] range:NSMakeRange(0,num.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8f8e93"] range:NSMakeRange(num.length, 3)];    //@"20000";
        [cell.coastLabel setFont:[UIFont systemFontOfSize:14]];
        CGSize numSize = [HMTool getTextSizeWithText:attriStr andFontSize:14];
        [cell.coastLabel setFrame:CGRectMake(kFrame_X(cell.nameLabel), cell.exchangeImage.centerY+numSize.height, numSize.width, numSize.height)];
        [cell.coastLabel setAttributedText:attributeStr];
        
        [cell.numLabel setText:@"x1"];
        [cell.numLabel setTextColor:POINTMALLGRAYLABELCOLOR];
        [cell.numLabel setFont:[UIFont systemFontOfSize:12]];
        CGSize remainNumSize = [HMTool getTextSizeWithText:cell.numLabel.text andFontSize:14];
        [cell.numLabel setFrame:CGRectMake(kFrame_XWidth(cell.nameLabel)+8,kFrame_Y(cell.nameLabel), remainNumSize.width, remainNumSize.height)];
        
        
        
        [cell.timeLabel setText:record.applyConvertTime];
        [cell.timeLabel setFont:[UIFont systemFontOfSize:12]];
        CGSize timeLBSize = [HMTool getTextSizeWithText:cell.timeLabel.text andFontSize:12];
        [cell.timeLabel setFrame:CGRectMake(kMainScreenWidth-16-timeLBSize.width,kFrame_Y(cell.nameLabel), timeLBSize.width, timeLBSize.height)];
        if (kFrame_XWidth(cell.nameLabel)+kFrame_Width(cell.numLabel)>kFrame_X(cell.timeLabel)) {
            [cell.nameLabel setFrame:CGRectMake(kFrame_XWidth(cell.exchangeImage)+15, cell.exchangeImage.centerY-titleSize.height,kFrame_X(cell.timeLabel)-10-kFrame_Width(cell.numLabel)-(kFrame_XWidth(cell.exchangeImage)+15), titleSize.height)];
            [cell.numLabel setFrame:CGRectMake(kFrame_XWidth(cell.nameLabel)+8,kFrame_Y(cell.nameLabel), remainNumSize.width, remainNumSize.height)];
            [cell.timeLabel setFrame:CGRectMake(kMainScreenWidth-16-timeLBSize.width,kFrame_Y(cell.nameLabel), timeLBSize.width, timeLBSize.height)];

        }
    
        if ([record.convertStatus isEqualToString:@"兑换成功"]) {
            [cell.statusLabel setText:@"兑换成功"];
            [cell.statusLabel setTextColor:BLUEBTBCOLOR];

        }else if([record.convertStatus isEqualToString:@"兑换失败"]){
            [cell.statusLabel setText:@"兑换失败"];
            [cell.statusLabel setTextColor:[UIColor colorWithHexString:@"f01717"]];
            


        }else if([record.convertStatus isEqualToString:@"待处理"]){
            [cell.statusLabel setText:@"待处理"];
            [cell.statusLabel setTextColor:[UIColor colorWithHexString:@"fc6c33"]];


        }
        [cell.statusLabel setFont:[UIFont systemFontOfSize:12]];
        CGSize statusSize = [HMTool getTextSizeWithText:cell.statusLabel.text andFontSize:12];
        [cell.statusLabel setFrame:CGRectMake(kMainScreenWidth-16-statusSize.width,kFrame_Y(cell.coastLabel), statusSize.width, statusSize.height)];
        
        

    }
   
    

    
    return  cell;
}
-(void)refrshFirstDate{

    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        //        UIImageView *loading = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]getExchangeDataWithPage:[NSString stringWithFormat:@"%d",1] andCallBack:^(DataListResult *result) {
            
            if (result.dataArray.count>0) {
                self.exchangeListArr = [NSMutableArray arrayWithArray:result.dataArray];
                self.morePage =result.morePage;
                self.page = 1;
                if (self.morePage) {
                    [self.exchangeTable.legendFooter setHidden:NO];
                }else{
                    [self.exchangeTable.legendFooter setHidden:YES];
                }
                [self.exchangeTable.legendFooter endRefreshing];
                [self.exchangeTable.legendHeader endRefreshing];
                [self.exchangeTable reloadData];
                
            }else{
                [self.exchangeTable.legendFooter endRefreshing];
                [self.exchangeTable.legendHeader endRefreshing];
                
                [self.exchangeTable.legendFooter setHidden: YES];
                [self tempView];
                
                
            }
            [self addHeader];
            
        }];
        
    }
    

}
-(void)getFirstData{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView *loading = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]getExchangeDataWithPage:[NSString stringWithFormat:@"%d",1] andCallBack:^(DataListResult *result) {
            
            if (result.dataArray.count>0) {
                self.exchangeListArr = [NSMutableArray arrayWithArray:result.dataArray];
                self.morePage =result.morePage;
                self.page = 1;
                if (self.morePage) {
                    [self.exchangeTable.legendFooter setHidden:NO];
                }else{
                    [self.exchangeTable.legendFooter setHidden:YES];
                }
                [self.exchangeTable.legendFooter endRefreshing];
                [self.exchangeTable.legendHeader endRefreshing];
                [self.exchangeTable reloadData];
                [self removeRotationAnimationView:loading];

            }else{
                [self.exchangeTable.legendFooter endRefreshing];
                [self.exchangeTable.legendHeader endRefreshing];

                [self.exchangeTable.legendFooter setHidden: YES];
                [self tempView];
                [self removeRotationAnimationView:loading];

                
            }
            [self addHeader];

        }];

    }
    

}
-(void)getMorePageData{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[DataFactory sharedDataFactory]getExchangeDataWithPage:[NSString stringWithFormat:@"%d",self.page] andCallBack:^(DataListResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{

            if (result.dataArray.count>0) {
                [self.exchangeTable.legendFooter endRefreshing];
                [self.exchangeListArr addObjectsFromArray:result.dataArray];

                self.morePage = result.morePage;
                if (self.morePage) {
                    [self.exchangeTable.legendFooter setHidden:NO];
                }else{
                    [self.exchangeTable.legendFooter setHidden:YES];
                }
                [self.exchangeTable reloadData];
                
            }else{
                [self.exchangeTable.legendFooter endRefreshing];
                [self.exchangeTable.legendFooter setHidden: YES];
                [self tempView];
            }
            });
        }];

    }

}
// 添加头部
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.exchangeTable addLegendHeaderWithRefreshingBlock:^{
        vc.page = 1;
        [vc refrshFirstDate];
    }];
}
-(void)addFooter{
    __unsafe_unretained typeof(self) vc = self;
    [self.exchangeTable addLegendFooterWithRefreshingBlock:^{
        vc.page ++;
        [vc getMorePageData];
    }];


}
-(void)loadDefaultData{
    self.page = 1;
    self.morePage = NO;
    __weak typeof(self) blockSelf= self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[blockSelf getFirstData];}]) {
        [self getFirstData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tempView{
    [self.exchangeTable setHidden:YES];
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, kMainScreenHeight/2-111/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc]initWithString:@"您还没有兑换记录哦 先去逛逛吧！"];
    [tipText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(10, 5)];
    CGSize ss = [@"您还没有兑换记录哦 先去逛逛吧！" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setAttributedText:tipText];
    [self.view addSubview:tip];
    tip.userInteractionEnabled = YES;
    UIGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [tip addGestureRecognizer:tap];
    
}
//- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"loupan删除"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
//        [self deleteExchengRecordWitnIndexPath:indexPath];
//        
//    }];
//    
//    return @[action1];
//}
//-(void)deleteExchengRecordWitnIndexPath:(NSIndexPath *)indexPath{
//    ExchangeRecord *recored =(ExchangeRecord*)[self.exchangeListArr objectForIndex:indexPath.row];
//    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//        UIImageView *loo = [self setRotationAnimationWithView];
//        [[DataFactory sharedDataFactory]deleteExchangeWithExchangeRecord:recored andCallBack:^(ActionResult *result) {
//            if (result.success) {
//                [TipsView showTipsCantClick:result.message inView:self.view];
//                [self.exchangeListArr removeObjectForIndex:indexPath.row];
//                [self.exchangeTable reloadData];
//                if (self.exchangeListArr.count<=0) {
//                    [self tempView];
//                }
//                [self removeRotationAnimationView:loo];
//            }else{
//                [TipsView showTipsCantClick:result.message  inView:self.view];
//                [self removeRotationAnimationView:loo];
//
//            }
//        }];
//
//    }
//    
//}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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

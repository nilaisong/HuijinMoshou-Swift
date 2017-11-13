//
//  MessageCenterViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/1.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "UITableViewRowAction+JZExtension.h"
#import "HMTool.h"
#import "UILabel+StringFrame.h"
#import "MessageDetailViewController.h"
#import "DataFactory+User.h"
#import "DataFactory+Customer.h"
#import "NetworkSingleton.h"
#import "MJRefresh.h"
#import "UserData.h"
#import "MessageTableViewCell.h"
#import "BaseNavigationController.h"
@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_oneKeyRead;
    UITableView *_msgTableView;
    NSIndexPath *_clickedIndexPath;
    NSMutableArray *_deletedArr;
    UIImageView *_redDot;
    BOOL        bShowOneKey;
}

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadDefaultData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)initUI{
    
    _deletedArr = [[NSMutableArray alloc]init];
    self.navigationBar.titleLabel.text = @"历史记录";
    _oneKeyRead =[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-16-70, kFrame_Y(self.navigationBar.leftBarButton)+10,80,30)];
    [_oneKeyRead setTitle:@"一键已读" forState:UIControlStateNormal];
    CGSize towSize =[@"中心" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    _redDot = [[UIImageView alloc]initWithFrame:CGRectMake(kFrame_Width(self.navigationBar)/2+towSize.width+3, kFrame_Y(self.navigationBar.leftBarButton)+10, 6, 6)];
    [_redDot setImage:[UIImage imageNamed:@"椭圆-7"]];
    [self.navigationBar addSubview:_redDot];
    if (bShowOneKey) {
        [_oneKeyRead setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
        [_oneKeyRead setEnabled:YES];
        [_redDot setHidden:NO];

    }else{
        [_oneKeyRead setEnabled:NO];
        [_oneKeyRead setTitleColor:LINECOLOR forState:UIControlStateNormal];
        [_redDot setHidden:YES];
    }
    _oneKeyRead.titleLabel.font =[UIFont systemFontOfSize:15];
    [_oneKeyRead addTarget: self action:@selector(oneKeyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:_oneKeyRead];
    _msgTableView = [[UITableView alloc]init];
    [_msgTableView setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, self.view.bounds.size.height-kFrame_Height(self.navigationBar))];
    [_msgTableView setDelegate:self];
    [_msgTableView setDataSource:self];
    _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_msgTableView];
    [self addFooter];
    [_msgTableView.footer setHidden:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableViewWithIndexPath) name:@"refreshTableView" object:nil];
}
//一键已读按钮
-(void)oneKeyAction{
    [MobClick event:@"lsjl_yjyd"];//消息中心-历史记录-一键已读
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView *loading =[self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]onKeyReadAllMessageWithCallback:^(ActionResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.success) {
                    [TipsView showTipsCantClick:@"一键已读成功" inView:self.view];
                    [self getfirstPage];
                    [_redDot setHidden:YES];
                    bShowOneKey = NO;
                    [_oneKeyRead setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
                    [_oneKeyRead setEnabled: NO];
                    [self removeRotationAnimationView:loading];
                }else{
                    [TipsView showTipsCantClick:result.message inView:self.view];
                    [_redDot setHidden:NO];
                    [_oneKeyRead setTitleColor:LINECOLOR forState:UIControlStateNormal];
                    bShowOneKey = YES;
                    [_oneKeyRead setEnabled:YES];
                    [self removeRotationAnimationView:loading];

                }});
        }];

    }
    
}
//刷新页面
-(void)refreshUI{
    [[DataFactory sharedDataFactory] getOldUnreadMessageCountWithCallback:^(NSNumber *num) {
        int msgCount = num.intValue;
        if (msgCount>0 ){
            bShowOneKey = YES;
            [_redDot setHidden:NO];
            [_oneKeyRead setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
            [_oneKeyRead setEnabled:YES];

        }else{
            [_redDot setHidden:YES];
            [_oneKeyRead setTitleColor:LINECOLOR forState:UIControlStateNormal];
            bShowOneKey = NO;
            [_oneKeyRead setEnabled:NO];

        }
    }];

}

-(void)loadDefaultData{
    self.page = 1;
    self.morePage = NO;
    __weak typeof(self) blockSelf= self;
    if (![self createNoNetWorkViewWithReloadBlock:^{[blockSelf getfirstPage];}]) {
        [self getfirstPage];
    }
}

-(void)refreshTableViewWithIndexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_msgTableView reloadData];
    });
    [self refreshUI];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 97;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
//添加自定义侧滑删除
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"xiaoxi删除"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        [self deleteMessageWithIndexPath:indexPath];
        
    }];
 
    return @[action1];
}
//删除按钮点击事件
-(void)deleteMessageWithIndexPath:(NSIndexPath *)indexPath
{
    MessageData *data =(MessageData *)[self.listArr objectForIndex:indexPath.row];
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {

        [[DataFactory sharedDataFactory]deleteMessageWithMessageData:data andCallBack:^(ActionResult *result) {
                if (result.success) {
                    if(self.listArr.count > indexPath.row){
                        [self.listArr removeObjectForIndex:indexPath.row];

                    }
                dispatch_async(dispatch_get_main_queue(), ^{
       
                    [_msgTableView reloadData];
                    
                    if (self.listArr.count<=0) {
                        [self tempView];
                    }
                    });

                    [TipsView showTipsCantClick:@"删除成功" inView:self.view];
                }else{
                    [TipsView showTipsCantClick:result.message inView:self.view];
                }
            
        }];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [[MessageTableViewCell alloc]init];

    MessageData *msgData =(MessageData *)[self.listArr objectForIndex:indexPath.row];

    if (msgData.readed) {
        [cell.redDot setHidden:YES];
    }else{
        [cell.redDot setHidden:NO];
    }
    
    [cell.title setText:msgData.title];
    [cell.title setFont:[UIFont systemFontOfSize:16]];
    CGSize titleSize =[HMTool getTextSizeWithText:cell.title.text andFontSize:16];
    [cell.title setFrame:CGRectMake(kFrame_XWidth(cell.redDot)+10, 15, titleSize.width, titleSize.height)];
    
    NSString *timeStr = [msgData.datetime substringWithRange:NSMakeRange(0,16)];
    [cell.time setText:timeStr];
    [cell.time setFont:[UIFont systemFontOfSize:12]];
    [cell.time setTextColor:POINTMALLGRAYLABELCOLOR];
    
    CGSize timeSize =[HMTool getTextSizeWithText:cell.time.text andFontSize:12];
    [cell.time setFrame:CGRectMake(kMainScreenWidth-timeSize.width-16, 15, timeSize.width, timeSize.height)];
    
    [cell.content setFont:[UIFont systemFontOfSize:14]];
    [cell.content setTextColor:POINTMALLGRAYLABELCOLOR];
    [cell.content setFrame:CGRectMake(kFrame_X(cell.title), kFrame_YHeight(cell.title)+8, kMainScreenWidth-32, 96-(kFrame_YHeight(cell.title)+16)-10)];
    cell. content.numberOfLines = 0;
    [cell.content setText:[NSString stringWithFormat:@"%@",msgData.content]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageData *data = nil;
    if (self.listArr.count > indexPath.row) {
        data = (MessageData*)[self.listArr objectForIndex:indexPath.row];
    }
    if (data.readed) {
        MessageDetailViewController *DETAIL =[[MessageDetailViewController alloc]init];
        DETAIL.data = data;
        _clickedIndexPath = indexPath;

        [self.navigationController pushViewController:DETAIL animated:YES];
    }else{
        if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
            [[DataFactory sharedDataFactory]readMessage:data withCallback:^(ActionResult *result) {
                if (result.success) {
                    MessageDetailViewController *DETAIL =[[MessageDetailViewController alloc]init];
                    DETAIL.data = data;
                    _clickedIndexPath = indexPath;
                    [self.navigationController pushViewController:DETAIL animated:YES];
                    
                }else{
                    [TipsView showTipsCantClick:result.message inView:self.view];
                }
                
            }];
        }

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getfirstPage{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        UIImageView* loadingView = [self setRotationAnimationWithView];
        [[DataFactory sharedDataFactory]getMessagesByPage:[NSString stringWithFormat:@"%d",1] WithCallBack:^(DataListResult *result) {

            dispatch_async(dispatch_get_main_queue(), ^{
                self.page = 1;

                if (result.dataArray.count>0) {
                    [self removeRotationAnimationView:loadingView];
                self.listArr = [NSMutableArray arrayWithArray:result.dataArray];
                self.morePage = result.morePage;
                if (self.morePage) {
                    _msgTableView.footer.hidden = NO;
                }else{
                    _msgTableView.footer.hidden = YES;
                }

                [_msgTableView reloadData];

                [_msgTableView.footer endRefreshing];
                }else{
                    [self removeRotationAnimationView:loadingView];
                    [_msgTableView.footer endRefreshing];
                    [self tempView];
                }
                [self refreshUI];
                
                [self addHeader];

                });
        }];
    }
}
-(void)refreshFirstPage{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[DataFactory sharedDataFactory]getMessagesByPage:[NSString stringWithFormat:@"%d",1] WithCallBack:^(DataListResult *result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.page = 1;

            if (result.dataArray.count>0) {
                [self.listArr removeAllObjects];
                self.listArr = [NSMutableArray arrayWithArray:result.dataArray];
                self.morePage = result.morePage;
                if (self.morePage) {
                    _msgTableView.footer.hidden = NO;
                }else{
                    _msgTableView.footer.hidden = YES;
                }
                [_msgTableView reloadData];
                [_msgTableView.footer endRefreshing];
                [_msgTableView.header endRefreshing];
                
            }else{
                [_msgTableView.footer endRefreshing];
                [_msgTableView.header endRefreshing];
                [self tempView];
            }
            });
        }];
    }
}

-(void)getMorePageDataWithPage{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[DataFactory sharedDataFactory]getMessagesByPage:[NSString stringWithFormat:@"%d",self.page] WithCallBack:^(DataListResult *result) {
            dispatch_async(dispatch_get_main_queue(),^{
                           if (result.dataArray.count>0) {
                               self.morePage = result.morePage;
                               [self.listArr addObjectsFromArray:result.dataArray];
                               if (self.morePage) {
                                   _msgTableView.footer.hidden = NO;
                               }else{
                                   _msgTableView.footer.hidden = YES;
                               }
                               [_msgTableView reloadData];
                               [_msgTableView.footer endRefreshing];
                               [_msgTableView.header endRefreshing];
                               
                           }else{
                               [_msgTableView.footer endRefreshing];
                               [_msgTableView.header endRefreshing];
                               
                               [self tempView];
                               
                           }

            });
        }];
    }

}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
//    [_msgTableView addLegendFooterWithRefreshingBlock:^{
//        vc.page ++;
//        [vc getMorePageDataWithPage];
//    }];
    //edit by xiaotei 2017-1-9
    [_msgTableView addFooterWithCallback:^{
        vc.page ++;
        [vc getMorePageDataWithPage];
    }];
}
// 添加头部
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
//    [_msgTableView addLegendHeaderWithRefreshingBlock:^{
//        vc.page = 1;
//        [vc refreshFirstPage];
//    }];
    //edit by xiaotei 2017-1-9
    [_msgTableView addHeaderWithCallback:^{
        vc.page = 1;
        [vc refreshFirstPage];
    }];
}
//没有数据显示空白页面
-(void)tempView{
    [_msgTableView setHidden:YES];
    [_oneKeyRead setEnabled:NO];
    [_oneKeyRead setTitleColor:LINECOLOR forState:UIControlStateNormal];
    UIImageView *tempImage =[[UIImageView alloc]init];
    [tempImage setImage:[UIImage imageNamed:@"iconfont-wenjian"]];
    [tempImage setFrame:CGRectMake(kMainScreenWidth/2-98/2, self.view.bounds.size.height/2-111/2, 98, 111)];
    [self.view addSubview:tempImage];
    
    UILabel *tip = [[UILabel alloc]init];
    CGSize ss = [@"没有消息记录" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [tip setFont:[UIFont systemFontOfSize:13]];
    [tip setFrame:CGRectMake(0, kFrame_YHeight(tempImage)+20, ss.width, ss.height)];
    [tip setCenterX:kMainScreenWidth/2];
    [tip setTextColor:LINECOLOR];
    [tip setText:@"没有消息记录"];
    [self.view addSubview:tip];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//返回按钮点击事件
-(void)leftBarButtonItemClick{
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHREDDOT" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}
//侧滑收拾返回
- (void)baseNavigationController:(BaseNavigationController*)controller didReturn:(NSString*)className{
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHREDDOT" object:self];
    
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

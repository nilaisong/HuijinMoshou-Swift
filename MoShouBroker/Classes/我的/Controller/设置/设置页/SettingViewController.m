//
//  SettingViewController.m
//  MoShou2
//
//  Created by Aminly on 15/12/4.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "SettingViewController.h"
#import "UILabel+StringFrame.h"
#import "HMTool.h"
#import "AboutUsViewController.h"
#import "DataFactory+User.h"
#import "ChangePasswordViewController.h"
//#import "LoginViewController.h"
#import "MultipleResourceRequst.h"
#import "DownloaderManager.h"
#import "MineTableViewCell.h"
#import "UserAgreementViewController.h"
#import "Tool.h"
#import "XTLogInController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titleArr;
    UILabel *cacheDetail;

    UILabel *buildingDetail;
    BOOL isClearCache;
    
    
}
@property(nonatomic,strong)NSString *imagePath;
@property(nonatomic,strong)NSString *buildingPath;

@end

#define CURRENTVIEWHEIGHT  self.view.bounds.size.height
@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEWBGCOLOR;
    // Do any additional setup after loading the view.
    [self initUI];
}
-(void)initUI{
    
    self.navigationBar.titleLabel.text = @"设置";
    
//    UIView *gengjinView =[[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth,  90)];
//    [self.view addSubview:gengjinView];
//    [gengjinView setBackgroundColor:[UIColor whiteColor]];
//    UIView *genjinline = [[UIView alloc]initWithFrame:CGRectMake(0, kFrame_Height(gengjinView)-0.5, kMainScreenWidth, 0.5) ];
//    [gengjinView addSubview:genjinline];
//    [genjinline setBackgroundColor:LINECOLOR];
//    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, CURRENTVIEWHEIGHT-32-51, 20)];
//    [gengjinView addSubview:title];
//    [title setFont: [UIFont systemFontOfSize:16]];
//    [title setTextColor:LABELCOLOR];
//    [title setText: @"客户跟进信息同步"];
//    
//    UILabel *genjinTip = [[UILabel alloc]initWithFrame:CGRectMake(kFrame_X(title), kFrame_YHeight(title)+15, kMainScreenWidth, 30)];
//    [gengjinView addSubview:genjinTip];
//    [genjinTip setTextColor:TFPLEASEHOLDERCOLOR];
//    [genjinTip setFont:[UIFont systemFontOfSize:12]];
//    [genjinTip setText:@"开启后，确客将能同步收到客户跟进信息，以便更好服务客户。"];
//    //是否同步跟进信息
//    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth-16-51, kFrame_Y(title), 51, 27)];
//    [switchButton setOnTintColor:BLUEBTBCOLOR];
//    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    if([UserData sharedUserData].confirmShowTrack){
//        [switchButton setOn:YES];
//    }else{
//        [switchButton setOn:NO];
//
//    }
//    [gengjinView addSubview:switchButton];
    titleArr = [[NSArray alloc]initWithObjects:@"修改登录密码",@"清除缓存",@"用户协议",@"当前版本", nil];
    self.tableView=[[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, kFrame_Height(self.navigationBar), kMainScreenWidth, 44*4)];
    [self.tableView setDelegate: self];
    [self.tableView setDataSource:self];
    [self.tableView setScrollEnabled:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIButton *logoutBtn =[[UIButton alloc]initWithFrame:CGRectMake(10, kFrame_YHeight(self.tableView)+25, kMainScreenWidth-20, 44)];
    [logoutBtn setBackgroundColor:BLUEBTBCOLOR];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.layer.cornerRadius = 4.0;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
//    UIView *line =[HMTool getLineWithFrame:CGRectMake(0, kFrame_YHeight(self.tableView)-0.5, kMainScreenWidth, 0.5) andColor:LINECOLOR];
//    [self.view addSubview:line];
//    UIView *line2 =[HMTool getLineWithFrame:CGRectMake(0, kFrame_Y(self.tableView), kMainScreenWidth, 0.5) andColor:LINECOLOR];
//    [self.view addSubview:line2];

//    if (iPhone4) {
//        [logoutBtn setFrame:CGRectMake(16, CURRENTVIEWHEIGHT-50-20, kMainScreenWidth-32, 50)];
//
//    }
}
////同步跟进信息开关
//-(void)switchAction:(id)sender
//{
//    UISwitch *switchButton = (UISwitch*)sender;
//    BOOL isButtonOn = [switchButton isOn];
//        [[DataFactory sharedDataFactory]updateConfirmShowTrackWithYes:[NSString stringWithFormat:@"%d",isButtonOn] andCallback:^(ActionResult *result) {
//            if (result.success) {
//
//            }else{
//                [switchButton setOn:![switchButton isOn]];
//
//                [TipsView showTips:result.message inView:self.view];
//            }
//        }];
//    
// //}
-(void)logoutAction{
    [self showAlertWithText:@"您将退出登录，是否继续？" WithTag:1000];
}
-(void)showAlertWithText:(NSString *)text WithTag:(NSInteger)tag{
    UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"提示" message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    av.tag = tag;
    [av show];
}
//Alert确定按钮的回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            if([NetworkSingleton sharedNetWork].isNetworkConnection){
                UIImageView *loading =[self setRotationAnimationWithView];
                [[AccountServiceProvider sharedInstance] logout:^(ResponseResult* result){
                    
                    [self removeRotationAnimationView:loading];
                    if(result.success){
                        [TipsView showTipsCantClick:result.message inView:self.view];
                        [[UserData sharedUserData] cleareUserData];
                        
                        //登出环信
                        [ChatUIHelper shareHelper].currentChatConversationId = @"";
                        [[EMClient sharedClient] logout:YES];
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TouchExit"];//add by wangzz 2016-01-22
                        
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(popToRoot) userInfo:nil repeats:NO];
                    }
                    else{
                        [TipsView showTipsCantClick:result.message inView:self.view];
                    }
                }];
            }
               }
        
    }else if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            [self clearImageCache];
        }
    }else if (alertView.tag == 1002){
    
        if (buttonIndex == 1) {
            [self clearBuildingCache];
        }
    }


}
-(void)popToRoot{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popToLogin) userInfo:nil repeats:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)popToLogin{
    
    XTLogInController *log = [[XTLogInController alloc]init];
    
//    [self.navigationController presentViewController:log animated:NO completion:nil];
//    UIViewController* testVc = [[UIViewController alloc]init];
//    [self.navigationController pushViewController:testVc animated:YES];
    [self.navigationController pushViewController:log animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell =[[MineTableViewCell alloc]init];
    [cell.titleLabel setFrame:CGRectMake(10,0, 100, 44)];
    [cell.titleLabel setText:[titleArr objectForIndex:indexPath.row]];
    cell.line.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    if (indexPath.row == 1) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectForIndex:0];
        self.imagePath =[cachesDir stringByAppendingString:@"/ImageCache"];
        
        [cell.detailLabel setText:[self getSizeStrWithPath:self.imagePath]];
        [cell.detailLabel setFont:[UIFont systemFontOfSize:12]];
        CGSize detailS =[HMTool getTextSizeWithText:cell.detailLabel.text andFontSize:12];
        [cell.detailLabel setFrame:CGRectMake(kMainScreenWidth-16-detailS.width-8-10, 22-detailS.height/2, detailS.width, detailS.height)];
        [cell.detailLabel setTextColor:TFPLEASEHOLDERCOLOR];
        cacheDetail = cell.detailLabel;
    }else if (indexPath.row == 3){
    
        [cell.detailLabel setText:[NSString stringWithFormat:@"V%@",kAppVersion]];
        [cell.detailLabel setFont: [UIFont systemFontOfSize:12]];
        CGSize detailS =[HMTool getTextSizeWithText:cell.detailLabel.text andFontSize:12];
        [cell.detailLabel setFrame:CGRectMake(kMainScreenWidth-10-detailS.width-8-10, 22-detailS.height/2, detailS.width, detailS.height)];
        [cell.detailLabel setTextColor:TFPLEASEHOLDERCOLOR];
        [cell.line setHidden:YES];
        cell.arrowImage.hidden = YES;
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChangePasswordViewController *chang =[[ChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:chang animated:YES];
    }else if (indexPath.row == 1){
        if ([cacheDetail.text isEqualToString:@"0.00KB"]) {
            UIAlertView *v =[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有需要清理的缓存哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [v show];
        }else{
            [self showAlertWithText:@"确定清除本地缓存？" WithTag:1001];

        }
    }else if (indexPath.row == 2){
//        if ([buildingDetail.text isEqualToString:@"0.00KB"]) {
//            UIAlertView *v =[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有需要清理的下载数据哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [v show];
//        }else{
//            [self showAlertWithText:@"确定清除已下载数据？" WithTag:1002];
//            
//        }
        //跳转用户协议页面
        UserAgreementViewController *u  =[[UserAgreementViewController alloc]init];
        [self.navigationController pushViewController:u animated:YES];
    }
//    else if (indexPath.row == 3){
//        AboutUsViewController *ab =[[AboutUsViewController alloc]init];
//        ab.needUpdate = self.needUpdate;
//        ab.isNew = self.isNew;
//        ab.version = self.version;
//        ab.updateMsg = self.updateMsg;
//        [self.navigationController pushViewController:ab animated:YES];
//    }
}
//单个文件的大小
- (long long)fileSizeAtPath:(NSString*) filePath{//KB
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (CGFloat)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//返回计算好的文件大小字符串
-(NSString *)getSizeStrWithPath:(NSString *)path{
    
    NSString *sizeStr =@"";
    float size =[self folderSizeAtPath:path];
    if (size<1 ) {
        
        sizeStr =[NSString stringWithFormat:@"%.2fKB",size*1024];
    }else{
        
        sizeStr = [NSString stringWithFormat:@"%.2fM",size];
    }
    return sizeStr;
    
}
-(void)clearImageCache{
    isClearCache = YES;
    [self clearCacheDataSourceWith:self.imagePath];
    
}
-(void)clearBuildingCache{
    isClearCache = NO;
[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [[DownloaderManager sharedManager] removeAllDownloadItems];
    [Tool setCache:@"isCleanBuilding" value:@"1"];

} completion:^(BOOL finished) {
[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
    [TipsView showTips:[NSString stringWithFormat:@"已清除缓存%@",buildingDetail.text] inView:self.view];

} completion:^(BOOL finished) {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
}];
}];

}
//删除某一路径下的缓存
-(void)clearCacheDataSourceWith:(NSString *)path{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                       NSString *allPath = path;
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:allPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [allPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
    
}
-(void)clearCacheSuccess{
    if(isClearCache){
        [TipsView showTips:[NSString stringWithFormat:@"已清除缓存%@",cacheDetail.text] inView:self.view];

    }else{
        [TipsView showTips:[NSString stringWithFormat:@"已清除缓存%@",buildingDetail.text] inView:self.view];

    }

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
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

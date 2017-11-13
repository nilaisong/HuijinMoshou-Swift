//
//  BuildingDynamicMsgListViewController.m
//  MoShou2
//
//  Created by Mac on 2016/12/18.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BuildingDynamicMsgListViewController.h"
#import "BuildingDynamicMsgListCell.h"
#import "EstateDynamicMsgModel.h"
#import "Estate.h"
@interface BuildingDynamicMsgListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Estate * _estateBuildingMo;
    
}
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation BuildingDynamicMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSString *key = [NSString stringWithFormat:@"%@-%@",[UserData sharedUserData].userInfo.userId,_building.buildingId];
    
    NSString *value = [NSString stringWithFormat:@"%zd",self.building.estateDynamicMsgList.count];
    [Tool setCache:key value:value];
    
    _estateBuildingMo = self.building.estate;
    
    self.navigationBar.titleLabel.text = @"楼盘动态";

    if (self.building.estateDynamicMsgList.count>0) {
        [self tableView];

    }


}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
        
    }
    
    return _tableView;
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.building.estateDynamicMsgList.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EstateDynamicMsgModel *model =   self.building.estateDynamicMsgList[indexPath.row];

    return [BuildingDynamicMsgListCell buildingCellHeightWithModel:model];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EstateDynamicMsgModel *model =   self.building.estateDynamicMsgList[indexPath.row];

    BuildingDynamicMsgListCell *cell = [[BuildingDynamicMsgListCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.msgModel = model;
    
    return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EstateDynamicMsgModel *model =   self.building.estateDynamicMsgList[indexPath.row];

    if ([model.fromType isEqualToString:@"confirm"]) {
        //缺课
        [self pushToChatVCWithEstateDynamicMsgModel:model];
    }
}

-(void)pushToChatVCWithEstateDynamicMsgModel:(EstateDynamicMsgModel *)msgModel
{
    
    
    
    if (msgModel.chatUserName.length>0) {
        
        [UserCacheManager saveInfo:msgModel.chatUserName imgUrl:msgModel.chatUserPic nickName:msgModel.chatUserNick];
        
        
        //    agency_building_url    楼盘图片url
        //    agency_building_name    楼盘名字
        //    agency_building_id    楼盘id
        //    agency_building_area    楼盘区域商圈
        //    agency_building_detail     是否显示楼盘详情的自定义图片view
        //    agency_mobile            经纪人手机号
        //    agency_employeeNo  经纪人员工编号
        //    agency_department 经纪人机构门店
        NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
        //    [extDic setValue:userInfo.Id forKey:kChatUserId];
        //    [extDic setValue:userInfo.AvatarUrl forKey:kChatUserPic];
        //    [extDic setValue:userInfo.NickName forKey:kChatUserNick];
        
        [extDic setValue:_estateBuildingMo.imgUrl forKey:@"agency_building_url"];
        [extDic setValue:_building.name forKey:@"agency_building_name"];
        
        [extDic setValue:_building.buildingId forKey:@"agency_building_id"];
        [extDic setValue:[NSString stringWithFormat:@"%@-%@",_estateBuildingMo.district,_estateBuildingMo.plate] forKey:@"agency_building_area"];
        [extDic setValue:@"1" forKey:@"agency_building_detail"];
        [extDic setValue:[UserData sharedUserData].userInfo.mobile forKey:@"agency_mobile"];
        [extDic setValue:[UserData sharedUserData].userInfo.employeeNo forKey:@"agency_employeeNo"];
        [extDic setValue:[NSString stringWithFormat:@"%@ %@",[UserData sharedUserData].userInfo.orgnizationName,[UserData sharedUserData].userInfo.storeName] forKey:@"agency_department"];
        //对方环信ID
        //    easemobConfirmMo.username
        //@"test_confirm_15344444444"
        NSString *sendMsg =  [NSString stringWithFormat:@"[%@]",self.building.name];
        //发送文字消息
        EMMessage *message = [EaseSDKHelper sendTextMessage:sendMsg
                                                         to:msgModel.chatUserName//接收方
                                                messageType:EMChatTypeChat//消息类型
                                                 messageExt:extDic]; //扩展信息
        __weak BuildingDynamicMsgListViewController *weakSelf = self;

        //发送构造成功的消息
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        } completion:^(EMMessage *message, EMError *error) {
            
            if (!error) {
                ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:msgModel.chatUserName conversationType:EMConversationTypeChat];
                
                chatVC.buildingID = weakSelf.building.buildingId;
                chatVC.nickName = msgModel.chatUserNick;
                chatVC.title =msgModel.chatUserNick;
                [weakSelf.navigationController pushViewController:chatVC animated:YES];
                

                
            }
            
        }];
        
        
        
        
    }else{
        
        AlertShow(@"确客不正确");
                     
    }
    
    
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

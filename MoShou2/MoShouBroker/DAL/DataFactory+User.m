//
//  DataFactory+User.m
//  Enterprise
//
//  Created by NiLaisong on 15/9/23.
//  Copyright © 2015年 NiLaisong. All rights reserved.
//
#import "NSObject+MJKeyValue.h"
#import "DataFactory+User.h"
#import "NetWork.h"
#import "Tool.h"
#import "UserData.h"
#import "NSObject+MJProperty.h"
//#import "JPUSHService.h"
#import "PointRules.h"
@implementation DataFactory (User)
#pragma mark 登录
-(void)loginWtihMobile:(NSString *)mobile andPassword:(NSString *)password andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
//        [Tool removeCache:@"releaseBaseURL"];//每次登录重新获取数据接口域名
        NSDictionary *dic = @{@"principal":mobile,@"password":password,@"validepassword":@1};
        [[NetWork manager] POST:@"/dologin" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                NSLog(@"*************%@",responseObject);
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {  
                    [Tool setCache:@"user_account" value:mobile];
                    NSDictionary *dic =[responseObject valueForKey:@"data"];
                    NSString* token = [dic valueForKey:@"token"];
                    [Tool setCache:@"user_token" value:token];
                    
                    if ([self verifyPasswdLegal:dic message:result.message]) {
                        [self getUserDataWithCallBack:callback];
                    }else{
                        [Tool setCache:@"user_token" value:nil];
                    }
                }else{
                    callback(result);
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
}

/**
 *  校验密码是否过于简单
 */
- (BOOL)verifyPasswdLegal:(NSDictionary *)dict message:(NSString*)msg{
    BOOL isLegal = YES;
    for (NSString* key in [dict allKeys]) {
        if ([key isEqualToString:@"passwordLegal"]) {
            isLegal = [[dict valueForKey:@"passwordLegal"] boolValue];
        }
    }
    if (!isLegal) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XTPasswordUnLegalNotification" object:msg];
    }
    return isLegal;
}

#pragma mark 注册
-(void)registerWtihMobile:(NSString*)mobile password:(NSString*)password andVcode:(NSString*)code andCallback:(HandleActionResult)callback{

    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"clientType":@"0",@"regitsType":@"1",@"principal":mobile,@"password":password,@"code":code};
        
        [[NetWork manager] POST:@"/regist" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
//                    NSDictionary *dic =[responseObject valueForKey:@"data"];
//                    
//                    [UserData sharedUserData].userId = [dic stringValueForKey:@"userId"];
//                    NSString* token = [dic valueForKey:@"token"];
//                    [Tool setCache:@"user_token" value:token];
//                    [Tool setCache:@"user_account" value:mobile];
//                    [UserData sharedUserData].mobile = mobile;
//                    [UserData sharedUserData].changeShopVerifyStatus = -1;
//                    [self initUserData:dic];
                    [self loginWtihMobile:mobile andPassword:password andCallback:callback];

//                    [[UserData sharedUserData] setJPushAlias];
                }else{
                    callback(result);

                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
    
    
}
#pragma mark 忘记密码
-(void)forgetPasswordWtihMobile:(NSString*)mobile andVcode:(NSString*)code andNewPassword:(NSString*)password andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"mobile":mobile,@"newPassword":password,@"code":code};
        
        [[NetWork manager] POST:@"/updateForgetPassword" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
          
                result =[ActionResult objectWithKeyValues:responseObject];
             
                if (result.success) {
                    
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
}
//#pragma mark 获取注册验证码
//-(void)getRigisterVcodeWithMobile:(NSString*)mobile andCallback:(HandleActionResult)callback{
//    
//    __block ActionResult *result =[ActionResult alloc];
//    result.success = NO;
//    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
//        NSDictionary *dic = @{@"mobile":mobile};
//        
//        [[NetWork manager] POST:@"/sendCode" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            if (responseObject) {
//                result =[ActionResult objectWithKeyValues:responseObject];
//                if (result.success) {
//                    
//                    [Tool setCache:@"user_account" value:mobile];
//                    NSDictionary *data = [responseObject valueForKey:@"data"];
//                    NSString* token = [data valueForKey:@"token"];
//                    [Tool setCache:@"user_token" value:token];
//                    
//                }else{
//                    
//                }
//                callback(result);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            callback(result);
//        }];
//    }
//    
//    
//    
//}

#pragma mark 获取一般验证码
-(void)getVcodeWithMobile:(NSString*)mobile andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"mobile":mobile};
        
        [[NetWork manager] POST:@"/sendCode" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    
                }else{
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
}

-(void)initUserData:(NSDictionary*)data
{
    NSDictionary *userData = [data valueForKey:@"user"];
    [UserData sharedUserData].userId = [userData stringValueForKey:@"id"];
    [UserData sharedUserData].mobile = [userData stringValueForKey:@"mobile"];
    [UserData sharedUserData].avatar = [userData stringValueForKey:@"headPic"];
    [UserData sharedUserData].sex = [userData stringValueForKey:@"gender"];
    [UserData sharedUserData].employeeNo = [userData stringValueForKey:@"employeeNo"];
    [UserData sharedUserData].isExchangeShop = [[userData valueForKey:@"isExchangeShop"] integerValue];
    NSDictionary *shopDic =[userData valueForKey:@"org"];
    if (shopDic) {
            
        if (![[Tool getCache:@"storeNum"] isEqualToString:[shopDic stringValueForKey:@"uniquecode"]] && [shopDic stringValueForKey:@"uniquecode"].length>0) {
             [UserData sharedUserData].chooseCityId = @"";
            [UserData sharedUserData].chooseCityName = @"";
        }
        [UserData sharedUserData].storeNum = [shopDic stringValueForKey:@"uniquecode"];
        [UserData sharedUserData].storeId = [shopDic stringValueForKey:@"id"];
        [UserData sharedUserData].storeName = [shopDic stringValueForKey:@"name"];
        [UserData sharedUserData].mobileVisable = [[shopDic valueForKey:@"mobileVisable"] boolValue];
        
        [UserData sharedUserData].limitEmployeeNo = [[shopDic valueForKey:@"limitEmployeeNo"] boolValue];//YES;//
        
        NSString* cityId = [shopDic stringValueForKey:@"areaId"];
        NSString* areaLongitude = [shopDic stringValueForKey:@"areaLongitude"];
        NSString* areaLatitude = [shopDic stringValueForKey:@"areaLatitude"];
        
        if (cityId.length>0) {
            [UserData sharedUserData].cityId = cityId;
            [UserData sharedUserData].cityName = [shopDic stringValueForKey:@"areaName"];
        }
        if (areaLatitude.length > 0 && areaLongitude.length > 0) {
            [UserData sharedUserData].longitude = areaLongitude;
            [UserData sharedUserData].latitude = areaLatitude;
            [UserData sharedUserData].selectedLongitude = areaLongitude;
            [UserData sharedUserData].selectedLatitude  = areaLatitude;
        }else{
            [UserData sharedUserData].selectedLongitude = @"";
            [UserData sharedUserData].selectedLatitude  = @"";
        }
    }
    
    NSDictionary *orgAdditionalDic = [shopDic valueForKey:@"additional"];
    NSDictionary *orgnizationDic = [orgAdditionalDic valueForKey:@"orgnization"];
    
    [UserData sharedUserData].orgnizationName = [orgnizationDic valueForKey:@"name"];
        
    NSDictionary *additionaDic = [userData valueForKey:@"additional"];

    if (additionaDic) {
        [UserData sharedUserData].points = [additionaDic stringValueForKey:@"points"];
        [UserData sharedUserData].isSignIn = [[[additionaDic valueForKey:@"sign"]valueForKey:@"isSign"] boolValue];
//        [UserData sharedUserData].unreadMsgCount = [[additionaDic valueForKey:@"msgCount"]intValue];
        [UserData sharedUserData].changeShopVerifyStatus = [[additionaDic stringValueForKey:@"isChangeShopApplication"]intValue];
        [UserData sharedUserData].confirmShowTrack = [[additionaDic stringValueForKey:@"confirmShowTrack"]boolValue];
        
        [UserData sharedUserData].customerSource = [additionaDic stringValueForKey:@"customerSource"];
        
        //add by wangzz 160811
        [UserData sharedUserData].trystCarEnable = [[additionaDic stringValueForKey:@"trystCarEnable"]boolValue];
        //end
        
        [UserData sharedUserData].shareRange = [additionaDic stringValueForKey:@"shareRange"];
        NSDictionary *telDic = [[additionaDic valueForKey:@"customerServiceTel"] objectForIndex:0];
        if (telDic) {
            [UserData sharedUserData].customerServiceTel = [telDic stringValueForKey:@"tel"];
        }
        [UserData sharedUserData].addressId = [additionaDic stringValueForKey:@"addressId"];
        
        [UserData sharedUserData].maxRecommendCount = [additionaDic stringValueForKey:@"maxRecommendCount"];
        [UserData sharedUserData].userName = [userData stringValueForKey:@"nickname"];
    }
   
    [UserData sharedUserData].offlineMsgCount = [userData stringValueForKey:@"offlineMsgCount"];
#pragma mark - 后台返回环信信息相关
    NSDictionary *easemobUserDic = [userData valueForKey:@"easemobUsers"];
    if (easemobUserDic) {
        NSString *easemoUserName = [easemobUserDic valueForKey:@"username"];
        NSString *easemoPassWord = [easemobUserDic valueForKey:@"password"];
        NSString *easemoNickName = [easemobUserDic valueForKey:@"nickname"];
        // 开启一个线程防止登录失败时造成主线程卡死
        NSOperationQueue *q = [[NSOperationQueue alloc]init];
        [q addOperationWithBlock:^{
            if (![EMClient sharedClient].isLoggedIn) {
                EMError *loginerror = [[EMClient sharedClient] loginWithUsername:easemoUserName password:easemoPassWord];
                if (!loginerror) {
                    //设置自动登录
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    //保存下用户信息
                    [UserCacheManager saveInfo:easemoUserName imgUrl:[UserData sharedUserData].avatar nickName:easemoNickName];
                    //设置推送详情的字段和昵称 类型
                    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
                    options.displayName = easemoNickName.length <= 0?@"":easemoNickName;
                    options.displayStyle = EMPushDisplayStyleMessageSummary;
                    EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
                }
                //            AlertShow(loginerror.errorDescription);
                DLog(@"loginerror.errorDescription======%@  %u",loginerror.errorDescription,loginerror.code);
            }
            
            
        }];
        
        
        
}
}
#pragma mark 获取用户信息
-(void)getUserDataWithCallBack:(HandleActionResult)callBack{

    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        [[NetWork manager] POST:@"/userinfo" parameters:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {

                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data =[responseObject valueForKey:@"data"];
                    
                    [self initUserData:data];
                    //向激光推送注册用户别名
                    [[UserData sharedUserData] setJPushAlias];
                }else{
                }
                callBack(result);
                
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result);
        }];
    }
 
    
}
#pragma mark 修改用户名
-(void)changeNameWithName:(NSString *)name andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"nickname":name};
        
        [[NetWork manager] POST:@"/api/user/updateNickname" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [UserData sharedUserData].userName = name;
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
    
    
}
#pragma mark 修改性别
-(void)changeSexWithSex:(NSString *)sex andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"gender":sex};
        
        [[NetWork manager] POST:@"/api/user/updateGender" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [UserData sharedUserData].sex = sex;
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
    
    
}
#pragma mark 修改密码 （接口待修改）
-(void)changPasswordWithCurrentPassword:(NSString *)currentPass andNewPassword:(NSString *)newPass andCallback:(HandleActionResult)callback
{
    
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"oldPassword":currentPass,@"newPassword":newPass};
        [[NetWork manager] POST:@"/updatePassword" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {

                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
    
    
}
#pragma mark 修改手机号
-(void)changMobileWithMobile:(NSString *)mobile andVcode:(NSString *)code andCallback:(HandleActionResult)callback{
    
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"mobile":mobile,@"code":code};
        
        [[NetWork manager] POST:@"/api/user/updateMobile" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    
                }else{
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
    
    
}
#pragma mark 修改门店码
-(void)changShopCode:(NSString*)shopCode withEmpoyeeNo:(NSString*)empoyeeNo andShopPic:(UIImage *)shopPic andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        
        NSDictionary *dic = @{@"uniquecode":shopCode,@"employeeNo":empoyeeNo};//empoyeeNo
        [[NetWork manager]POST:@"api/agency/applyChangeShop" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (shopPic) {
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a =[date timeIntervalSince1970]*1000;
                NSString *picname = [NSString stringWithFormat:@"%f.jpg",a];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(shopPic, 0.1) name:@"shoppic" fileName:picname mimeType:@"image/jpeg/png"];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            result =[ActionResult objectWithKeyValues:responseObject];
            if (responseObject) {

            }else{
                
            }
            callback(result);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
        
    }
    
}
//add by wangzz 160803
#pragma mark - 修改员工编号
-(void)changEmpoyeeNo:(NSString*)empoyeeNo andCallback:(HandleActionResult)callback
{
    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        
        NSDictionary *dic = @{@"employeeNo":empoyeeNo};//empoyeeNo
        [[NetWork manager] POST:@"/api/user/updateEmployeeNo" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }
}
//end
#pragma mark 意见反馈
-(void)submitCommentsWithcontent:(NSString *)content andImagesArr:(NSArray *)imagesArr andCallback:(HandleActionResult)callback{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert)
    {
        __block ActionResult* result = [ActionResult alloc];
        result.success = NO;
        NSDictionary *dic = @{@"msg":[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};

        [[NetWork manager] POST:@"api/opinion/saveOpinion" parameters:dic constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
            if (imagesArr.count>0)
            {
                for (int i=0; i<imagesArr.count; i++) {
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
                    NSString *picString = [NSString stringWithFormat:@"%f%d.jpg", a,i];
                    UIImage *image = [imagesArr objectForIndex:i];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.1) name:@"imgs" fileName:picString mimeType:@"image/jpeg/png"];
                }
            }
            
        } success:^(NSURLSessionDataTask *task, id responseObject){

            if (responseObject)
            {
                result = [ActionResult objectWithKeyValues:responseObject];
            }
            else
            {
                
            }
            callback(result);
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            callback(result);
        }];
    }
}
#pragma mark 修改头像
-(void)uploadAvatarWith:(UIImage *)avatar userId:(NSString *)userid andCallback:(HandleActionResult)callback{
    
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        
        [[NetWork manager] POST:@"/api/user/updateHeadpic" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a =[date timeIntervalSince1970]*1000;
            NSString *picname = [NSString stringWithFormat:@"%f.jpg",a];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(avatar, 0.1) name:@"img" fileName:picname mimeType:@"image/jpeg/png"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result = [ActionResult objectWithKeyValues:responseObject];
                NSDictionary* data = [responseObject valueForKey:@"data"];
                [UserData sharedUserData].avatar = [data valueForKey:@"headpicUrl"];
                NSLog(@"avatar:%@", [UserData sharedUserData].avatar);

                
            }else{
            }
            callback(result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
            
        }];
    }
    
}
#pragma mark 签到
-(void)signWithCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        
        [[NetWork manager] POST:@"/api/agency/agencySign" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data = [responseObject valueForKey:@"data"];
                    NSString *point =[data stringValueForKey:@"after"];

                    [UserData sharedUserData].points = point;
                    [UserData sharedUserData].isSignIn = YES;
                    
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            result.message = @"签到失败";
            callback(result);
        }];
    }


}

#pragma mark 获取未读消息数量
//delete by wangzz 161114
/*-(void)getUnreadMessageCountWithCallback:(HandleNumberResult)callBack{

    __block ActionResult *result =[ActionResult alloc];
    __block NSNumber* unreadCount = nil;
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        //api/sysmsg/unreadcnt
        [[NetWork manager] POST:@"/api/sys_msg/unreadcnt" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data = [responseObject valueForKey:@"data"];
                    unreadCount = [data valueForKey:@"unreadCnt"];
                                        
                    
                }else{
                    
                }
                callBack(unreadCount);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(unreadCount);
        }];
    }

}*/
#pragma mark 获取消息列表
-(void)getMessagesByPage:(NSString*)page WithCallBack:(HandleDataListResult)callBack
{

     __block DataListResult* messagesList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"pageNo":page,@"pageSize":PAGESIZE};
        [[NetWork manager] POST:@"/api/sysmsg/list" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {

               __block ActionResult * result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [MessageData setupReplacedKeyFromPropertyName:^NSDictionary*{
                                                return @{
                                                         @"msgId":@"id",
                                                         @"datetime":@"createTime"
                                                         };
                                            }];
                    NSDictionary* data = [responseObject valueForKey:@"data"];
//                    NSArray* listData = [data valueForKey:@"listdata"];
                    messagesList = [[DataListResult alloc] init];
                    messagesList.dataArray = [MessageData  objectArrayWithKeyValuesArray:data];

                    NSDictionary *pageData = [responseObject valueForKey:@"page"];
                    int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                    int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                    if (pageCount>pageNo) {
                        messagesList.morePage = YES;
                    }else{
                        messagesList.morePage = NO;
                    }

//                    NSArray* listData = [data valueForKey:@"listdata"];
//                    messagesList = [[DataListResult alloc] init];
//                    messagesList.dataArray = [MessageData  objectArrayWithKeyValuesArray:listData];
//                    messagesList.morePage = [[data valueForKey:@"morePage"] boolValue];

                }else{
                    
                }
                callBack(messagesList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(messagesList);
        }];
    }

}
#pragma mark 读消息
-(void)readMessage:(MessageData*)message withCallback:(HandleActionResult)callBack
{

    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        NSDictionary *dic = [[NSDictionary alloc]init];
        if (message.pushCode) {
            dic = @{@"msgId":message.msgId,@"pushCode":message.pushCode};
        }else{
            dic = @{@"msgId":message.msgId};

        }
        [[NetWork manager] POST:@"/api/sysmsg/read" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
              
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                   NSDictionary* data = [responseObject valueForKey:@"data"];
                    message.readed = YES;
                    NSString* msgTitle = [data stringValueForKey:@"title"];
                    message.title = msgTitle;
                    message.content = [data stringValueForKey:@"content"];
//                    message.imgUrl = [data stringValueForKey:@"imgUrl"];
                    message.source = [data stringValueForKey:@"sourceType"];
                    message.datetime = [data stringValueForKey:@"createTime"];
                }else{
                    
                }
                callBack(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(result);
        }];
        
    }
  
}
#pragma mark 一键已读
-(void)onKeyReadAllMessageWithCallback:(HandleActionResult )callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        [[NetWork manager] POST:@"/api/sysmsg/readall" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    
                }else{
                    //                    result.message = @"登录失败";
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            result.message = @"登录失败";
            callback(result);
        }];
    }

}
#pragma mark 删除消息

-(void)deleteMessageWithMessageData:(MessageData *)massageData andCallBack:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        NSDictionary *dic = @{@"msgId":massageData.msgId};
        [[NetWork manager] POST:@"/api/sysmsg/delete" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {

                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
        
    }


}
#pragma mark 下载按钮点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1 || alertView.tag ==2)
    {
        if (alertView.tag ==1 || (alertView.tag ==2 && buttonIndex==1)) {
            if (self.appStoreDownloadUrl)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appStoreDownloadUrl]];
                
//                [self performSelector:@selector(forceExit) withObject:nil afterDelay:0.5];
            }
        }
        self.appStoreDownloadUrl = nil;
    }
}

//-(void)forceExit
//{
//    NSArray* array = [NSArray array];
//    id object = [array objectForIndex:1];
//}

#pragma mark 版本更新接口alert
-(void)updateVersionWithMessage:(NSString*)message mustUpdate:(BOOL)ismust newVersion:(NSString*)newVersion
{
    NSString* msg = message.length>0?message:@"有新版本发布，是否升级？";
    if(ismust)//要求必须升级
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"新版本提示" message:msg delegate:self cancelButtonTitle:@"升级" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"新版本提示" message:msg delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"升级", nil];
        alert.tag = 2;
        [alert show];
    }
//    [Tool setCache:@"checkVersionUpdate" value:[NSNumber numberWithBool:YES]];
}
#pragma mark 退出登录
-(void)logoutWithCallback:(HandleActionResult)callback{

    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        [[NetWork manager] POST:@"/logout" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    [[UserData sharedUserData] cleareUserData];
                   
                    [ChatUIHelper shareHelper].currentChatConversationId = @"";

                   //登出环信
                    [[EMClient sharedClient] logout:YES];
                }else{
                    
                }
                
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            result.message = @"登录失败";
            callback(result);
        }];
    }
}

-(void)getAllScheduledRemindList:(HandleArrayResult)callback
{
    if ([NetworkSingleton sharedNetWork].isNetworkConnection) {
        [[NetWork manager] POST:@"api/agency/remind/allMyScheduleList" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSArray* remindList = nil;
            if (responseObject)
            {
                ActionResult * result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                   NSDictionary *data =[responseObject valueForKey:@"data"];
                   remindList = [data valueForKey:@"remindList"];
                }
                callback(remindList);
            }
            if (!remindList) {
                [Tool setCache:@"getAllScheduledRemindList" value:[NSNumber numberWithBool:FALSE]];
            }
            else
            {
                [Tool setCache:@"getAllScheduledRemindList" value:[NSNumber numberWithBool:YES]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
        {
            [Tool setCache:@"getAllScheduledRemindList" value:[NSNumber numberWithBool:FALSE]];
            callback(nil);
        }];
    }
}
#pragma mark 分享
-(void)getShareAppModelWithCallback:(HandleModelResult)callback{
    ShareModel *model = [[ShareModel alloc]init];
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"vcode":[NSString stringWithFormat:@"%d",kVersionCode],@"source":@"1"};
        [[NetWork manager] POST:@"/api/msversion/ios" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                NSDictionary* data = [responseObject valueForKey:@"data"];
                if ( data) {
                    NSDictionary *iosData = [data valueForKey:@"ios"];
                    if (iosData) {
                        model.title = @"一款能让经纪人提高效率的工具";
                        model.content = [iosData valueForKey:@"shareText"];
                        model.linkUrl = [iosData valueForKey:@"shareUrl"];
                        NSLog(@"nnnnnnn%@",model.content);

                    }
                    
                }

            }
            callback(model);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(model);
        }];
    }
    
}
#pragma mark 商品列表
-(void)getPointMallByPage:(NSString*)page andSequenceType:(NSInteger)sequenceType andWithCallBack:(HandleGoodsResult)callBack{
    __block GoodsResult* goodList = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = [[NSDictionary alloc]init];

        if(sequenceType == 0){//默认排序
        
            dic = @{@"pageNo":page,@"pageSize":PAGESIZE,@"cityId":[UserData sharedUserData].cityId};

        }else if (sequenceType == 1){//由高到低
            dic = @{@"pageNo":page,@"pageSize":PAGESIZE,@"cityId":[UserData sharedUserData].cityId,@"ascFlag":@"1"};
            
        }else if (sequenceType == 2){//由低到高
            
            dic = @{@"pageNo":page,@"pageSize":PAGESIZE,@"cityId":[UserData sharedUserData].cityId,@"ascFlag":@"0"};
            
        }else if (sequenceType == 3){//我可以兑换的
            dic = @{@"pageNo":page,@"pageSize":PAGESIZE,@"cityId":[UserData sharedUserData].cityId,@"myPoint":[UserData sharedUserData].points};
            
        }
        [[NetWork manager] POST:@"/api/agency/goods/getGoodsList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                __block ActionResult * result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    NSArray* listData = [data valueForKey:@"listdata"];
                    goodList = [[GoodsResult alloc] init];
                    goodList.dataArray = [ExchangeGoods  objectArrayWithKeyValuesArray:data];
                    
                    NSDictionary *pageData = [responseObject valueForKey:@"page"];
                    int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                    int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                    if (pageCount>pageNo) {
                        goodList.morePage = YES;

                    }else{
                        goodList.morePage = NO;

                    }
                    
                }else{
                    
                }
                callBack(goodList);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(goodList);
        }];
    }

}
#pragma mark 兑换商品
-(void)exchangeGoodsWith:(ExchangeGoods *)goods withAddress:(NSString*)addressId andCallback:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success = NO;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (goods.goodsId.length > 0 && goods.goodsId != NULL) {
            [dic setValue:goods.goodsId forKey:@"goodsId"];
        }
        if (addressId.length > 0 && addressId != NULL) {
            [dic setValue:addressId forKey:@"userAddressId"];
        }
        [[NetWork manager] POST:@"/api/agency/goods/convert" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary *data =[responseObject valueForKey:@"data"];
                    goods.availableNum = [data stringValueForKey:@"availableNum"];
                    [UserData sharedUserData].points =[data stringValueForKey:@"point"];
                    
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
    }


}
#pragma mark 积分详情列表
-(void)getPointDataWithPage:(NSString *)page andCallBack:(HandleDataListResult)callback{
    __block DataListResult* pointResult = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"pageNo":page,@"pageSize":PAGESIZE};
        [[NetWork manager] POST:@"/api/agency/goods/getDetailList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                __block ActionResult * result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    pointResult = [[DataListResult alloc] init];
                    pointResult.dataArray = [PointData  objectArrayWithKeyValuesArray:data];
                    NSDictionary *pageData = [responseObject valueForKey:@"page"];
                    int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                    int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                    if (pageCount>pageNo) {
                        pointResult.morePage = YES;
                    }else{
                        pointResult.morePage = NO;
                        
                    }

                }else{
                    
                }
                callback(pointResult);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            result.message = @"签到失败";
            callback(pointResult);
        }];
    }
    
}
#pragma mark兑换详情列表
-(void)getExchangeDataWithPage:(NSString *)page andCallBack:(HandleDataListResult)callback{
    __block DataListResult* exchangeRecord = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"pageNo":page,@"pageSize":PAGESIZE};
        [[NetWork manager] POST:@"/api/agency/goods/findPointDetailList" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                __block ActionResult * result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    exchangeRecord = [[DataListResult alloc] init];
                    exchangeRecord.dataArray = [ExchangeRecord  objectArrayWithKeyValuesArray:data];
                    NSDictionary *pageData = [responseObject valueForKey:@"page"];
                    int pageNo = [[pageData valueForKey:@"pageNo"]intValue];
                    int pageCount = [[pageData valueForKey:@"pageCount"]intValue];
                    if (pageCount>pageNo) {
                        exchangeRecord.morePage = YES;
                    }else{
                        exchangeRecord.morePage = NO;
                    }

                    
                }else{
                    
                }
                callback(exchangeRecord);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(exchangeRecord);
        }];
    }


}
#pragma mark 删除兑换记录
-(void)deleteExchangeWithExchangeRecord:(ExchangeRecord *)record andCallBack:(HandleActionResult)callback{
    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        NSDictionary *dic = @{@"orderId":record.exchangeId};
        [[NetWork manager] POST:@"/api/agency/goods/delRecord" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
        
    }


}
#pragma mark 积分规则
-(void)getPintsRulesDataWithCallBack:(HandleDataListResult)callback{
    __block DataListResult* exchangeRecord = nil;
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        [[NetWork manager] POST:@"/api/agency/goods/getRuleList" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                __block ActionResult * result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    NSDictionary* data = [responseObject valueForKey:@"data"];
                    exchangeRecord = [[DataListResult alloc] init];
                    exchangeRecord.dataArray = [PointRules  objectArrayWithKeyValuesArray:data];
                    
                }else{
                    
                }
                callback(exchangeRecord);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(exchangeRecord);
        }];
    }
}

#pragma mark 版本更新
-(void)checkVersionUpdateWithCallback:(HandleVersionUpdate)callback
{
    if ([NetworkSingleton sharedNetWork].isNetworkConnectionAndShowAlert) {
        NSDictionary *dic = @{@"vcode":[NSString stringWithFormat:@"%d",kVersionCode],@"source":@"1"};
        [[NetWork manager] POST:@"/api/msversion/ios" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            if (responseObject) {
                NSDictionary* data = [responseObject valueForKey:@"data"];
                if (data) {
                    NSDictionary* iosData = [data valueForKey:@"ios"];
                    BOOL isSuccess = [[responseObject valueForKey:@"success"] boolValue];
                    if (isSuccess) {
                        int vcode = [[iosData   valueForKey:@"vcode"] intValue];
                        NSString* newVersion = [iosData   valueForKey:@"version"];
                        BOOL mustUpdate =  [[iosData valueForKey:@"force"] boolValue];
                        NSString* message = [iosData valueForKey:@"upgradeText"];
                        self.appStoreDownloadUrl = [iosData valueForKey:@"url"];
//                        NSString* bundleId = kAppBundleId;
//                        if (([bundleId isEqualToString:@"com.huijinmoshou.broker"] && [self.appStoreDownloadUrl rangeOfString:@"itunes.apple.com"].length>0)
//                            || [bundleId isEqualToString:@"com.5i5j.moshou.broker"])
                        {
                            if (kVersionCode<vcode)
                            {
                                callback(YES,message,mustUpdate,newVersion);
                            }
                        }
                    }else{
                        
                    }

                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)updateConfirmShowTrackWithYes:(NSString*)yes andCallback:(HandleActionResult)callback{

    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        NSDictionary *dic = @{@"confirmShowTrack":[NSString stringWithFormat:@"%@",yes]};
        [[NetWork manager] POST:@"/api/estateCustomer/customer/updateConfirmShowTrack" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
                    BOOL confirmShowTrack =  [[[responseObject valueForKey:@"data"] valueForKey:@"confirmShowTrack"] boolValue];
                    [UserData sharedUserData].confirmShowTrack = confirmShowTrack;
                }else{
                    
                }
                callback(result);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callback(result);
        }];
        
    }
}

-(void)addLogWithEventId:(NSString*)eventId andPageId:(NSString*)pageId
{
    __block ActionResult *result =[ActionResult alloc];
    result.success =NO;
    if([NetworkSingleton sharedNetWork].isNetworkConnection){
        NSDictionary *dic = @{@"eventId":eventId,@"pageId":pageId};
        [[NetWork manager] POST:@"/api/appevent/add" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (responseObject) {
                result =[ActionResult objectWithKeyValues:responseObject];
                if (result.success) {
  
                }else{
                    
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}

@end

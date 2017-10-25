//
//  UserData.m
//  Bookstore
//
//  Created by Laisong on 12-11-2.
//  Copyright (c) 2012年 Laisong. All rights reserved.
//

#import "UserData.h"
#import "DataFactory+User.h"
#import "DataFactory+Main.h"
#import "Tool.h"
#import "JPUSHService.h"
#import "DownloaderManager.h"

static UserData* sharedUserData;

@interface UserData()
{
    int setAliasTimes;
    int clearAliasTimes;
}
@property(nonatomic,strong) NSString* userAlias;
@property(nonatomic,strong) NSTimer* timer;

@end

@implementation UserData

@synthesize cityId=_cityId;
@synthesize cityName=_cityName;
@synthesize chooseCityId=_chooseCityId;
@synthesize chooseCityName=_chooseCityName;

@synthesize userId=_userId;
@synthesize userName=_userName;
@synthesize  avatar=_avatar;
@synthesize storeId=_storeId;
@synthesize storeNum=_storeNum;
@synthesize deviceToken=_deviceToken;
@synthesize offlineMsgCount=_offlineMsgCount;
@synthesize newUnreadMsgCount=_newUnreadMsgCount;
@synthesize trystCarEnable=_trystCarEnable;
@synthesize overseasEstateEnable=_overseasEstateEnable;

+(UserData*)sharedUserData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedUserData==nil) {
            sharedUserData = [[UserData alloc] init];
        }
    });

    return sharedUserData;
}

-(id)init
{
    if (self=[super init])
    {
        setAliasTimes = 0;
        clearAliasTimes = 0;
    }
    return self;
}


-(BOOL)isUserLogined
{
    if (self.userId.length>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)cleareUserData
{
    self.userId=nil;
    self.userName = nil;
    self.cityId = nil;
    self.cityName = nil;
    self.chooseCityName = nil;
    self.chooseCityId = nil;
    self.storeNum = nil;
    self.storeId = nil;
    self.storeName = nil;
    self.sex = nil;
    self.avatar = nil;
    self.mobile = nil;
    self.points = nil;
    self.selectedLongitude = @"";
    self.selectedLatitude = @"";
    
    _chooseCityId = nil;
    _chooseCityName = nil;
    _cityId = nil;
    _cityName = nil;
    //add by wangzz 161009
    self.employeeNo = nil;
    self.limitEmployeeNo = NO;
    self.trystCarEnable = NO;
    self.mobileVisable = NO;
    self.confirmShowTrack = NO;
    self.customerSource = nil;
    //end
    
//    [JPUSHService setTags:[NSSet setWithObject:@"app_moshou"] alias:@"" callbackSelector:@selector(clearAliasCallback:tags:
//                                                           alias:) object:self];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSString *callbackString = [NSString stringWithFormat:@"%li, \nalias: %@\n", (long)iResCode,iAlias];
        NSLog(@"----------------deleteAlias回调:%@", callbackString);
        if (iResCode==0){//如果成功的话
            [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                
            } seq:1];
        }
    } seq:1];
    
    self.userAlias =@"";

    [Tool removeCache:@"user_token"];
    [Tool removeCache:@"mobileVisable"];
    [Tool removeCache:@"confirmShowTrack"];
    
    
    [DownloaderManager sharedManager].recordArray = nil;
    [DownloaderManager sharedManager].requestArray = nil;

}
//为用户注册消息推送
-(void)setJPushAlias
{
//    NSLog(@"%@,%@",self.deviceToken,self.userId);
    if(self.deviceToken && self.userId)
    {
        NSString* alias =nil;
        #ifdef DEBUG
            #ifdef INHOUSE//测试
                alias = [NSString stringWithFormat:@"test%@",self.userId];
            #elif ALIYUN//阿里云
                alias = [NSString stringWithFormat:@"test%@",self.userId];
            #elif FANGZHEN//仿真
                alias = [NSString stringWithFormat:@"fz%@",self.userId];
            #elif TIYAN//体验
                alias = [NSString stringWithFormat:@"tiyan%@",self.userId];
            #else//调试
                alias = [NSString stringWithFormat:@"debug%@",self.userId];
            #endif
        #else//正式
            alias = [NSString stringWithFormat:@"new_prefix_%@",self.userId];
//            alias = self.userId;
        #endif
        //如果已经注册过就不再注册
        if (![self.userAlias isEqualToString:alias])
        {
//            [JPUSHService setTags:[NSSet setWithObject:@"app_moshou"]
//                            alias:alias callbackSelector:@selector(tagsAliasCallback:tags:                                                               alias:)  object:self];
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq){
                NSString *callbackString = [NSString stringWithFormat:@"%li, \n alias: %@\n", (long)iResCode,iAlias];
                NSLog(@"----------------setAlias回调:%@", callbackString);
                if (iResCode==0){//如果成功的话
                    self.userAlias = alias;
                    [JPUSHService addTags:[NSSet setWithObject:@"app_moshou"] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                        NSString *callbackString = [NSString stringWithFormat:@"%li, \n tags: %@\n", (long)iResCode,iTags.allObjects];
                        NSLog(@"----------------addTags回调:%@", callbackString);
                         if (iResCode==0){
                             
                         }
                    } seq:1];
                }
            } seq:1];
        }
    }
}

/*
 别名alias和regID(和devicetoken对应，卸载重装会产生新的)是一对多的关系，
 一个别名对应多个regID，而一个regID只能对应一个别名，每次卸载重新安装app都会产生新的
 regID，再登录时新的regID就和用户账号的别名绑定到了一起，这样一个账号在同一台设备就会对应
 多个regID，当更换新的账号登录时或把别名置为""时，只是为当前的regID更换了别名或解除了别名绑定，
 之前regID还残留在原来的别名里（随着旧的devicetoken一段时间后会自动过期，之前的regID才会失效，但在失效之前向原来的别名发送消息还能收到）
 */
/*
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \nalias: %@\n", iResCode,alias];
    NSLog(@"tagsAlias回调1:%@", callbackString);
    setAliasTimes++;
    //iResCode==0表示成功，如果失败了则最多递归调用5次
    if(iResCode!=0 && setAliasTimes<5)
    {
        [JPUSHService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:                                                               alias:) object:self];
    }
    else
    {
        setAliasTimes = 0;
    }
}

- (void)clearAliasCallback:(int)iResCode
                      tags:(NSSet *)tags
                     alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \nalias: %@\n", iResCode,alias];
    NSLog(@"celearAlias回调2:%@", callbackString);
    clearAliasTimes++;
    //如果失败了，则最多递归调用5次
    if(iResCode!=0 && clearAliasTimes<5)
    {
        [JPUSHService setTags:tags alias:@"" callbackSelector:@selector(clearAliasCallback:tags:                                                               alias:) object:self];
    }
    else
    {
        clearAliasTimes = 0;
    }
}
*/

-(NSString*)userId
{
    if(!_userId)
        _userId = [Tool getCache:@"newUserId"];
    return _userId;
}

-(void)setUserId:(NSString *)newUserId
{
    if (![newUserId isEqualToString:self.userId]) {
        _userId =newUserId;
        [Tool setCache:@"newUserId" value:newUserId];
    }
}

-(NSString*)userName
{
    if(!_userName)
        _userName = [Tool getCache:@"userName"];
    return _userName;
}

-(void)setUserName:(NSString *)newUserName
{
    if (![newUserName isEqualToString:self.userName]) {
        _userName = newUserName;
        [Tool setCache:@"userName" value:newUserName];
    }
}

-(NSString *)avatar
{
    if (!_avatar) {
        _avatar = [Tool getCache:@"userAvatar"];
    }
    return _avatar;
}

-(void)setAvatar:(NSString *)newAvatar
{
    if (![newAvatar isEqualToString:self.avatar])
    {
        _avatar = newAvatar;
        [Tool setCache:@"userAvatar" value:newAvatar];
        
        if ([UserData sharedUserData].mobile.length > 0 && newAvatar.length > 0) {
            [Tool setCache:[UserData sharedUserData].mobile value:newAvatar];
        }
    }

}

-(void)setStoreNum:(NSString *)newStoreNum
{
    if (![newStoreNum isEqualToString:self.storeNum]) {
        _storeNum = newStoreNum;
         [Tool setCache:@"storeNum" value:newStoreNum];
    }
}


-(NSString *)storeNum
{
    if (!_storeNum) {
        _storeNum = [Tool getCache:@"storeNum"];
    }
    return _storeNum;
}

-(void)setStoreId:(NSString *)newStoreId
{
    if (![newStoreId isEqualToString:self.storeId]) {
        _storeId = newStoreId;
        [Tool setCache:@"storeId" value:newStoreId];
    }
}

-(NSString *)storeId
{
    if (!_storeId) {
        _storeId = [Tool getCache:@"storeId"];
    }
    return _storeId;
}

-(NSString*)deviceToken
{
    if (!_deviceToken) {
        _deviceToken = [Tool getCache:@"deviceToken"];
    }
    return _deviceToken;
}

-(void)setDeviceToken:(NSString *)newDeviceToken
{
    if (![newDeviceToken isEqualToString:self.deviceToken]) {
        _deviceToken = newDeviceToken;
        [Tool setCache:@"deviceToken" value:newDeviceToken];
    }
}

-(NSString*)offlineMsgCount
{
    if (!_offlineMsgCount) {
        _offlineMsgCount = [Tool getCache:@"offlineMsgCount"];
    }
    return _offlineMsgCount;
}

-(void)setOfflineMsgCount:(NSString *)offlineMsgCount
{
    if (![offlineMsgCount isEqualToString:self.offlineMsgCount]) {
        _offlineMsgCount = offlineMsgCount;
         [Tool setCache:@"offlineMsgCount" value:offlineMsgCount];
    }
}

-(NSInteger)newUnreadMsgCount
{
    if (_newUnreadMsgCount==0) {
        _newUnreadMsgCount = [[Tool getCache:@"newUnreadMsgCount"] integerValue];
    }
    return _newUnreadMsgCount;
}

-(void)setNewUnreadMsgCount:(NSInteger)newUnreadMsgCount
{
    if (newUnreadMsgCount!=self.newUnreadMsgCount) {
        _newUnreadMsgCount = newUnreadMsgCount;
        [Tool setCache:@"newUnreadMsgCount" value:[NSNumber numberWithInteger:newUnreadMsgCount]];
    }
}

-(BOOL)trystCarEnable
{
    if (!_trystCarEnable) {
        _trystCarEnable = [[Tool getCache:@"trystCarEnable"] boolValue];
    }
    return _trystCarEnable;
}


-(void)setTrystCarEnable:(BOOL)trystCarEnable
{
    if(trystCarEnable!=self.trystCarEnable)
    {
        _trystCarEnable = trystCarEnable;
        NSNumber *visable = [NSNumber numberWithBool:trystCarEnable];
        [Tool setCache:@"trystCarEnable" value:visable];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFunctionView" object:nil];
    }
}

-(BOOL)overseasEstateEnable
{
    if (!_overseasEstateEnable) {
        _overseasEstateEnable = [[Tool getCache:@"overseasEstateEnable"] boolValue];
    }
    return _overseasEstateEnable;
}


-(void)setOverseasEstateEnable:(BOOL)overseasEstateEnable
{
    if (overseasEstateEnable!=self.overseasEstateEnable) {
        _overseasEstateEnable = overseasEstateEnable;
        NSNumber *visable = [NSNumber numberWithBool:overseasEstateEnable];
        [Tool setCache:@"overseasEstateEnable" value:visable];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFunctionView" object:nil];
    }
}
//cityId，经纪人门店所在城市
//绑定门店的经纪人,cityID和chooseCityId分开用
//自由经纪人，cityID和chooseCityId一致，实际上没有cityID
-(NSString *)cityId
{
    if (_cityId.length>0) {
        return _cityId;
    }
    else
    {
        if (self.userId.length>0)
        {
            NSString* cityIdKey = [NSString stringWithFormat:@"userCityId%@",self.userId];
            _cityId = [Tool getCache:cityIdKey];
            if (_cityId.length==0) {
                NSString* chooseCityIdKey = [NSString stringWithFormat:@"chooseCityId%@",self.userId];
                _cityId = [Tool getCache:chooseCityIdKey];
                return _cityId;
            }
            else
                return _cityId;
        }
        else
        {
            return nil;
        }
    }
}

-(void)setCityId:(NSString *)newCityId
{
    if (self.userId.length>0)
    {
        //用户重新登录后，对数据刷新
        if(![self.cityId isEqualToString:newCityId])
        {
            _cityId = newCityId;
            NSString* cityIdKey = [NSString stringWithFormat:@"userCityId%@",self.userId];
            [Tool setCache:cityIdKey value:newCityId];
            if (newCityId.length>0) {
                //刷新首页
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHomePage" object:nil];
                //刷新楼盘列表页数据
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyBuildingList" object:nil];
                //刷新闪屏数据
                [[DataFactory sharedDataFactory] performSelectorInBackground:@selector(downloadSplashsData) withObject:nil];
            }
        }
    }
}

-(void)setCityName:(NSString *)newCityName
{
    if (self.userId.length>0)
    {
        if (![newCityName isEqualToString:self.cityName]) {
            _cityName = newCityName;
            NSString* cityNameKey = [NSString stringWithFormat:@"userCityName%@",self.userId];
            [Tool setCache:cityNameKey value:newCityName];
        }
    }
}

-(NSString *)cityName
{
    if (_cityName.length>0) {
        return _cityName;
    }
    else
    {
        if (self.userId.length>0)
        {
            NSString* cityNameKey = [NSString stringWithFormat:@"userCityName%@",self.userId];
            _cityName = [Tool getCache:cityNameKey];
            if (_cityName.length==0) {
                NSString* newChooseCityNameKay = [NSString stringWithFormat:@"chooseCityName%@",self.userId];
                _cityName = [Tool getCache:newChooseCityNameKay];
                if (_cityName.length==0) {
                    return self.locationCityName;
                }
                else
                    return _cityName;
            }
            else
                return _cityName;
        }
        else
        {
            return nil;
        }
    }
}

//重写get方法
-(NSString *)chooseCityId
{
    if (_chooseCityId.length>0) {
        return _chooseCityId;
    }
    else
    {
        if (self.userId.length>0) {
            NSString* chooseCityIdKey = [NSString stringWithFormat:@"chooseCityId%@",self.userId];
            _chooseCityId = [Tool getCache:chooseCityIdKey];
            
            if (_chooseCityId.length==0) {
                NSString* cityIdKey = [NSString stringWithFormat:@"userCityId%@",self.userId];
                _chooseCityId = [Tool getCache:cityIdKey];
                return _chooseCityId;
            }else{
                return _chooseCityId;
            }
        }
        else
        {
            return nil;
        }
    }
}

-(NSString *)chooseCityName
{
    if (_chooseCityName.length>0) {
        return _chooseCityName;
    }
    else
    {
        if (self.userId.length>0) {
            NSString* newChooseCityNameKay = [NSString stringWithFormat:@"chooseCityName%@",self.userId];
            _chooseCityName = [Tool getCache:newChooseCityNameKay];
            if (_chooseCityName.length==0) {
                NSString* cityNameKey = [NSString stringWithFormat:@"userCityName%@",self.userId];
                _chooseCityName = [Tool getCache:cityNameKey];
                if (_chooseCityName.length==0) {
                    return self.locationCityName;
                }
                else
                    return _chooseCityName;
            }else{
                return _chooseCityName;
            }
        }
        else
        {
            return nil;
        }
    }
}

//重写set方法
-(void)setChooseCityId:(NSString *)newchooseCityId
{
    if (![newchooseCityId isEqualToString:self.chooseCityId])
    {
        _chooseCityId = newchooseCityId;
        if (self.userId.length>0) {
            NSString* chooseCityIdKey = [NSString stringWithFormat:@"chooseCityId%@",self.userId];
            [Tool setCache:chooseCityIdKey value:newchooseCityId];
        }
    }
}

-(void)setChooseCityName:(NSString *)newChooseCityName
{
    if (![newChooseCityName isEqualToString:self.chooseCityName]) {
        _chooseCityName = newChooseCityName;
        if (self.userId.length>0)
        {
            NSString* newChooseCityNamekey = [NSString stringWithFormat:@"chooseCityName%@",self.userId];
            [Tool setCache:newChooseCityNamekey value:newChooseCityName];
        }
    }
}

-(NSMutableArray *)shareRangeArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.shareRange.length>0) {
        
        NSArray *shareContentArr = [self.shareRange componentsSeparatedByString:@","];
        NSArray *titleArray =@[@{@"wxfriend":@"微信"},@{@"wxfriendc":@"朋友圈"},@{@"qqfriend":@"QQ"},@{@"sinablog":@"微博"},@{@"sms":@"信息"}];
        
        for (NSString *codeString in shareContentArr) {
            
            for (NSDictionary *dic in titleArray) {
                
                if ([codeString isEqualToString:dic.allKeys[0]]) {
                    
                    [array appendObject:dic.allValues[0]];
                }
            }
        }
    }else{
        
        if (array.count>0) {
            [array removeAllObjects];
        }
    }
    return array;
}

@end

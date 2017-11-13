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
@synthesize userInfo=_userInfo;

@synthesize chooseCityId=_chooseCityId;
@synthesize chooseCityName=_chooseCityName;

@synthesize deviceToken=_deviceToken;

@synthesize newUnreadMsgCount=_newUnreadMsgCount;

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
    if (self.userInfo.userId.length>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//用户重新登录后，从数据接口获取的用户信息会重新赋值
//需要清理的是重新登陆后还继续存储上一个账户信息的字段，而与账户无关的共用信息则不能清除
-(void)cleareUserData
{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSString *callbackString = [NSString stringWithFormat:@"%li, \nalias: %@\n", (long)iResCode,iAlias];
        NSLog(@"----------------deleteAlias回调:%@", callbackString);
        if (iResCode==0){//如果成功的话
            [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                
            } seq:1];
        }
    } seq:1];
    
    self.userInfo = nil;
    self.userAlias =@"";

}
//为用户注册消息推送
-(void)setJPushAlias
{
//    NSLog(@"%@,%@",self.deviceToken,self.userId);
    if(self.deviceToken && self.userInfo.userId)
    {
        NSString* alias =nil;
        #ifdef DEBUG
            #ifdef INHOUSE//测试
                alias = [NSString stringWithFormat:@"test%@",self.userInfo.userId];
            #elif ALIYUN//阿里云
                alias = [NSString stringWithFormat:@"test%@",self.userInfo.userId];
            #elif FANGZHEN//仿真
                alias = [NSString stringWithFormat:@"fz%@",self.userInfo.userId];
            #elif TIYAN//体验
                alias = [NSString stringWithFormat:@"tiyan%@",self.userInfo.userId];
            #else//调试
                alias = [NSString stringWithFormat:@"debug%@",self.userInfo.userId];
            #endif
        #else//正式
            alias = [NSString stringWithFormat:@"new_prefix_%@",self.userInfo.userId];
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

-(void)setUserInfo:(UserInfo *)userInfo
{
    if (_userInfo!=userInfo)
    {
        _userInfo = userInfo;
        if (_userInfo!=nil & userInfo!=nil) {
            if(_userInfo.trystCarEnable!= userInfo.trystCarEnable)
            { //刷新首页顶部功能入口
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFunctionView" object:nil];
            }
        }
    }
}

-(UserInfo*)userInfo
{
    if(!_userInfo)
    {
        _userInfo = [[UserInfo alloc] init];
    }
    return _userInfo;
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
//用的时候会重新获取
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
//用的时候会重新获取
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
        //刷新首页顶部功能入口
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFunctionView" object:nil];
    }
}
//cityId，经纪人门店所在城市
//绑定门店的经纪人,cityID和chooseCityId分开用
//自由经纪人，cityID和chooseCityId一致，实际上没有cityID
-(NSString *)cityId
{
    if (self.userInfo.cityId.length>0) {
        return self.userInfo.cityId;
    }
    else
    {
        if (self.userInfo.userId.length>0)
        {
            NSString* chooseCityIdKey = [NSString stringWithFormat:@"chooseCityId%@",self.userInfo.userId];
            NSString* _cityId = [Tool getCache:chooseCityIdKey];
            return _cityId;
        }
        else
        {
            return nil;
        }
    }
}


-(NSString *)cityName
{
    if (self.userInfo.cityName.length>0) {
        return self.userInfo.cityName;
    }
    else
    {
        if (self.userInfo.userId.length>0)
        {
            NSString* newChooseCityNameKay = [NSString stringWithFormat:@"chooseCityName%@",self.userInfo.userId];
             NSString* _cityName = [Tool getCache:newChooseCityNameKay];
            if (_cityName.length==0) {
                return self.locationCityName;
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
        if (self.userInfo.userId.length>0)
        {
            NSString* chooseCityIdKey = [NSString stringWithFormat:@"chooseCityId%@",self.userInfo.userId];
            _chooseCityId = [Tool getCache:chooseCityIdKey];
            if (_chooseCityId.length==0) {
                return self.userInfo.cityId;
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
        if (self.userInfo.userId.length>0)
        {
            NSString* newChooseCityNameKay = [NSString stringWithFormat:@"chooseCityName%@",self.userInfo.userId];
            _chooseCityName = [Tool getCache:newChooseCityNameKay];
            if (_chooseCityName.length==0)
            {
                _chooseCityName = self.userInfo.cityName;
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
        if (self.userInfo.userId.length>0) {
            NSString* chooseCityIdKey = [NSString stringWithFormat:@"chooseCityId%@",self.userInfo.userId];
            [Tool setCache:chooseCityIdKey value:newchooseCityId];
        }
    }
}

-(void)setChooseCityName:(NSString *)newChooseCityName
{
    if (![newChooseCityName isEqualToString:self.chooseCityName]) {
        _chooseCityName = newChooseCityName;
        if (self.userInfo.userId.length>0)
        {
            NSString* newChooseCityNamekey = [NSString stringWithFormat:@"chooseCityName%@",self.userInfo.userId];
            [Tool setCache:newChooseCityNamekey value:newChooseCityName];
        }
    }
}

-(NSMutableArray *)shareRangeArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.userInfo.shareRange.length>0) {
        
        NSArray *shareContentArr = [self.userInfo.shareRange componentsSeparatedByString:@","];
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

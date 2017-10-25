//
//  LocalFileSystem.m
//  AuctionCatalog
//
//  Created by Laison on 12-2-22.
//  Copyright 2012 . All rights reserved.
//
#import "LocalFileSystem.h"
#import "NetworkSingleton.h"
#import "Functions.h"
#import "Tool.h"
#define kSettingsFile @"settings.plist"


static LocalFileSystem *instance = nil;


@implementation LocalFileSystem

@synthesize document;

@synthesize baseURL;

@synthesize keyValueDic;

@synthesize suffixUrlDic;

//- (void)dealloc
//{
//	[baseURL release];
//    [keyValueDic release];
//
//    [suffixUrlDic release];
//    
//	[super dealloc];
//}

- (id)init
{
	self = [super init];
	if(self)
	{
        [self initnailRootDocument];

	}
	return self;
}

+ (LocalFileSystem *)sharedManager{
	if (!instance)
	{
		instance = [[LocalFileSystem alloc] init];
	}
	return instance;
}

- (NSString *)getStringWithString:(NSString *)str andCount:(NSInteger)num{
    NSMutableString *strr = [NSMutableString string];
    int numm = 0;
    if ([str lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > ( num * 2)) {
        
        for (int i = 0; i < [str length]; i ++) {
            unichar c = [str characterAtIndex:i];
            if ( c > 256) {
                numm+=2;
            }else {
                numm+=1;
            }
            [strr appendString:[NSString stringWithCharacters:&c  length:1]];
            if (numm >= (num *2)) {
                return strr;
            }
        }
    }else {
        strr = (NSMutableString *)str;
    }
    return strr;
}

//判断文件是否存在
+ (BOOL)isFileExsit:(NSString *)path{
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	return fileExists;
}


//删除Document下的所有缓存
- (void)removeALLCachesFiles{
    
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString* cachespath = [array objectForIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachespath] objectEnumerator];
    NSString* fileName;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [cachespath stringByAppendingPathComponent:fileName];
        [manager removeItemAtPath:fileAbsolutePath error:nil];
    }
}

+ (NSString *)getDocumentPath
{

    NSString* docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];

	return docPath;
}

+ (NSString *)getCachesPath
{
    NSString* cachesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];

	return cachesPath;
}

+ (NSString *)getMainBundlePath
{
	NSString *path = [[NSBundle mainBundle] resourcePath];
	
	return path;
}


#pragma mark -
#pragma mark 解析XML

//- (void)setBackupAttribute:(BOOL)value
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString* path = kPathOfDocument(kSettingsFile);
//    if([fileManager fileExistsAtPath:path])
//	{
//        if (value)
//        {
//            addBackupAttributeToItemAtURL([[[NSURL alloc] initFileURLWithPath:path] autorelease]);
//        }
//        else
//        {
//            cancelBackupAttributeToItemAtURL([[[NSURL alloc] initFileURLWithPath:path] autorelease]);
//        }
//	}
//}


- (void)initnailRootDocument
{
//    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"menu.plist" ofType:@""]);
	NSString* srcPath =kPathOfMainBundle(kSettingsFile);

	self.document = [NSDictionary dictionaryWithContentsOfFile:srcPath];
    
    self.productName = [self.document objectForKey:@"productName"];
    self.storeAppID = [self.document objectForKey:@"storeAppID"];
    self.isAppTest = [[self.document objectForKey:@"isAppTest"] boolValue];
    self.versionCode = [self getVersionCode];
    self.versionName = [self getVersionName];

    self.keyValueDic = [self getKeyValueDic];
    
    self.suffixUrlDic = [self getSuffixUrlDic];
}

-(NSString*)getVersionCode
{
    NSString* versionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    return versionCode;
}

- (NSString*)getVersionName
{
    NSString* appVersionName =  appVersionName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    #ifdef DEBUG
//        #ifdef INHOUSE
//            appVersionName = [NSString stringWithFormat:@"%@测试",appVersionName];
//        #elif FANGZHEN
//           appVersionName = [NSString stringWithFormat:@"%@仿真",appVersionName];
//        #elif TIYAN
//            appVersionName = [NSString stringWithFormat:@"%@体验",appVersionName];
//        #else
//           appVersionName = [NSString stringWithFormat:@"%@调试",appVersionName];
//        #endif
//    #else
//
//    #endif
    return appVersionName;
}

-(NSString*)baseURL
{
//    if (baseURL) {
//        return baseURL;
//    }
//    else
    {
        baseURL = [self getBaseUrlWithKey:@"urlInformation"];
    }
    return baseURL;
}

- (NSString *)getBaseUrlWithKey:(NSString*)key
{
    NSString* baseUrl=@"";
    NSDictionary *urlDic = [self.document objectForKey:key];
    #ifdef DEBUG
        if (self.isAppTest)
        {
            #ifdef INHOUSE
                baseUrl = [urlDic objectForKey:@"baseURL-test"];
            #elif ALIYUN
                baseUrl = [urlDic objectForKey:@"baseURL-aliyun"];
            #elif FANGZHEN
                baseUrl = [urlDic objectForKey:@"baseURL-fz"];
            #elif TIYAN
                baseUrl = [urlDic objectForKey:@"baseURL-ty"];
            #else
                baseUrl = [urlDic objectForKey:@"baseURL-debug"];
            #endif
        }
        else
        {
            baseUrl = [urlDic objectForKey:@"baseURL"];
        }
    #else
         baseUrl = [urlDic objectForKey:@"baseURL"];
    #endif
	return baseUrl;
}
/*
//获取发布版用的数据接口域名
-(NSString*)getReleaseBaseURL:(BOOL)release
{
    NSString* baseUrl= [Tool getCache:@"releaseBaseURL"];
    if (!baseUrl)
    {
        NSString* url = release?@"http://bj.newhouse.5i5j.com/api/":@"http://gw.huijinmoshou.com/api/";
        NSURLResponse* response;
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (responseData)
        {
            NSDictionary * retDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            baseUrl = [retDic objectForKey:@"data"];
        }
        if (baseUrl) {
            [Tool setCache:@"releaseBaseURL" value:baseUrl];
            [Tool setCache:@"tempBaseURL" value:baseUrl];
        }
        else
        {
            baseUrl = [Tool getCache:@"tempBaseURL"];
        }
    }
    if (!baseUrl) {
        NSDictionary *urlDic = [self.document objectForKey:@"urlInformation"];
        baseUrl = [urlDic objectForKey:release?@"baseURL":@"baseURL-test"];
    }
    return baseUrl;
}
*/
- (NSDictionary *)getKeyValueDic{
	NSDictionary *dic = [self.document objectForKey:@"keyValueDic"];
	return dic;
}

- (NSDictionary *)getSuffixUrlDic
{
    NSDictionary *suffixURLs = [[self.document objectForKey:@"urlInformation"] objectForKey:@"suffixURLs"];
    
    return suffixURLs;
}

- (id)valueWithKey:(NSString*)key
{
    return [keyValueDic objectForKey:key];
}

+ (void)saveImageData:(NSData *)data withPath:(NSString *)path
{
    if (data)
    {
        [data writeToFile:path atomically:YES];
    }
}

@end

//
//  LocalFileSystem.h
//  AuctionCatalog
//
//  Created by Laison on 12-2-22.
//  Copyright 2012 Laison. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kAppVersion     [LocalFileSystem sharedManager].versionName

#define kVersionCode    [LocalFileSystem sharedManager].versionCode

#define kStoreAppID     [LocalFileSystem sharedManager].storeAppID

@interface LocalFileSystem : NSObject {

	NSDictionary* document;
	

	NSString *baseURL;
    
    NSDictionary *keyValueDic;
    
//    NSString *dataBase;
}

@property (nonatomic,retain) NSDictionary* document;
@property (nonatomic,assign) BOOL isAppTest;
@property (nonatomic,assign) NSString * versionCode;
@property (nonatomic,retain) NSString *versionName;
@property (nonatomic,retain) NSString* productName;//APP 标示
@property (nonatomic,retain) NSString* storeAppID;
@property (nonatomic,retain) NSString *baseURL;
@property (nonatomic,retain) NSDictionary *suffixUrlDic;
@property (nonatomic,retain) NSDictionary *keyValueDic;

+ (LocalFileSystem *)sharedManager;   
//取Docment路径
+ (NSString *)getDocumentPath;
//取Caches路径
+ (NSString *)getCachesPath;
//取主程序路径
+ (NSString *)getMainBundlePath;


+ (void)saveImageData:(NSData *)data withPath:(NSString *)path;

+ (BOOL)isFileExsit:(NSString *)path;

- (void)initnailRootDocument;
//- (void)setBackupAttribute:(BOOL)value;
- (void)removeALLCachesFiles;

- (NSString *)getBaseUrlWithKey:(NSString*)key;


- (id)valueWithKey:(NSString*)key;


@end

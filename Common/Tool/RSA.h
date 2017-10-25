//
//  RAS.h
//  MoShouBroker
//
//  Created by  NiLaisong on 15/6/4.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GenerateSuccessBlock)(void);

@interface RSA : NSObject{
@private
    NSData * publicTag;
    NSData * privateTag;
    NSOperationQueue * cryptoQueue;
    GenerateSuccessBlock success;
}

@property (nonatomic,readonly) SecKeyRef publicKeyRef;
@property (nonatomic,readonly) SecKeyRef privateKeyRef;
@property (nonatomic,readonly) NSData   *publicKeyBits;
@property (nonatomic,readonly) NSData   *privateKeyBits;
@property (nonatomic,readonly) NSString *publicKeyString;


+ (id)shareInstance;
- (void)generateKeyPairRSACompleteBlock:(GenerateSuccessBlock)_success;

- (NSData *)RSA_EncryptUsingPublicKeyWithData:(NSData *)data;
- (NSData *)RSA_EncryptUsingPrivateKeyWithData:(NSData*)data;
- (NSData *)RSA_DecryptUsingPublicKeyWithData:(NSData *)data;
- (NSData *)RSA_DecryptUsingPrivateKeyWithData:(NSData*)data;

@end
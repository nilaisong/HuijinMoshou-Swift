//
//  MoshouAddressBook.h
//  MoShouBroker
//  通讯录联系人数据模型
//  Created by wangzz on 15/6/25.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoshouAddressBook : NSObject{
    NSInteger sectionNumber;
    NSInteger recordID;
    BOOL rowSelected;
    NSString *name;
    NSString *email;
    NSString *tel;
    UIImage *thumbnail;
}

@property NSInteger sectionNumber;
@property NSInteger recordID;
@property BOOL rowSelected;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) UIImage *thumbnail;

@end

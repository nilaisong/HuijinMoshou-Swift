//
//  LocalContactsViewController.h
//  MoShouBroker
//
//  Created by wangzz on 15/6/25.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import "BaseViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <malloc/malloc.h>
#import "MoshouAddressBook.h"

typedef void (^ContactSelect) (NSInteger,NSString *,NSString *);

@interface LocalContactsViewController :BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger _index;
}

@property(copy,nonatomic)ContactSelect BsSelectBlock;//传参block块
//@property (nonatomic, assign) BOOL bIsCustomerList;

-(void)returnResultBlock:(ContactSelect)ablock;

@end

//
//  MessageNoticeDetailViewController.h
//  MoShou2
//
//  Created by wangzz on 2016/10/21.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    shopNotice,  //门店公告
    hugainNotice,//汇金行公告
    hugainRemind,  //汇金行提醒
    carNotice,//约车信息
    reportNotice//报备流程
}messageNoticeType;


@interface MessageNoticeDetailViewController : BaseViewController

@property (nonatomic, assign) messageNoticeType  noticeType;
@property (nonatomic, copy)   NSString           *navTitle;
@property (nonatomic, copy)   NSString           *msgType;
@property (nonatomic, copy)   NSString           *eatateId;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)BOOL morePage;

@end

//
//  CustomerSourceData.h
//  MoShou2
//
//  Created by manager on 2017/4/26.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerSourceData : NSObject

@property (nonatomic, copy) NSString     *code;//客户来源code，添加客户信息传递此参数
@property (nonatomic, copy) NSString     *label;//显示标签

//报备成功后周边楼盘数据
@property (nonatomic, copy) NSString     *customerEffective;//客户保护
@property (nonatomic, copy) NSString     *recomMess;//报备时效
@property (nonatomic, copy) NSString     *customerVisteRule;//带看规则
@property (nonatomic, strong) NSArray    *result;//周边楼盘列表 需映射buildingDataList

@end

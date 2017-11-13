//
//  BuildingListData.h
//  MoShouQueke
//
//  Created by strongcoder on 15/10/29.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloaderManager.h"

@interface BuildingListData : NSObject

@property(nonatomic,readonly) DownloadStateType downloadState;


@property(nonatomic,copy) NSString* buildingId;//楼盘编号
@property(nonatomic,copy) NSString* name;//楼盘名称
@property(nonatomic,copy) NSString* fullName;//楼盘全称
@property(nonatomic,copy) NSString* price;//均价

@property(nonatomic,readonly) NSString * showPriceString;  //拼接的价格字符串
@property(nonatomic,copy) NSString* priceLabel;//价格显示标签
@property(nonatomic,copy) NSString* priceValue;//价格显示值
//"priceLabel": "均价",						--价格显示标签
//"priceValue": "10000元/平"					--价格显示值
@property(nonatomic,copy) NSString* url;//后台返回原图
@property(nonatomic,copy) NSString* thmUrl;//缩略图
@property(nonatomic,copy) NSString* imgUrl;//大图



@property(nonatomic,copy) NSString* districtName;//楼盘所在区域
@property(nonatomic,copy) NSString* featureTag;//特设标签
@property(nonatomic,copy) NSString* saleLongitude;//坐标经度
@property(nonatomic,copy) NSString* saleLatitude;//坐标纬度
//@property(nonatomic,copy) NSString* housePrice; //房子均价
@property(nonatomic,copy) NSString* buildDistance;//距离
@property(nonatomic,copy) NSString* commissionStandard;//佣金字段
@property(nonatomic,assign) BOOL isTop;  //是否置顶
@property(nonatomic,copy) NSString* shipAgencyNum ;//合作经纪人数量
@property(nonatomic,assign) BOOL favorite; //是否收藏
@property(nonatomic,copy) NSString* recommendationNum;     //--已报备
@property(nonatomic,assign) BOOL isDownLoad; //是否下载

@property(nonatomic,assign) BOOL isNew; //是否是新楼盘


@property(nonatomic,assign) BOOL customerVisitEnable; //是否使用客户到访信息(1:使用 0:不使用)


@property(nonatomic,assign) BOOL mechanismType; //报备机制      0默认报备      1为选择确客报备

@property(nonatomic,copy) NSString* mechanismText;



/**
 *  看房约车     NO 0不可预约   YES 1可预约
 */
@property(nonatomic,assign) BOOL trystCar; //看房约车      0不可预约    1可预约



@property(nonatomic,copy) NSString* visitNum;     //----已带看
@property(nonatomic,copy) NSString* signNum;     //----已成交

@property(nonatomic,copy) NSString* formatCommissionStandard; //自己手动拼接的佣金字段

@property(nonatomic,copy) NSString* commissionType;    //佣金类型
@property(nonatomic,copy) NSString* commissionBegin;    // 佣金开始字段
@property(nonatomic,copy) NSString* commissionEnd;    //佣金结束字段

@property(nonatomic,copy) NSString* commissionDisplay;    //--楼盘列表不显示   0 显示    1不显示
@property(nonatomic,copy) NSString* customerTelType;    // 全号  隐号报备 (0 :全号隐号均可     1:仅全号)


//"status"："process"	  --（process上架）   finished（下架）  （toBePublished 待发布）      已失效  expired

@property(nonatomic,copy) NSString* status;
@property(nonatomic,copy) NSString* address;//楼盘地址

/**
 *  add 2016-06-06 15:18:54
 */
@property(nonatomic,copy) NSString* processTime;     //    "processTime" : "2016-06-06 14:05:47",      --第一次上架时间
/**
 居室区间
 */
@property(nonatomic,copy) NSString *bedroomSegment;  // 居室区间


/**
 面积区间
 */
@property(nonatomic,copy) NSString *saleAreaSegment;  // 面积区间

/**
 热销 0否  1是
 */
@property(nonatomic,assign) BOOL isHot; //-热销 0否  1是


/**
 特价  0否  1 是
 */
@property(nonatomic,assign) BOOL isSpecialPrice; //特价  0否  1 是


//@property(nonatomic,copy) NSString *districtName;  // 区县

@property(nonatomic,copy) NSString *plateName;  // 商圈
@property(nonatomic,copy) NSString *dynamicMsg;  // 最新动态

@property(nonatomic,readonly) NSString *districtplateName;  //拼接的区县商圈

//"districtName": "栖霞区",						--区县
//"plateName": "金鹰奥莱城",					--商圈
//"dynamicMsg": "测试懂不！22222"			--最新动态

@property(nonatomic,assign) BOOL agencyReportType; //是否允许报备 '0' 允许 '1' 不允     YES就是不允许


// agencyReportType": "1" //是否允许报备 '0' 允许 '1' 不允

//
//@property(nonatomic,copy) NSString* reportedCount;     //已报备数
//@property(nonatomic,copy) NSString* lookedCount;       //已带看数
//@property(nonatomic,copy) NSString* recognizedCount;   //已认筹数(暂时没数)
//@property(nonatomic,copy) NSString* subscribedCount;   //已认购数(暂时没数)
//@property(nonatomic,copy) NSString* completedCount;    //已成交数

////status "status": "process",//状态,process 是进行中,finished是已结束



@end






//
//"id" : 20,					--楼盘Id
//"name" : "联调楼盘测试",		--楼盘名称
//"price" : "111111",			--楼盘价格
//"url" : "",				--楼盘图片
//"distance" : null,			--当前的距离
//"featureTag" : "学区房,风景区,双高速,不限购"				--特色标签
//"longitude" : 116.217175,
//"latitude" : 40.216766
//"commissionStandard" : null,	--佣金规则
//"isTop" : "0",				--是否置顶   0未   1 是
//"shipAgencyNum" : 1,			--经纪人合作 数量
//"favorite" : "0",			--是否收藏
//"recommendationNum" : "1",	--已报备
//"visitNum" : "0",			--已带看
//"signNum" : "0",			--已成交
//"commissionType" : 0,		--佣金百分比数值
//"commissionBegin" : "",		--佣金开始
//"commissionEnd" : "",		--佣金结束
//"commissionDisplay" : null	--楼盘列表不显示
//

//----------------下面的是废弃的字段--------------------


// "id":267,						-- //楼盘id
//"name":"凯德国贸",					--//楼盘名称
//"housePrice":"10000",				--//新加的楼盘均价
//"price":"公寓：23000元/平米",			--//均价(废弃)
//"imageUrl":"http://apitest.huijinmoshou.com/images/estate/2015/09/11/mobile/69aa80eb-377f-4df5-8295-795d959afad6.jpg",						-- //缩略图地址
//"districtName":"河西区",				--//区县名称
//"distance":null,					--/距离
//"featureTag":"地铁房",				--//特色标签
//"commissionStandard":"3%",			--//佣金
//"isTop":"1",						--/是否置顶：1置顶，0 不置顶
//"shipAgencyNum":4,				--//合伙经纪人
//"favorite":"0",						--//是否收藏：1已收藏，0 未收藏
//"reportedCount":1,					--//已报备数
//"lookedCount":1,					--//已带看数
//"recognizedCount":0,				--//已认筹数(暂时没数)
//"subscribedCount":0,				--//已认购数(暂时没数)
//"completedCount":null,				--//已成交数
//"saleLocation":"南京路39号（南京路与马场道交口）",
//"saleLatitude":39.119671841039,		--//经度
//"saleLongitude":117.22357906423		--//纬度
//
//"commissionType": "1",
//"commissionBegin": "1234.11",
//"commissionEnd": "2345.22",

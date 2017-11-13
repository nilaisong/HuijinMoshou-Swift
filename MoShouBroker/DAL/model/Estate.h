//
//  Estate.h
//  MoShou2
//
//  Created by copycoder on 16/4/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Estate : NSObject


@property (nonatomic, copy) NSString *estateId; //需要映射
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, copy) NSString *nameSpell;
@property (nonatomic, copy) NSString *nameHeadSpell;
@property (nonatomic, copy) NSString *featureTag;
@property (nonatomic, copy) NSString *price;   //单价
@property (nonatomic, copy) NSString *priceTotal; //总价
@property (nonatomic, copy) NSString *priceFirst; //首付款

//"priceTotal": "",											-- 总价
//"priceFirst": "",											--首付款

@property (nonatomic, copy) NSString * commissionType;
@property (nonatomic, copy) NSString *commissionBegin;
@property (nonatomic, copy) NSString *commissionEnd;
@property (nonatomic, copy) NSString *commissionDisplay;
@property (nonatomic, copy) NSString *acreageType;
@property (nonatomic, copy) NSString * longitude;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString *city;   //城市
@property (nonatomic, copy) NSString *district;  //区县
@property (nonatomic, copy) NSString *plate;   //商圈
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *estateSell;
@property (nonatomic, copy) NSString * telType;
@property (nonatomic, copy) NSString *estateCaseTel;
@property (nonatomic, copy) NSString *estateDescription;   //需要映射 原字段description
@property (nonatomic, copy) NSString * openDiscTime;
@property (nonatomic, copy) NSString * soughtTime;
@property (nonatomic, copy) NSString * stayTime;
@property (nonatomic, copy) NSString *developerName;
@property (nonatomic, copy) NSString *propertyCompanyName;
@property (nonatomic, copy) NSString *propertyRightDeadline;
@property (nonatomic, copy) NSString *license;
@property (nonatomic, copy) NSString *decorationType;
@property (nonatomic, copy) NSString *propertyType;  //物业类型
@property (nonatomic, copy) NSString *propertyFee;
@property (nonatomic, copy) NSString *roomNumber;
@property (nonatomic, copy) NSString *builtUpArea;
@property (nonatomic, copy) NSString *landArea;
@property (nonatomic, copy) NSString *volumeRatio;
@property (nonatomic, copy) NSString *greeningRatio;
@property (nonatomic, copy) NSString *parkingProportion;
@property (nonatomic, copy) NSString *parkingSeat;
@property (nonatomic, copy) NSString * proxyStartTime;
@property (nonatomic, copy) NSString * proxyEndTime;
@property (nonatomic, copy) NSString *customerVisteRule;
@property (nonatomic, copy) NSString *commissionStandard;
@property (nonatomic, copy) NSString *dealStandar;
@property (nonatomic, copy) NSString * effectiveType;
@property (nonatomic, copy) NSString * lookoverRule;
@property (nonatomic, copy) NSString * customerProtectTerm;   //customerProtectTerm  客户有效期(0.报备1.带看)
@property (nonatomic, copy) NSString *mainCustomer;
@property (nonatomic, copy) NSString *buyHouseDemand;
@property (nonatomic, copy) NSString *buyHouseBudget;
@property (nonatomic, copy) NSString *customerGenera; //客户职业
@property (nonatomic, copy) NSString *customerWorkArea;
@property (nonatomic, copy) NSString *customerLiveArea;
@property (nonatomic, copy) NSString *expandSkills;

//"status"："process"	  --（process上架）   finished（下架）  （toBePublished 待发布）      已失效  expired

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, copy) NSString * recommendationNum;
@property (nonatomic, copy) NSString * visitNum;
@property (nonatomic, copy) NSString * signNum;
@property (nonatomic, copy) NSString * customerTelType;
@property (nonatomic, copy) NSString * creator;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * districtName;
@property (nonatomic, copy) NSString * plateName;
@property (nonatomic, copy) NSString * tagRel;
@property (nonatomic, copy) NSString * commissionRel;
@property (nonatomic, copy) NSString * commissionRel2;
@property (nonatomic, copy) NSString * estatePos;
@property (nonatomic, copy) NSString * estateOrg;
@property (nonatomic, copy) NSString * posAssemble;
@property (nonatomic, copy) NSString * orderPrice;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * projectRoleType;
@property (nonatomic, copy) NSString * displayStatus;
@property (nonatomic, copy) NSString * estateConfirm;

@property(nonatomic,copy) NSString* formatCommissionStandard; //自己手动拼接的佣金字段

@property (nonatomic, copy) NSString * saleHouse;   //在售房源



@property(nonatomic,copy) NSString* thmUrl;//缩略图
@property(nonatomic,copy) NSString* imgUrl;//大图
@property(nonatomic,copy) NSString* url;//后台返回原图

@property(nonatomic,copy) NSString* pathUrl;//缩略图


/**
 *  新增楼盘字段
 */

#warning 新增字段  注意映射后台字段关系

@property (nonatomic, copy) NSString * priceDetail;   //价格详情
@property (nonatomic, copy) NSString * buildingSellPoint;   //楼盘卖点

@property (nonatomic, assign) CGFloat  recordEffectiveTime;   //报备有效时间
@property (nonatomic, copy) NSString * recordEffectiveType;  // 报备有效类型

@property(nonatomic,assign) BOOL customerVisitEnable; //是否使用客户到访信息(1:使用 0:不使用)
@property(nonatomic,assign) BOOL mechanismType; //报备机制      0默认报备      1为选择确客报备

/**
 *  看房约车     NO 0不可预约   YES 1可预约
 */
@property(nonatomic,assign) BOOL trystCar; //看房约车      0不可预约    1可预约


@property (nonatomic, copy) NSString * mechanismText;


@property (nonatomic, copy) NSString * saleRoomNumber;  //可售房源

@property(nonatomic,assign) BOOL agencyReportType; //是否允许报备 '0' 允许 '1' 不允     YES就是不允许



//报备有效时间
//record_effective_type  报备有效类型(0:无限。1:当天有效截止24小时。2具体小时)
//record_effective_time   报备有效时间（type 为2的时候这个才有值）

@end





//
//"id": 25,
//"name": "爱晚•大爱城25",
//"alias": "aiwan,daaicheng",
//"nameSpell": "AiWanDaAiCheng25",
//"nameHeadSpell": "AWDAC",
//"featureTag": "学区房,风景区,双高速,不限购",
//"price": "6500",
//"commissionType": 0,
//"commissionBegin": "1",
//"commissionEnd": "3",
//"commissionDisplay": null,
//"acreageType": "90平以下,90-150,150-300,300平米以上",
//"longitude": 116.217175,
//"latitude": 40.216766,
//"city": "北京",
//"district": "丰台区",
//"plate": "科技园",
//"address": "京哈高速香河东出口右转即达",
//"estateSell": "国际化社区,小户型,宜居生态地产",
//"telType": "0",
//"estateCaseTel": "13581234444",
//"description": "首开万科台湖新城是由首开、万科两大房地产企业巨头首次联袂，在东五环旁打造的一个约60万平米体量的大型综合体项目。",
//"openDiscTime": "2015-04-27 00:00:00",
//"soughtTime": "2015-12-12 00:00:00",
//"stayTime": "2016-01-01 00:00:00",
//"developerName": "香河恒康房地产开发有限公司",
//"propertyCompanyName": "11",
//"propertyRightDeadline": "111",
//"license": "（香）房预售证第1436号",
//"decorationType": "豪华装修,精装修,中装修,简装修",
//"propertyType": "别墅,住宅,商住楼,写字楼",
//"propertyFee": "高层1.7元/平/月；别墅2.8元/平/月。",
//"roomNumber": "566",
//"builtUpArea": "26000",
//"landArea": "10000",
//"volumeRatio": "3.44",
//"greeningRatio": "0.35",
//"parkingProportion": "",
//"parkingSeat": "3500",
//"proxyStartTime": "2014-04-27 00:00:00",
//"proxyEndTime": "2014-12-31 00:00:00",
//"customerVisteRule": "客户信息推荐到案场，需与开发商系统核对有无撞单情况；若带客到现场且无撞单情况，需及时签字确认。",
//"commissionStandard": "签约及30%房款到账",
//"dealStandar": "111",
//"effectiveType": 1,
//"lookoverRule": 1,
//"customerProtectTerm": 0,
//"mainCustomer": "30岁-40岁",
//"buyHouseDemand": "自用、投资",
//"buyHouseBudget": "400.0",
//"customerGenera": "企业高管，高技术型人员等高收入人群",
//"customerWorkArea": "滨江，乌镇",
//"customerLiveArea": "滨江，市区",
//"expandSkills": "竞品拦截",
//"status": "toBePublished",
//"delFlag": "0",
//"recommendationNum": 0,
//"visitNum": 0,
//"signNum": 0,
//"url": "",
//"customerTelType": "0",
//"creator": null,
//"createTime": null,
//"updater": "1",
//"updateTime": "2016-04-27 17:28:27",
//"cityName": null,
//"districtName": null,
//"plateName": null,
//"tagRel": null,
//"commissionRel": null,
//"commissionRel2": null,
//"estatePos": null,
//"estateOrg": null,
//"posAssemble": null,
//"orderPrice": null,
//"username": null,
//"mobile": null,
//"projectRoleType": null,
//"displayStatus": 0,
//"estateConfirm": null

//
//"estate" : {							--楼盘实体
//    "id" : 21,							--楼盘实体
//    "name" : "汇欣大厦",					--楼盘名称
//    "alias" : "汇欣大厦",					--别名
//    "nameSpell" : "HuiXinDaXia",				--全拼
//    "nameHeadSpell" : "HXDX",				--简拼
//    "price" : "50000",						--楼盘均价
//    "commissionType" : 0,					--佣金类型
//    "commissionBegin" : "11",				--佣金开始
//    "commissionEnd" : "12",					--佣金结束
//    "commissionDisplay" : null,				--楼盘列表是否显示
//    "longitude" : 116.411301,				--经度
//    "latitude" : 40.000731,					--纬度
//    "city" : "北京",						--城市（中文）
//    "district" : "海淀",					--区域（中文）
//    "plate" : null,						--商圈（中文）
//    "address" : "汇欣大厦A",				--地址
//    "estateSell" : "NB位置,鸟巢边上",			--楼盘卖点
//    "telType" : "0",						--电话类型 0 手机号 1座机
//    "estateCaseTel" : "13810001000",			--楼盘案场电话
//    "description" : "楼盘简介楼盘简介楼盘简介",	--楼盘简介
//    "openDiscTime" : "2016-03-02 00:00:00",	--开盘时间
//    "soughtTime" : "2016-03-31 00:00:00",		--交房时间
//    "stayTime" : "2017-03-16 00:00:00",		--入住时间
//    "developerName" : "北京开发商",			--开发商
//    "propertyCompanyName" : "万科",			--物业公司
//    “”：‘dfergdfg,werewrweer,werwewerew’
//    "propertyRightDeadline" : "70",			--产权年限
//    "license" : "许可证是啥",				--预售许可证
//    "propertyFee" : "2.5",					--物业费
//    "roomNumber" : "10000",					--总套数
//    "builtUpArea" : "13013",				--建筑面积
//    "landArea" : "12200",					--占地面积
//    "volumeRatio" : "45",					--容积率
//    "greeningRatio" : "45",					--绿化率
//    "parkingProportion" : "45",				--车位占比
//    "parkingSeat" : "4333",					--停车位
//    "proxyStartTime" : "2016-03-02 00:00:00",	--代理开始时间
//    "proxyEndTime" : "2016-03-18 00:00:00",	--代理结束时间
//    "customerVisteRule" : "123123123",		--带看规则
//    "commissionStandard" : "12312312",		--佣金规则
//    "dealStandar" : "111",					--成交标准
//    "effectiveType" : 30,					--有效期起始日
//    "lookoverRule" : 1,					--带看规则(0.第一次带看，1.最后一次带看)
//    "customerProtectTerm" : 1,				--客户有效期(0.报备1.带看)
//    "mainCustomer" : "323",					--主力客户年龄
//    "buyHouseDemand" : "232",				--购房需求
//    "buyHouseBudget" : "323",				--购房预算
//    "customerGenera" : "232",				--客群属性
//    "customerWorkArea" : "3232",				--客户工作区域
//    "customerLiveArea" : "32323",			--客户居住区域
//    "expandSkills" : "2332323",				--拓客技巧
//    "status" : "toBePublished",				--楼盘状态
//    "delFlag" : "0",
//    "url" : "http://img1.5i5jfs.cn/img/test/2016/03/02/16/56d6a92cd5576.png_640x437.png",
//    --封面图
//    "customerTelType" : "0",				--客户号码(0.全号,1.引号)
//    "creator" : null,
//    "createTime" : null,
//    "updater" : "1",
//    "updateTime" : "2016-03-18 06:58:36"
//
//    "decorationType" : "豪华装修",				--装修标准
//    "propertyType" : "别墅",				--物业类型
//    "acreageType" : "90平以下",				--区域面积  面积区间
//    "featureTag" : "学区房",				--特色标签
//},
//


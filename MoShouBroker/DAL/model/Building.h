//
//  Building.h
//  MoShouBroker
//  楼盘数据模型
//  Created by NiLaisong on 15/6/18.
//  Copyright (c) 2015年 5i5j. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ShareModel.h"
#import "DownloaderManager.h"
#import "Estate.h"
@interface Building : NSObject


@property(nonatomic,assign) BOOL isHot; //-热销 0否  1是
@property(nonatomic,assign) BOOL isNew; //是否是新楼盘
@property(nonatomic,assign) BOOL isSpecialPrice; //特价  0否  1 是




@property(nonatomic,copy) NSString* buildingId;//楼盘编号
@property(nonatomic,copy) NSString* name;//楼盘名称
@property(nonatomic,strong) Estate* estate;//楼盘详情
@property(nonatomic,assign) BOOL isTop;//是否置顶
@property(nonatomic,copy) NSString* shipAgencyNum;  //--合作经纪人
@property(nonatomic,assign) BOOL favorite;  //收藏

@property(nonatomic,copy) NSString* shareUrl;  //分享URL
@property(nonatomic,copy) NSString* recommendationNum;  //已报备
@property(nonatomic,copy) NSString* visitNum;  //已带看
@property(nonatomic,copy) NSString* signNum;  //已成交
@property(nonatomic,copy) NSString* onsellHouseCount;  //在售房源

@property(nonatomic,copy) NSString* salesPhaseName;  //-销售阶段（estate外面）


@property(nonatomic,strong) NSArray* roomLayoutArray;//主力户型，数组元素RoomLayout
//@property(nonatomic,strong) NSArray* houseTypeLists;  // 即将作废   户型list   //数组元素 HouseType
@property(nonatomic,strong) NSArray* photoLists;  //  楼盘图片  楼盘相册，数组元素Photo
//@property(nonatomic,strong) NSArray* discountLists;  // 认筹  活动和 优惠活动ing 的list 的综合数据    数组元素Discount
@property(nonatomic,strong) NSArray* renChouLists;  //认筹list 数组元素Discount
@property(nonatomic,strong) NSArray* youHuiLists;  //优惠list 数组元素Discount



@property(nonatomic,strong) NSArray* houseLists;  //  房源List  数组元素 House
@property(nonatomic,strong) NSArray* estateBuildings;  //楼座List    数组元素EstateBuilding   （部分实体参照户型）

@property(nonatomic,strong) NSArray* albumArray ;  //  楼盘图片  楼盘相册，数组元素AlbumData

@property(nonatomic,strong) NSArray* caseTelList ;  //  楼盘详情的 联系案场数组

@property(nonatomic,strong) NSArray* easemobConfirmList;  //数组元素  EasemobConfirmModel  在线咨询的确客数组 包含环信用户姓名 昵称等   环信的在线状态等

@property(nonatomic,strong) NSArray *estateDynamicMsgList;  //楼盘动态数组 数组元素EstateDynamicMsgModel


@property(nonatomic,strong) NSArray *specialHouseList;  //特价房    数组元素SpecialHouse



@property(nonatomic,strong) NSArray *ziXunBuildingArray;  //手动塞进去的装数据   是.聊天详情的根据确客获得楼盘列表 请求URL:/api/estateCustomer/customer/getEstateByConfirmUser   数组元素  Estate 主要用了以下字段
//"id": 2356, //楼盘id
//,' cityName':'' //城市
//,' plateName:'' //商圈
//,' url:'' 	      //图片
//"name": "楼兰测试楼盘", //楼盘名称
//"districtName" ："小店区" //区域 商圈




//"recommendationNum": "0",
//"visitNum": "0",
//"signNum": "0",
//"onsellHouseCount": 0,
//"houseTypeList": [],
//"photoList": [],
//"discountList": [],
//"houseList": [],
//"estateBuildings": []

@property(nonatomic,readonly) DownloadStateType downloadState;
@property(nonatomic,strong) ShareModel* shareInfo;//分享数据模型

/**
 居室区间
 */
@property(nonatomic,copy) NSString *bedroomSegment;  // 居室区间


/**
 面积区间
 */
@property(nonatomic,copy) NSString *saleAreaSegment;  // 面积区间

@property(nonatomic,copy) NSString *minPrice;  // 最低总价




//
//
//
//@property(nonatomic,copy) NSString* fullName;//楼盘全称
//@property(nonatomic,copy) NSString* districtName;//楼盘所在区域
//@property(nonatomic,copy) NSString* longitude;//坐标经度
//@property(nonatomic,copy) NSString* latitude;//坐标纬度
//@property(nonatomic,copy) NSString* address;//楼盘地址
//@property(nonatomic,copy) NSString* thmUrl;//楼盘缩略图
//@property(nonatomic,copy) NSString* imgUrl;//楼盘大图片 
//@property(nonatomic,copy) NSString* buildDistance;//距离
//@property(nonatomic,copy) NSString* partnerNum ;//合作经纪人数量
//@property(nonatomic,copy) NSString* price;//均价
//
//@property(nonatomic,copy) NSString* housePrice;//新录入的楼盘价钱
//
//@property(nonatomic,copy) NSString* featureTag;//特设标签
//
//
//
//
//@property(nonatomic,copy) NSString* commissionStandard;//佣金标准
//@property(nonatomic,copy) NSString* commissionSettlement;//佣金结算规则
//@property(nonatomic,copy) NSString* specialAppoint;//特别约定
//
//@property(nonatomic,copy) NSString* activity;//认筹活动
//@property(nonatomic,copy) NSString* activityFinishTime;//活动截止时间
//@property(nonatomic,copy) NSString* discount;//优惠信息
//
//@property(nonatomic,copy) NSString* lookoverRule;//带看规则
//@property(nonatomic,copy) NSString* transactionStandard;//成交标准
//@property(nonatomic,copy) NSString* effectivePeriod;//有效期
//@property(nonatomic,copy) NSString* finishTime;//代理结束日期（合作截止日期）
//
////@property(nonatomic,strong) NSArray* roomLayoutArray;//主力户型，数组元素RoomLayout
//
//@property(nonatomic,copy) NSString* ageRange;//主力客户年龄范围
//@property(nonatomic,copy) NSString* purpose; //主力客户购房目的
//@property(nonatomic,copy) NSString* buyHouseBudget; //买房 购物预算 预算
//
//@property(nonatomic,copy) NSString* customerCareer;//主力客户职业
//@property(nonatomic,copy) NSString* workArea;//主力客户工作区域
//@property(nonatomic,copy) NSString* liveDistrict;//主力客户居住区域
//
//@property(nonatomic,copy) NSString* tookeenSkills;//拓客技巧
//
//@property(nonatomic,copy) NSString* acreageType; //面积区间
//@property(nonatomic,copy) NSString* commissionType; //佣金类型（0百分比，1数值）
//@property(nonatomic,copy) NSString* commissionBegin; //佣金区间开始
//@property(nonatomic,copy) NSString* commissionEnd; //佣金区间结束）
//@property(nonatomic,copy) NSString* formatCommissionStandard; //自己手动拼接的佣金字段
//
//
//@property(nonatomic,copy) NSString* intentionCustomerCount; //意向客户（暂时没有，找张晓迪要）
////@property(nonatomic,copy) NSString* onsellHouseCount; //-在售房源
//
//@property(nonatomic,copy) NSString* reportedCount;     //已报备数
//@property(nonatomic,copy) NSString* lookedCount;       //已带看数
//@property(nonatomic,copy) NSString* recognizedCount;   //已认筹数(暂时没数)
//@property(nonatomic,copy) NSString* subscribedCount;   //已认购数(暂时没数)
//@property(nonatomic,copy) NSString* completedCount;    //已成交数
//
//@property(nonatomic,copy) NSString* customerTelType;    // 全号  隐号报备 (0 :全号隐号均可     1:仅全号)
//
//
//@property(nonatomic,copy) NSString* businessName;//商圈名称
//@property(nonatomic,copy) NSString* salePhone;//案场电话
//@property(nonatomic,copy) NSString* saleFrom;//开盘日期
//@property(nonatomic,copy) NSString* moveinTime; //入住日期
//@property(nonatomic,copy) NSString* greeningRate;//绿化率
//@property(nonatomic,copy) NSString* floorAreaRatio; //容积率
//@property(nonatomic,copy) NSString* builtUpArea;//建筑面积
//@property(nonatomic,copy) NSString* landArea; //占地面积
//@property(nonatomic,copy) NSString* developerName;//开发商
//@property(nonatomic,copy) NSString* presaleLicense;//预售许可
//@property(nonatomic,copy) NSString* propertyYear; //产权年限
//@property(nonatomic,copy) NSString* parkNumber;//停车位
//@property(nonatomic,copy) NSString* roomNumber;//总套数(房源数量)
//@property(nonatomic,copy) NSString* parkRate;//车位配比
//@property(nonatomic,copy) NSString* mainLayout;//主力户型
//@property(nonatomic,copy) NSString* areaRange;//面积区间
//@property(nonatomic,copy) NSString* deliverTime;//交房时间
//@property(nonatomic,copy) NSString* propertyCompanyName;//物业公司
//@property(nonatomic,copy) NSString* propertyFee;//物业费
//@property(nonatomic,copy) NSString* propertyType;//物业类型
//@property(nonatomic,copy) NSString* buildingType; //建筑类型
//@property(nonatomic,copy) NSString* decorationType;//装修标准
//
//@property(nonatomic,copy) NSString* feature;//楼盘特色
//
//@property(nonatomic,copy) NSString* brief;//楼盘简介description
//
//
////status "status": "process",//状态,process 是进行中,finished是已结束
//@property(nonatomic,copy) NSString* status;


@end

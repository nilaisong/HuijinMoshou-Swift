//
//  BuildingCell.h
//  MoShouQueke
//
//  Created by strongcoder on 15/10/28.
//  Copyright (c) 2015年  5i5j. All rights reserved.
//

#import "MyImageView.h"
#import "BuildingListData.h"
#import "BuildingsResult.h"
#import "Building.h"
#import "BuildingImageView.h"
#import "CityFirstResult.h"

typedef NS_ENUM(NSInteger, TableViewCellStyle)
{
    
    HomeTableViewCellStyle,
    MyBuildingTableViewCellDownLoadStyle,
    MyBuildingTableViewCellFavoriteStyle
    
    
};




@interface BuildingCell : UITableViewCell

@property (nonatomic,strong)BuildingImageView *buildImageView; //楼盘图片
@property (nonatomic,assign)BOOL isTop;  //置顶

@property (nonatomic,strong)UIImageView *startImageView; //收藏imageView
@property (nonatomic,assign)BOOL isShouldStartImage;  //是否需要收藏的图标

@property (nonatomic,strong)UILabel *buildNamelabel; //楼盘全程名称带地区的
@property (nonatomic,strong)UILabel *buildDistance ;  //距离
@property (nonatomic,strong)UILabel *priceLabel;    //楼盘均价
//@property (nonatomic,strong)UILabel *cooperativeAgentLabel;  //合作经纪人   后面是经纪人的数量
@property (nonatomic,strong)UILabel *topLabel;    //置顶label
@property (nonatomic,strong)UILabel *hotLabel;    //热点label
@property (nonatomic,strong)UIButton *baoBeiBtn;  //报备按钮

@property (nonatomic,strong)UIImageView *isNewImageView;  //是否为 新楼盘



@property (nonatomic,strong)UIView *yongJingView;
@property (nonatomic,copy)NSString *featureTag;
@property (nonatomic,strong)BuildingListData *buildingListData;

@property (nonatomic,assign)TableViewCellStyle tableViewCellStyle;

@property (nonatomic,strong)CityFirstResult * cityFirstResult;//根据城市ID初始化的数据


//楼盘列表页面
- (instancetype)initWithStyle:(TableViewCellStyle)style andBuildListData:(BuildingListData *)buildListData;

////需要判断热门标签的问题的cell
//- (instancetype)initWithStyle:(TableViewCellStyle)style andBuildListData:(BuildingListData *)buildListData WithBannerInfosResult:(CityFirstResult *)cityFirstResult;
//
////我的楼盘页面
//- (instancetype)initWithStyle:(TableViewCellStyle)style andBuilding:(BuildingListData *)buildding;

+ (CGFloat)buildingCellHeightWithModel:(BuildingListData *)model WithbuildingStyle:(TableViewCellStyle )tableViewStyle;





@end

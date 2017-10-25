//
//  BuildingDetailView.h
//  MoShou2
//
//  Created by Mac on 2016/12/14.
//  Copyright © 2016年 5i5j. All rights reserved.
//
typedef NS_ENUM(NSInteger, BuildingDetailViewStyle)
{
    BuildingSpeciaStyle,    //  楼盘特色
    BuildingDetailStyle,   //  楼盘详情
};


typedef void(^BuildingDetailViewStyleChangeBlock)(CGFloat height, BOOL openStyle ,BuildingDetailViewStyle buildingDetailViewStyle);


#import <UIKit/UIKit.h>
#import "Building.h"
#import "Estate.h"
@interface BuildingDetailView : UIView

@property (nonatomic,assign)BuildingDetailViewStyle buildingDetailViewStyle;

-(id)initWithFrame:(CGRect)frame WithBuildingDetailViewStyle:(BuildingDetailViewStyle)buildingDetailViewStyle AndBuildingMo:(Building *)buildingMo AndOpenStyle:(BOOL)openStyle;

@property (nonatomic,copy)BuildingDetailViewStyleChangeBlock buildingDetailViewStyleChangeBlock;



+(CGFloat)buildingDetailHeightWith:(Building *)buildingMo;

//+ (CGFloat)buildingCellHeightWithModel:(BuildingListData *)model WithbuildingStyle:(TableViewCellStyle )tableViewStyle;



@end

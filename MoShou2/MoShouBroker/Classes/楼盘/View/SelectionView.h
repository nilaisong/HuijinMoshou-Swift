//
//  SelectionView.h
//  MoShou2
//
//  Created by strongcoder on 15/11/24.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingsResult.h"
#import "OptionData.h"
#import "CityFirstResult.h"
#import "DistrictModel.h"
#import "ItemData.h"
#import "PlatList.h"
#import "SysDic.h"
#import "Standard.h"
#import "PriceModel.h"
#import "MoreChooseView.h"

typedef NS_ENUM(NSInteger, CommitType)
{
    
    CommitTypeStyle,  // 确定
    CleanTypeStyle   //重置  清空
    
    
    
};

@class SelectionView;

@protocol SelectionViewDelegate <NSObject>

@optional

-(void)select:(SelectionView *)selectView withchooseIndex:(NSInteger)chooseindex AndOptionData:(ItemData *)optionData AndPriceModel:(PriceModel *)priceModel;

/**
 *  单独传出  最后一个页面的数据代理   最后添加的页面
 *
 *  @param selectView <#selectView description#>
 *  @param moreDic    <#moreDic description#>
 */

-(void)select:(SelectionView *)selectView WithMoreChooseDic:(NSDictionary *)moreDic WithCommitType:(CommitType)commitTpye;



/**
 距离的  代理

 @param selectView <#selectView description#>
 @param chooseString <#chooseString description#>
 @param optionData <#optionData description#>
 */
-(void)select:(SelectionView *)selectView withchooseString:(NSString *)chooseString AndOptionData:(ItemData *)optionData;


@end


@interface SelectionView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MoreChooseViewDelegate>

-(id)initWithFrame:(CGRect)frame WithBuildingsResult:(CityFirstResult *)cityFirstResult WithIsMapSeleView:(BOOL )isMapSeleView;

-(void)setSelectBtnStateNormal;

-(void)setTableViewCloseAndNomalStyle;



@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *secondTableView;

@property (nonatomic,strong)UIView *customPriceView;  //自定义价格区间的View
@property (nonatomic,strong)UITextField *firstTF;
@property (nonatomic,strong)UITextField *secondTF;

@property (nonatomic,strong)MoreChooseView *moreChooseView;  //更多页面   选择 等等  


@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)BOOL isTableViewOpen;
@property (nonatomic,weak)id<SelectionViewDelegate>delegate;

@end

//
//  PopView.h
//  MoShou2
//
//  Created by Mac on 2016/12/16.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"
#import "Estate.h"
#import "CaseTelList.h"
#import "EasemobConfirmModel.h"



@class PopView;

@protocol PopViewDelegate <NSObject>

-(void)didCancelWith:(PopView *)popView;

@end

typedef void (^GetDidSelectOneCaseTelViewBlock)(CaseTelList *caseTelListMo);

typedef void (^GetDidSelectEasemobConfirmModelBlock)(EasemobConfirmModel *easemobConfirmMo);


typedef void (^GetDidSelectOneBuildingBlock)(Estate *estareModel);

typedef enum {
    kRenChouHuoDong,  //认筹活动
    kCommissionRuleCooperationRule,//佣金规则 合作规则
    kOnLineChat , //   在线咨询
    kConnectionsSquare, //联系案场
    kConsultBuilding ,   //咨询楼盘
    kRecommendBuilding //  推荐楼盘
}PopViewType;

@interface PopView : UIView


@property (nonatomic,assign)PopViewType popViewType;
@property (nonatomic,strong)UIScrollView * bgScrollView;
@property (nonatomic,strong)Building *buildingMo;
@property (nonatomic,strong)Estate * estateBuildingMo;

@property (nonatomic,copy)GetDidSelectOneCaseTelViewBlock DidSelectOneCaseTelViewBlock;
@property (nonatomic,copy)GetDidSelectEasemobConfirmModelBlock DidSelectOneEasemobConfirmBlock;
@property (nonatomic,copy)GetDidSelectOneBuildingBlock DidSelectOneBuildingBlock;





@property (nonatomic,weak)id<PopViewDelegate>delegate;

-(id)initWithType:(PopViewType)popViewType AndBuilding:(Building *)building;



@end

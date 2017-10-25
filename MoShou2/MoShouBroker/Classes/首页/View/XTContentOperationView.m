//
//  XTContentOperationView.m
//  MoShou2
//
//  Created by xiaotei's on 16/9/8.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTContentOperationView.h"
#import "XTOperationItemView.h"
#import "UIViewExt.h"
#import "XTOperationModel.h"
#import "XTOperationModelItem.h"
#import "UserData.h"
#import "Tool.h"

@interface XTContentOperationView()
/**
 *  点击事件回调
 */
@property (nonatomic,copy)ContentOperationViewCallBack callBack;

@property (nonatomic,strong)NSArray* itemArray;

@property (nonatomic,weak)UIView* horizontalLineView;

@property (nonatomic,weak)UIView* verticalLineView1;

@property (nonatomic,weak)UIView* verticalLineView2;

@end

@implementation XTContentOperationView

- (instancetype)initWithCallBack:(ContentOperationViewCallBack)callBack{
    if (self = [super init]) {
        self.callBack = callBack;
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat margin = 0.0;
    CGFloat width = ceilf(self.width - margin) / 2.0;
    CGFloat height = ceilf(self.height - margin) / 2.0;
    
    for (int i = 0; i < self.itemArray.count; i++) {
        x = i % 2 * width + (i % 2) * margin;
        y = i / 2 * height + (i / 2) * margin;
        XTOperationItemView* itemV = (XTOperationItemView*)_itemArray[i];
        itemV.frame = CGRectMake(x, y, width, height);
    }
    
    self.horizontalLineView.frame = CGRectMake(10, self.height / 2.0 - 0.25, kMainScreenWidth - 20, 0.5);
    self.verticalLineView1.frame = CGRectMake(kMainScreenWidth / 2.0 - 0.25, 10, 0.5, self.height / 2.0 - 20);
    
    self.verticalLineView2.frame = CGRectMake(kMainScreenWidth / 2.0 - 0.5, CGRectGetMaxY(_horizontalLineView.frame) + 10, 0.5, self.height / 2.0 - 20);
}

/**
 *  懒加载四个视图
 */
- (NSArray *)itemArray{
    if (!_itemArray) {
        NSMutableArray* arrayM = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            __weak typeof(self) weakSelf = self;
            XTOperationItemView* itemV = [[XTOperationItemView alloc]initWithCallBack:^(XTOperationItemView *view) {
                if (weakSelf.callBack) {
                    [view setHiddenNewTips:YES];
                    
                    [self initCacheIDWithKey:view.itemModel.type id:view.itemModel.ID];
                    switch (view.tag) {
                        case 0:
                            weakSelf.callBack(weakSelf,ContentOperationTypeNews);
                            break;
                        case 1:
                            weakSelf.callBack(weakSelf,ContentOperationTypeProjecRecommendation);
                            break;
                        case 2:
//                            weakSelf.callBack(weakSelf,ContentOperationTypeHeadlines);
                            weakSelf.callBack(weakSelf,ContentOperationTypeNewFunction);

                            break;
                        case 3:
                            weakSelf.callBack(weakSelf,ContentOperationTypeHeadlines);

//                            weakSelf.callBack(weakSelf,ContentOperationTypeNewFunction);
                            break;
                        default:
                            break;
                    }
                }
            }];
            itemV.tag = i;
            switch (i) {
                case 0:
                    itemV.title = @"最新资讯";
                    break;
                case 1:
                    itemV.title = @"项目推荐";
                    break;
                case 2:
                    itemV.title = @"魔售新功能";
//                    itemV.title = @"头条经纪人";
                    break;
                case 3:
                    itemV.title = @"头条经纪人";

//                    itemV.title = @"魔售新功能";
                    break;
                    
                default:
                    break;
            }
            [arrayM appendObject:itemV];
            [self addSubview:itemV];
        }
        _itemArray = arrayM;
    }
    return _itemArray;
}

- (void)setOperationModel:(XTOperationModel *)operationModel{
    _operationModel = operationModel;
    
    
    [self initItemWithOperationModel:operationModel];
    
    [self setNeedsDisplay];
}

- (void)initItemWithOperationModel:(XTOperationModel*)model{
    XTOperationItemView* itemView = nil;
    for (int i = 0; i < self.itemArray.count; i++) {
        itemView = _itemArray[i];
        switch (i) {
            case 0:
            {
                itemView.itemModel = model.recd_news;
                itemView.title = @"最新资讯";
                [self initNewTipeWith:itemView ID:model.recd_news.ID key:model.recd_news.type];
            }
                break;
            case 1:
            {
                itemView.itemModel = model.recd_project;
                itemView.title = @"项目推荐";
                [self initNewTipeWith:itemView ID:model.recd_project.ID key:model.recd_project.type];
            }
                break;
            case 2:
            {
                itemView.itemModel = model.recd_features;
                itemView.title = @"魔售新功能";
                [self initNewTipeWith:itemView ID:model.recd_features.ID key:model.recd_features.type];
//                itemView.itemModel = model.recd_agency;
//                itemView.title = @"头条经纪人";
//                [self initNewTipeWith:itemView ID:model.recd_agency.ID key:model.recd_agency.type];
            }
                break;
            case 3:
            {
                itemView.itemModel = model.recd_agency;
                itemView.title = @"头条经纪人";
                [self initNewTipeWith:itemView ID:model.recd_agency.ID key:model.recd_agency.type];

                
//                itemView.itemModel = model.recd_features;
//                itemView.title = @"魔售新功能";
//                [self initNewTipeWith:itemView ID:model.recd_features.ID key:model.recd_features.type];
            }
                break;
                
            default:
                break;
        }
        [itemView setNeedsDisplay];
    }
    //    [self setNeedsLayout];
}

- (void)initNewTipeWith:(XTOperationItemView*)itemV ID:(NSString*)ID key:(NSString*)key {
    if (key == nil || key.length <= 0) {
        [itemV setHiddenNewTips:YES];
        return;
    }
    NSString* getID = [Tool getCache:key];
    
    [itemV setHiddenNewTips:YES];
    if (getID && getID.length > 0) {
        if (getID.integerValue >= ID.integerValue) {
            [itemV setHiddenNewTips:YES];
        }else{
            
            [itemV setHiddenNewTips:NO];
        }
    }else{
        [itemV setHiddenNewTips:NO];
    }
}

- (void)initCacheIDWithKey:(NSString*)key id:(NSString*)ID{
    if (key == nil || key.length <= 0) {
        return;
    }
    NSString* getID = [Tool getCache:key];
    
    if (getID.integerValue < ID.integerValue) {
        [Tool setCache:key value:ID];
    }
}

- (UIView *)horizontalLineView{
    if (!_horizontalLineView) {
        UIView* lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
        [self addSubview:lineV];
        _horizontalLineView = lineV;
    }
    return _horizontalLineView;
}

- (UIView *)verticalLineView1{
    if (!_verticalLineView1) {
        UIView* lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
        [self addSubview:lineV];
        _verticalLineView1 = lineV;
    }
    return _verticalLineView1;
}

- (UIView *)verticalLineView2{
    if (!_verticalLineView2) {
        UIView* lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
        [self addSubview:lineV];
        _verticalLineView2 = lineV;
    }
    return _verticalLineView2;
}

@end

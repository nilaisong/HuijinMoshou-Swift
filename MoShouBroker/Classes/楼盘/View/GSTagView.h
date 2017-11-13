//
//  GSTagView.h
//  TagsAutoLayout
//
//  Created by 小怪兽 on 15/2/11.
//  Copyright (c) 2015年 小怪兽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YR.h"




typedef NS_ENUM(NSInteger, TagViewStyle)
{
    ShaiXuanTagViewStyle,    //  楼盘筛选的
    BuildingDetailTagViewStyle,   //  楼盘详情的tag
};

/*-------------------------代理-------------------------*/
@protocol GSTagViewDelegate <NSObject>

- (void)didSelectAtIndex:(int)index;

@end
/*-------------------------代理-------------------------*/

typedef void(^selectedBlock)(int index);

@interface GSTagView : UIView

@property (nonatomic, assign) UIEdgeInsets      padding;            //边距
@property (nonatomic, assign) CGFloat           horizontalSpace;    //横向间隔
@property (nonatomic, assign) CGFloat           verticalSpace;      //纵向间隔
@property (nonatomic, assign) TagViewStyle tagViewStyle;   //  筛选样式枚举
@property (nonatomic, strong) NSArray           *dataSource;        //数据源
@property (nonatomic, weak) id <GSTagViewDelegate> delegate;      //delegate
@property (nonatomic, copy) selectedBlock didSelectedAtIndex;     //block

@end

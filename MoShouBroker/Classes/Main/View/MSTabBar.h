//
//  MSTabBar.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/20.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MSTabBarDelegate <NSObject>

/**
 *  代理方法告知选中的itme
 */
@required
-(void)didSelectedItem:(UIButton*)item atIndex:(NSInteger)index WithTouchNum:(NSInteger )touchNum;

@end

@interface MSTabBar : UIView

@property (nonatomic,strong)NSArray* tabBarIetmsArray;

//初始化操作
//-(void)commonInit;

@property (nonatomic,weak)id<MSTabBarDelegate> delegate;

- (void)setSelectedIndex:(NSInteger)index;

@end

//
//  MineItemButtonView.h
//  MoShou2
//
//  Created by wangzz on 2016/11/28.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineItemButtonView;
@protocol MineItemButtonViewDelegate <NSObject>

@optional

- (void)itemViewTapClick:(MineItemButtonView*)itemBtnView;

@end

@interface MineItemButtonView : UIView

//@property (nonatomic, strong) UIImageView      *itemImgView;
//@property (nonatomic, strong) UILabel          *titleLabel;
@property (nonatomic, weak) id<MineItemButtonViewDelegate> delegate;

- (id)initViewWithImgName:(NSString*)imgName WithTitle:(NSString*)title WithFrame:(CGRect)frame;

@end

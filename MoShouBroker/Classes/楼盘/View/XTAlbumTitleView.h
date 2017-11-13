//
//  XTAlbumTitleView.h
//  MoShou2
//
//  Created by xiaotei's MacBookPro on 17/1/6.
//  Copyright © 2017年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTAlbumTitleView;
typedef void(^AlbumTitleViewAction)(XTAlbumTitleView* titleView,NSInteger index,UIButton* button);

@interface XTAlbumTitleView : UIView

@property (nonatomic,strong)NSArray* titleArray;

@property (nonatomic,assign)NSInteger currentIndex;

- (instancetype)initWithCallBack:(AlbumTitleViewAction)callBack;

@end

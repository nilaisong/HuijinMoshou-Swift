//
//  YRPageControl.h
//  
//
//  Created by strongcoder on 15/7/20.
//  Copyright (c) 2015年 5i5j. All rights reserved.//
//

#import <UIKit/UIKit.h>

@protocol YRPageControlDelegate <NSObject>

- (void)didPageControlClickedAtIndex:(NSInteger)index;

@end


@interface YRPageControl : UIView

@property (nonatomic,assign) id<YRPageControlDelegate> delegate;
@property (nonatomic,assign) NSInteger currentPage;

- (instancetype)initWithFrame:(CGRect)frame totalCount:(NSInteger)totalCount;

@end

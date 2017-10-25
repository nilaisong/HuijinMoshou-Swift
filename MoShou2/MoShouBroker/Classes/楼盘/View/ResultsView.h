//
//  ResultsView.h
//  MoShou2
//
//  Created by strongcoder on 15/12/29.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultData.h"

@protocol ResultsViewDelegate <NSObject>

-(void)promptBoxShow:(NSInteger)buttonTag;

@end

@interface ResultsView : UIView

-(id)initWithFrame:(CGRect)frame andResultData:(ResultData *)benJinData andResultData:(ResultData *)benXiData andIsZongjia:(BOOL)isZongjia;

@property(nonatomic,assign)id<ResultsViewDelegate>resultsDelegate;
@end

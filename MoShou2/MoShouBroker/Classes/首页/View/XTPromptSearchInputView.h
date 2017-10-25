//
//  XTPromptSearchInputView.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HistoryCellHeight 57

typedef void(^HistoryInputViewSelectCallBack)(NSInteger index,NSString* keyword);


@interface XTPromptSearchInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectBlock:(HistoryInputViewSelectCallBack)callBack;

+ (instancetype)historyViewWithFrame:(CGRect)frame selectBlock:(HistoryInputViewSelectCallBack)callBack;

@property (nonatomic,copy)HistoryInputViewSelectCallBack callBack;

//提示文字数组
@property (nonatomic,strong)NSArray* promptsArray;

@end

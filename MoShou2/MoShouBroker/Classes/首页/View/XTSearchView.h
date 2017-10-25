//
//  XTSearchView.h
//  MoShou2
//
//  Created by xiaotei's on 15/11/26.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>

//返回输入入的关键字keyword,是否确定搜索内容isDetermine
typedef void(^XTSearchViewGetInputCallBack)(NSString* keyword,BOOL isDetermine);

@interface XTSearchView : UIView


- (instancetype)initWithFrame:(CGRect)frame inputCallBack:(XTSearchViewGetInputCallBack)callBack;

//提示文本数组，设置后即可刷新提示数组
@property (nonatomic,strong)NSArray* promptArray;



@property (nonatomic,copy)XTSearchViewGetInputCallBack callBack;

@end

//
//  MyPickerView.h
//  MoShou2
//
//  Created by strongcoder on 15/12/21.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, MyPickerViewStyle)
{
    
    MyPickerViewYearsStyle,
    MyPickerViewShouFuBiStyle,
    
};

@class MyPickerView;

@protocol MyPickerViewDelegate <NSObject>


//确定
-(void)determineBtnClick:(MyPickerView *)PickerView WithChooseString:(NSString *)chooseString;



//取消和点击背景
-(void)tapBgViewAndCancel:(MyPickerView *)PickerView;



@end




@interface MyPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,assign)MyPickerViewStyle pickerViewStyle;
@property (nonatomic,weak)id<MyPickerViewDelegate>delegate;
@property (nonatomic,copy)NSString * nomoreSelectString;



-(id)initWithpickerStyle:(MyPickerViewStyle)pickerViewStyle;


@end

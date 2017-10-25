//
//  MortgageCalculatorView.h
//  MoShou2
//
//  Created by strongcoder on 15/12/15.
//  Copyright © 2015年 5i5j. All rights reserved.
//


@class MortgageCalculatorView;

@protocol MortgageCalculatorViewDelegate <NSObject>

@optional

-(void)select:(MortgageCalculatorView *)view Withindex:(NSInteger)index;



@end

typedef NS_ENUM(NSInteger, MortgageCalculatorViewStyle)
{
    
    danJiaStyle,
    zongJiaStyle,

};

#import <UIKit/UIKit.h>
#import "ProvideView.h"
#import "MyPickerView.h"
#import "ResultsView.h"

@interface MortgageCalculatorView : UIView <UITableViewDataSource,UITableViewDelegate,ProvideViewDelegate,MyPickerViewDelegate,UITextFieldDelegate,ResultsViewDelegate>
@property (nonatomic,strong)UITextField *unitPriceTF;  //单价

@property (nonatomic,strong)UITextField *allPriceTF;  //总价


@property (nonatomic,strong)UITextField *areaTF;    //面积

@property (nonatomic,strong)UITextField *firstPayTF; //首付

@property (nonatomic,strong)UILabel *firstPayProportionLabel; //首付比

@property (nonatomic,strong)UITextField *provideAllMonely;  //贷款总额

@property (nonatomic,strong)UITableView *tableView;

//@property (nonatomic,strong)ProvideView *gongJiCellView;
//@property (nonatomic,strong)ProvideView *shangYeCellView;



@property (nonatomic,assign)MortgageCalculatorViewStyle mortgageCalculatorViewStyle;

@property (nonatomic,weak)id<MortgageCalculatorViewDelegate>delegate;



@property (nonatomic,copy)NSString *area;  //面积

@property (nonatomic,copy)NSString *housePrise;  //单价



-(id)initWithFrame:(CGRect)frame AndViewStyle:(MortgageCalculatorViewStyle) mortgageCalculatorViewStyle;


@end

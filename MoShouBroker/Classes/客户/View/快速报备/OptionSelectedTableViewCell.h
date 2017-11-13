//
//  OptionSelectedTableViewCell.h
//  MoShou2
//
//  Created by wangzz on 15/12/14.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBuilding.h"
#import "CustomerShowVisitInfoView.h"

@class OptionSelectedTableViewCell;

typedef void(^deleteOptionsBlock)(OptionSelectedTableViewCell*);
typedef void(^selecteOptionsBlock)(OptionSelectedTableViewCell*,BOOL);

@interface OptionSelectedTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel    *loupNameL;
@property (nonatomic, strong) UIView     *juliView;
@property (nonatomic, strong) UIView     *yongJinView;
//@property (nonatomic, strong) UILabel    *flagL;
@property (nonatomic, strong) UILabel    *custTelTypeL;
@property (nonatomic, strong) UIButton   *selectedBtn;
@property (nonatomic, strong) UIButton   *deleteBtn;
@property (nonatomic, assign) NSInteger  tableType;
@property (nonatomic, strong) CustomerBuilding *buildingListData;

@property (nonatomic, strong) UILabel    *visitLabel;
@property (nonatomic, strong) CustomerShowVisitInfoView  *showVisitInfoView;
@property (nonatomic, assign) BOOL      bIsShowVisitInfo;
@property (nonatomic, assign) BOOL      bIsShowConfirmInfo;

@property (nonatomic, copy) selecteOptionsBlock didSelectedLouPOption;
@property (nonatomic, copy) deleteOptionsBlock  didDelectedLouPOption;

- (instancetype)initWithBuildListData:(CustomerBuilding *)buildListData AndTableType:(NSInteger)tableType;

-(void)optionDeleteCellBlock:(deleteOptionsBlock)ablock;
-(void)optionSelectCellBlock:(selecteOptionsBlock)ablock;

@end

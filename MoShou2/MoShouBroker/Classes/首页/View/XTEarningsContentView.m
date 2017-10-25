//
//  XTEarningsContentView.m
//  MoShou2
//
//  Created by xiaotei's on 15/12/17.
//  Copyright © 2015年 5i5j. All rights reserved.
//

#import "XTEarningsContentView.h"

//是否隐藏，默认是NO
#define EyeStatus @"EyeStatus"

@interface XTEarningsContentView()

//选中即闭眼
@property (weak, nonatomic) IBOutlet UIButton *yanjingButton;
@property (weak, nonatomic) IBOutlet UILabel *thisMonthEarningLabel;

@property (weak, nonatomic) IBOutlet UILabel *allEarningLabel;


@property (nonatomic,copy)NSString* thisMonthEarning;

@property (nonatomic,copy)NSString* allEarning;
@end

@implementation XTEarningsContentView

+ (instancetype)earningsContentView{
    NSString* className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil]lastObject];
}

+ (instancetype)earningsContentViewWithEventCallBack:(XTEarningsContentViewEventCallBack)callBack{
    XTEarningsContentView* contentView = [XTEarningsContentView earningsContentView];
    contentView.callBack = callBack;
    return contentView;
}

- (void)awakeFromNib{
    [self reloadInfo];
    _thisMonthEarning = @"-";
    _allEarning = @"-";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL status = [defaults boolForKey:EyeStatus];
    
    self.yanjingButton.selected = status;
    
    [self yanjingStatus:status];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{

}
- (IBAction)eyeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.selected forKey:EyeStatus];
    [self yanjingStatus:sender.selected];
}
//总资产 问号按钮点击
- (IBAction)questionButtonClick:(UIButton *)sender {
    if (_callBack) {
        _callBack(self,XTEarningsContentViewEventTypeQuestion);
    }
}
//查看记录按钮点击
- (IBAction)viewRecord:(UIButton *)sender {
    if (_callBack) {
        _callBack(self,XTEarningsContentViewEventTypeViewRecord);
    }
    
}
//眼镜状态
- (void)yanjingStatus:(BOOL)status{
    if (status) {//选中闭眼
        _thisMonthEarningLabel.text = @"****";
        _allEarningLabel.text = @"****";
    }else{
        _thisMonthEarningLabel.text = _thisMonthEarning;
        _allEarningLabel.text = _allEarning;
    }
}

- (void)setIncomeModel:(XTIncomeAllModel *)incomeModel{

    _incomeModel = incomeModel;
    
    [self reloadInfo];

}

- (void)reloadInfo{
    if (!_incomeModel)return;
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
     [numberFormatter setPositiveFormat:@"###,##0"];
//    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    _thisMonthEarning = [numberFormatter stringFromNumber: [NSNumber numberWithFloat:_incomeModel.currentMonthCommission]];
//     = _thisMonthEarningLabel.text;
    _allEarning = [numberFormatter stringFromNumber: [NSNumber numberWithFloat:_incomeModel.allCommission]];
//     = _allEarningLabel.text;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL status = [defaults boolForKey:EyeStatus];
    [self yanjingStatus:status];
}

@end

//
//  XTCustomerDetailTelCell.m
//  MoShou2
//
//  Created by xiaotei's on 16/5/9.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "XTCustomerDetailTelCell.h"
#import "NSString+Extension.h"

@interface XTCustomerDetailTelCell()

@property (nonatomic,copy)CustomerDetailTelCellActionResult callBack;

//电话号
@property (nonatomic,weak)UILabel* hidenTelLabel;
@property (nonatomic,weak)UILabel* totalTelLabel;

//是否是引号号码
@property (nonatomic,assign)BOOL isHiden;

@property (nonatomic,assign)BOOL shuangHao;

@property (nonatomic,weak)UIButton* callButton;

@property (nonatomic,weak)UIView* lineView;

@property (nonatomic,weak)UILabel* editingLabel;
@end

@implementation XTCustomerDetailTelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)customerDetailTelCellWithTableView:(UITableView *)tableView{
    NSString* className = NSStringFromClass([XTCustomerDetailTelCell class]);
    
    XTCustomerDetailTelCell* cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        [tableView registerClass:[XTCustomerDetailTelCell class] forCellReuseIdentifier:className];
        cell = [tableView dequeueReusableCellWithIdentifier:className];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.userInteractionEnabled = true;
    cell.userInteractionEnabled = true;
    return  cell;
}

+ (instancetype)customerDetailTelCellWithTableView:(UITableView *)tableView eventCallBack:(CustomerDetailTelCellActionResult)callBack{
    XTCustomerDetailTelCell* cell = [XTCustomerDetailTelCell customerDetailTelCellWithTableView:tableView];
    cell.callBack = callBack;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [@"13525123532" sizeWithfont:[UIFont systemFontOfSize:19] maxSize:CGSizeMake(200, 22)];
    if (!_shuangHao) {
        if (_totalTelLabel.text != nil && _totalTelLabel.text.length > 0 ) {
            _totalTelLabel.frame = CGRectMake(16, (self.frame.size.height - 14)/2.0, size.width, 15);
        }else {
            _hidenTelLabel.frame = CGRectMake(16, (self.frame.size.height - 14)/2.0, size.width, 15);
        }
        
        self.callButton.frame = CGRectMake(kMainScreenWidth - 38, (self.frame.size.height - 22)/2.0, 22, 22);
    }else{
        _totalTelLabel.frame = CGRectMake(16, 15,size.width, 15);
        _hidenTelLabel.frame = CGRectMake(16, 39, size.width, 15);
        self.callButton.frame = CGRectMake(kMainScreenWidth - 38, (self.frame.size.height - 22)/2.0, 22, 22);
    }
    
//    self.grayLineView.frame = CGRectMake(16, self.frame.size.height - 0.5,kMainScreenWidth, 0.5);
    self.lineView.frame = CGRectMake(16, 0, kMainScreenWidth, 0.5);
    _callButton.hidden = _isHiden;
}

- (void)setMobileModel:(MobileVisible *)mobileModel{
    _mobileModel = mobileModel;
    
    if (mobileModel.hidingPhone != nil) {
//        NSMutableString* string = [NSMutableString stringWithString:mobileModel.hidingPhone];
//        NSRange strRange = NSMakeRange(3, 4);
//        [string replaceCharactersInRange:strRange withString:@"****"];
//        mobileModel.hidingPhone = string;
    }
    
    
    self.hidenTelLabel.text = mobileModel.hidingPhone;
    self.totalTelLabel.text = mobileModel.totalPhone;
    
    
    _isHiden = NO;
    if (([mobileModel.hidingPhone rangeOfString:@"*"].location != NSNotFound) && (mobileModel.totalPhone.length <= 0)) {
        _isHiden = YES;
    }
//    _isHiden = mobileModel.totalPhone == nil || mobileModel.totalPhone.length <= 0;
    _shuangHao = (mobileModel.totalPhone.length > 0 && mobileModel.totalPhone != nil) && (mobileModel.hidingPhone.length > 0 && mobileModel.hidingPhone != nil);
    [self setNeedsDisplay];
}

- (UILabel *)hidenTelLabel{
    if (_hidenTelLabel == nil) {
        UILabel* label = [[UILabel alloc]init];
        UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        label.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        label.font = [UIFont systemFontOfSize:14];
        gesture.minimumPressDuration = 0.4;
        
        label.userInteractionEnabled = true;
        
        
        [label addGestureRecognizer:gesture];
        
        [self.contentView addSubview:label];
        
        _hidenTelLabel = label;
    }
    return _hidenTelLabel;
}


- (UILabel*)totalTelLabel{
    if (_totalTelLabel == nil) {
        UILabel* label = [[UILabel alloc]init];
        label.text = @"11111111111";
        label.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
        label.font = [UIFont systemFontOfSize:14];
        UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
        
        gesture.minimumPressDuration = 0.4;
        
        label.userInteractionEnabled = true;
        
        
        [label addGestureRecognizer:gesture];
        [self.contentView addSubview:label];
        _totalTelLabel = label;
    }
    return _totalTelLabel;
}

- (UIButton *)callButton{
    if (_callButton == nil) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"shape-tel"] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        
        _callButton = btn;
    }
    return _callButton;
}

- (void)callButtonClick:(UIButton*)button{
    if (_callBack) {
        {
            if ([_mobileModel.hidingPhone rangeOfString:@"*"].location == NSNotFound) {
                _callBack(CustomerDetailTelCellEventCall,_mobileModel.hidingPhone);
            }else if (_mobileModel.totalPhone.length > 0){
                _callBack(CustomerDetailTelCellEventCall,_mobileModel.totalPhone);
            }
            
        }
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
        [self addSubview:view];
        _lineView = view;
    }
    
    return _lineView;
}

#pragma mark - 拷贝相关

- (void)handleLongPress:(UIGestureRecognizer*)gesure{

    if (gesure.state == UIGestureRecognizerStateBegan && [self becomeFirstResponder]){
        if (_editingLabel) {
            [_editingLabel resignFirstResponder];
            _editingLabel.backgroundColor = [UIColor clearColor];
        }
        _editingLabel =  (UILabel*)gesure.view;
        UIMenuItem *copyLink = nil;
        
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
        
        [[UIMenuController sharedMenuController] setTargetRect:_editingLabel.frame inView:self.contentView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
        [[UIMenuController sharedMenuController] update];
    }
    
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    //    self.bubbleView.selectedToShowCopyMenu = NO;
    _editingLabel.backgroundColor = [UIColor clearColor];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    //    self.bubbleView.selectedToShowCopyMenu = YES;
    _editingLabel.backgroundColor = bgViewColor;
}


-(void)copy:(id)sender

{
    [[UIPasteboard generalPasteboard] setString:_editingLabel.text];
    [self resignFirstResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    return (action == @selector(copy:));
    
}

-(BOOL)canBecomeFirstResponder
{
    
    return YES;
    
}

@end

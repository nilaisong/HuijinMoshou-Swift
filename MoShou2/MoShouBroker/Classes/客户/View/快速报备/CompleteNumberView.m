//
//  CompleteNumberView.m
//  MoShou2
//
//  Created by wangzz on 16/5/11.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CompleteNumberView.h"
#import "NSString+Extension.h"

@implementation CompleteNumberView
@synthesize nameLabel;
@synthesize firstNum;
@synthesize middleNum;
@synthesize tailNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACKGROUNDCOLOR;
    }
    return self;
}

- (void)setPhone:(NSString *)phone
{
    if (_phone != phone) {
        _phone = phone;
    }
    [self layoutUI];
}

- (void)layoutUI
{
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 30)];//kMainScreenWidth - 15 - 10 - 190
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = FONT(16);
    nameLabel.textColor = LABELCOLOR;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.hidden = YES;
    [self addSubview:nameLabel];

    firstNum = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right, 7, 50, 30)];//kMainScreenWidth - 140 - 50
    firstNum.text = [_phone substringWithRange:NSMakeRange(0, 3)];
    firstNum.backgroundColor = [UIColor clearColor];
    firstNum.textColor = NAVIGATIONTITLE;
    firstNum.textAlignment = NSTextAlignmentCenter;
    firstNum.font = [UIFont systemFontOfSize:18];
    
    [self addSubview:firstNum];
    
    middleNum = [[CompleteNumTextField alloc] initWithFrame:CGRectMake(firstNum.right, firstNum.top, 70, 30)];//kMainScreenWidth - 70 - 70
    middleNum.backgroundColor = [UIColor whiteColor];
    middleNum.delegate = self;
    middleNum.placeholder = @"中间四位";
    middleNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    middleNum.textColor = NAVIGATIONTITLE;
    middleNum.font = [UIFont systemFontOfSize:18];
    [middleNum.layer setCornerRadius:4.0];
    [middleNum.layer setMasksToBounds:YES];
    [middleNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
    [middleNum.layer setBorderWidth:0.5];
    middleNum.textAlignment = NSTextAlignmentCenter;
    [middleNum addTarget:self action:@selector(middleNumTextFieldDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    [middleNum addTarget:self action:@selector(middleNumTextFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    [middleNum addTarget:self action:@selector(middleNumTextFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:middleNum];
    
    tailNum = [[UILabel alloc] initWithFrame:CGRectMake(middleNum.right, firstNum.top, 70, 30)];//kMainScreenWidth - 70
    tailNum.text = [_phone substringWithRange:NSMakeRange(7, 4)];
    tailNum.backgroundColor = [UIColor clearColor];
    tailNum.textColor = NAVIGATIONTITLE;
    tailNum.textAlignment = NSTextAlignmentCenter;
    tailNum.font = [UIFont systemFontOfSize:18];
    [self addSubview:tailNum];
    
    [self addSubview:[self createLineView:43.5 withX:15]];
}

- (UIView *)createLineView:(CGFloat)y withX:(CGFloat)x
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kMainScreenWidth-x, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

- (void)middleNumTextFieldDidBegin
{
    [middleNum.layer setBorderColor:BLUEBTBCOLOR.CGColor];
}

- (void)middleNumTextFieldDidEnd
{
    [middleNum.layer setBorderColor:TFPLEASEHOLDERCOLOR.CGColor];
}

- (void)middleNumTextFieldDidChanged{
    if (middleNum.text.length >= 4) {
        middleNum.text = [middleNum.text substringToIndex:4];
        self.didChangeAtIndex(self.index);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
    if(![string isValidNumber]){
        return NO;
    }
    return YES;
    
}

- (void)completeTextFieldDidChangedBlock:(completeTextFieldBlock)ablock
{
    self.didChangeAtIndex = ablock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  CustomerCopyPhoneView.m
//  MoShou2
//
//  Created by wangzz on 16/5/12.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "CustomerCopyPhoneView.h"
#import "MobileVisible.h"

@interface CustomerCopyPhoneView()

@property (nonatomic, strong) UIView *groupView;
@property (nonatomic, strong) UIButton *telBtn;

@end

@implementation CustomerCopyPhoneView
@synthesize groupView;
@synthesize telBtn;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:0.3];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)setPhoneArray:(NSArray *)phoneArray
{
    _phoneArray = phoneArray;
    [self layoutUI];
}

- (void)layoutUI
{
    groupView = [[UIView alloc] initWithFrame:CGRectMake(0.1*self.width, self.height/3, 0.8*self.width, 0)];
    
    groupView.backgroundColor = [UIColor whiteColor];
    groupView.alpha = 0.95;
    [groupView.layer setMasksToBounds:YES];
    [groupView.layer setCornerRadius:8.0];
    [self addSubview:groupView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, groupView.width, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"复制号码";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = NAVIGATIONTITLE;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [groupView addSubview:titleLabel];
    
    [groupView addSubview:[self createLineView:titleLabel.bottom+4.5]];
    if (_phoneArray.count>0) {
        MobileVisible *mobile = [_phoneArray objectForIndex:0];
        if (![self isBlankString:mobile.hidingPhone] && ![self isBlankString:mobile.totalPhone]) {
            for (int i=0; i<2; i++) {
                NSString *str = @"";
                if (i==0) {
                    str = mobile.hidingPhone;
                }else
                {
                    str = mobile.totalPhone;
                }
//                [NSString stringWithFormat:@"%@ %@ %@",[[_telArray objectForIndex:i] substringWithRange:NSMakeRange(0, 3)],[[_telArray objectForIndex:i] substringWithRange:NSMakeRange(3, 4)],[[_telArray objectForIndex:i] substringWithRange:NSMakeRange(7, 4)]];//[_telArray objectForIndex:i];
                telBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50+44*i, groupView.width, 43.5)];
                telBtn.tag = 1000+i;
                telBtn.backgroundColor = [UIColor clearColor];
                [telBtn setTitle:str forState:UIControlStateNormal];
                [telBtn setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
                [telBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateHighlighted];
                telBtn.titleLabel.font = FONT(18);
                [telBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
                [groupView addSubview:telBtn];
                
                if (i==0) {
                    [groupView addSubview:[self createLineView:telBtn.bottom]];
                }
                groupView.height = 188;
                groupView.top = (self.height-188)/2;
            }
        }else
        {
            telBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, groupView.width, 43.5)];
            telBtn.tag = 1000;
            telBtn.backgroundColor = [UIColor clearColor];
            [telBtn setTitle:mobile.hidingPhone forState:UIControlStateNormal];
            [telBtn setTitleColor:NAVIGATIONTITLE forState:UIControlStateNormal];
            [telBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateHighlighted];
            telBtn.titleLabel.font = FONT(18);
            [telBtn addTarget:self action:@selector(toggleCallBtn:) forControlEvents:UIControlEventTouchUpInside];
            [groupView addSubview:telBtn];
            
//            [groupView addSubview:[self createLineView:telBtn.bottom]];
            groupView.height = 144;
            groupView.top = (self.height-144)/2;
        }
        [groupView addSubview:[self createLineView:telBtn.bottom]];
    }
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, telBtn.bottom+0.5, groupView.width, 50)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [cancleBtn setTitleColor:BLUEBTBCOLOR forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(toggleCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:cancleBtn];
    
}

//-(void)copyCancelViewBlock:(copyCancelBtnBlock)ablock
//{
//    self.didCancel = ablock;
//}

-(void)toggleCancleBtn
{
//    _didCancel();
    [self removeFromSuperview];
}

-(void)copyCustomerPhoneBlock:(copyBtnSelectedBlock)ablock
{
    _didCopyPhone = ablock;
}

- (void)toggleCallBtn:(UIButton*)sender
{
    NSInteger tag = sender.tag-1000;
    _didCopyPhone(tag);
    [self removeFromSuperview];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)recognizer
{
    [self removeFromSuperview];
}

- (BOOL) isBlankString:(NSString*)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (UIView *)createLineView:(CGFloat)y
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, groupView.width, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    return lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
